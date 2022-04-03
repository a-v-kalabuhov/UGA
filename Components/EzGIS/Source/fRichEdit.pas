unit fRichEdit;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Buttons, EzBaseGis;

type
  TfrmRichTextEditor = class(TForm)
    Editor: TRichEdit;
    BoldButton: TSpeedButton;
    ItalicButton: TSpeedButton;
    UnderlineButton: TSpeedButton;
    BtnColor: TSpeedButton;
    LeftAlign: TSpeedButton;
    CenterAlign: TSpeedButton;
    RightAlign: TSpeedButton;
    BulletsButton: TSpeedButton;
    FontName: TComboBox;
    FontSize: TEdit;
    UpDown1: TUpDown;
    BtnOk: TButton;
    Button2: TButton;
    FontDialog1: TFontDialog;
    SpeedButton1: TSpeedButton;
    OpenDialog1: TOpenDialog;
    procedure EditorSelectionChange(Sender: TObject);
    procedure BoldButtonClick(Sender: TObject);
    procedure FontNameChange(Sender: TObject);
    procedure FontSizeChange(Sender: TObject);
    procedure BulletsButtonClick(Sender: TObject);
    procedure BtnColorClick(Sender: TObject);
    procedure LeftAlignClick(Sender: TObject);
    procedure ItalicButtonClick(Sender: TObject);
    procedure UnderlineButtonClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
    FEntity: TEzEntity;
    FUpdating: Boolean;
    function CurrText: TTextAttributes;
    procedure GetFontNames;
  public
    { Public declarations }
    class function Enter(Entity: TEzEntity): Word;
  end;

implementation

{$R *.DFM}

uses
  EzMiscelEntities;

{ TfrmRichTextEditor }

class function TfrmRichTextEditor.Enter(Entity: TEzEntity): Word;
var
  MemStream: TMemoryStream;
begin
  with TfrmRichTextEditor.Create(Nil) do
    try
      GetFontNames;
      CurrText.Name := DefFontData.Name;
      CurrText.Size := -MulDiv(DefFontData.Height, 72, Screen.PixelsPerInch);
      FEntity:= Entity;
      MemStream:= TMemoryStream.Create;
      try
        TEzRtfText(Entity).Lines.SaveToStream(MemStream);
        MemStream.Position:= 0;
        Editor.Lines.LoadFromStream(MemStream)
      finally
        MemStream.Free;
      end;
      Result:= ShowModal;
      if Result= mrOk then
      begin
        MemStream:= TMemoryStream.Create;
        try
          Editor.Lines.SaveToStream(MemStream);
          MemStream.Position:= 0;
          TEzRtfText(Entity).Lines.LoadFromStream(MemStream);
        finally
          MemStream.Free;
        end;
      end;
    finally
      Free;
    end;
end;

procedure TfrmRichTextEditor.EditorSelectionChange(Sender: TObject);
begin
  with Editor.Paragraph do
  try
    FUpdating := True;
    BoldButton.Down := fsBold in Editor.SelAttributes.Style;
    ItalicButton.Down := fsItalic in Editor.SelAttributes.Style;
    UnderlineButton.Down := fsUnderline in Editor.SelAttributes.Style;
    BulletsButton.Down := Boolean(Numbering);
    FontSize.Text := IntToStr(Editor.SelAttributes.Size);
    FontName.ItemIndex := FontName.Items.IndexOf(Editor.SelAttributes.Name);
    case Ord(Alignment) of
      0: LeftAlign.Down := True;
      1: RightAlign.Down := True;
      2: CenterAlign.Down := True;
    end;
  finally
    FUpdating := False;
  end;
end;

function TfrmRichTextEditor.CurrText: TTextAttributes;
begin
  if Editor.SelLength > 0 then Result := Editor.SelAttributes
  else Result := Editor.DefAttributes;
end;

function EnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric;
  FontType: Integer; Data: Pointer): Integer; stdcall;
begin
  TStrings(Data).Add(LogFont.lfFaceName);
  Result := 1;
end;

procedure TfrmRichTextEditor.GetFontNames;
var
  DC: HDC;
begin
  DC := GetDC(0);
  EnumFonts(DC, nil, @EnumFontsProc, Pointer(FontName.Items));
  ReleaseDC(0, DC);
  FontName.Sorted := True;
end;

procedure TfrmRichTextEditor.BoldButtonClick(Sender: TObject);
begin
  if FUpdating then Exit;
  if BoldButton.Down then
    CurrText.Style := CurrText.Style + [fsBold]
  else
    CurrText.Style := CurrText.Style - [fsBold];
end;

procedure TfrmRichTextEditor.FontNameChange(Sender: TObject);
begin
  if FUpdating then Exit;
  CurrText.Name := FontName.Items[FontName.ItemIndex];
end;

procedure TfrmRichTextEditor.FontSizeChange(Sender: TObject);
begin
  if FUpdating then Exit;
  CurrText.Size := StrToInt(FontSize.Text);
end;

procedure TfrmRichTextEditor.BulletsButtonClick(Sender: TObject);
begin
  if FUpdating then Exit;
  Editor.Paragraph.Numbering := TNumberingStyle(BulletsButton.Down);
end;

procedure TfrmRichTextEditor.BtnColorClick(Sender: TObject);
begin
  FontDialog1.Font.Assign(Editor.SelAttributes);
  if FontDialog1.Execute then
    CurrText.Assign(FontDialog1.Font);
  Windows.SetFocus(Editor.Handle);
end;

procedure TfrmRichTextEditor.LeftAlignClick(Sender: TObject);
begin
  if FUpdating then Exit;
  Editor.Paragraph.Alignment := TAlignment(TControl(Sender).Tag);
end;

procedure TfrmRichTextEditor.ItalicButtonClick(Sender: TObject);
begin
  if FUpdating then Exit;
  if ItalicButton.Down then
    CurrText.Style := CurrText.Style + [fsItalic]
  else
    CurrText.Style := CurrText.Style - [fsItalic];
end;

procedure TfrmRichTextEditor.UnderlineButtonClick(Sender: TObject);
begin
  if FUpdating then Exit;
  if UnderlineButton.Down then
    CurrText.Style := CurrText.Style + [fsUnderline]
  else
    CurrText.Style := CurrText.Style - [fsUnderline];
end;

procedure TfrmRichTextEditor.SpeedButton1Click(Sender: TObject);
begin
  if not OpenDialog1.Execute then Exit;
  Editor.Lines.LoadFromFile(OpenDialog1.FileName);
end;

end.
