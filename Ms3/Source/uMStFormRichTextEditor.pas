unit uMStFormRichTextEditor;

interface

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Menus, ComCtrls, ClipBrd,
  ToolWin, ActnList, ImgList;

type
  TfrmEzRichTextEditor = class(TForm)
    MainMenu: TMainMenu;
    FileNewItem: TMenuItem;
    FileOpenItem: TMenuItem;
    FileSaveItem: TMenuItem;
    FileSaveAsItem: TMenuItem;
    FilePrintItem: TMenuItem;
    FileExitItem: TMenuItem;
    EditUndoItem: TMenuItem;
    EditCutItem: TMenuItem;
    EditCopyItem: TMenuItem;
    EditPasteItem: TMenuItem;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    PrintDialog: TPrintDialog;
    Ruler: TPanel;
    FontDialog1: TFontDialog;
    FirstInd: TLabel;
    LeftInd: TLabel;
    RulerLine: TBevel;
    RightInd: TLabel;
    N5: TMenuItem;
    miEditFont: TMenuItem;
    Editor: TRichEdit;
    StatusBar: TStatusBar;
    StandardToolBar: TToolBar;
    OpenButton: TToolButton;
    SaveButton: TToolButton;
    PrintButton: TToolButton;
    ToolButton5: TToolButton;
    UndoButton: TToolButton;
    CutButton: TToolButton;
    CopyButton: TToolButton;
    PasteButton: TToolButton;
    ToolButton10: TToolButton;
    FontName: TComboBox;
    FontSize: TEdit;
    ToolButton11: TToolButton;
    UpDown1: TUpDown;
    BoldButton: TToolButton;
    ItalicButton: TToolButton;
    UnderlineButton: TToolButton;
    ToolButton16: TToolButton;
    LeftAlign: TToolButton;
    CenterAlign: TToolButton;
    RightAlign: TToolButton;
    ToolButton20: TToolButton;
    BulletsButton: TToolButton;
    ToolbarImages: TImageList;
    ActionList1: TActionList;
    FileNewCmd: TAction;
    FileOpenCmd: TAction;
    FileSaveCmd: TAction;
    FilePrintCmd: TAction;
    FileExitCmd: TAction;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    Bevel1: TBevel;
    EditCutCmd: TAction;
    EditCopyCmd: TAction;
    EditPasteCmd: TAction;
    EditUndoCmd: TAction;
    EditFontCmd: TAction;
    FileSaveAsCmd: TAction;

    procedure SelectionChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FileNew(Sender: TObject);
    procedure FileOpen(Sender: TObject);
    procedure FileSave(Sender: TObject);
    procedure FileSaveAs(Sender: TObject);
    procedure FilePrint(Sender: TObject);
    procedure FileExit(Sender: TObject);
    procedure EditUndo(Sender: TObject);
    procedure EditCut(Sender: TObject);
    procedure EditCopy(Sender: TObject);
    procedure EditPaste(Sender: TObject);
    procedure SelectFont(Sender: TObject);
    procedure RulerResize(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure BoldButtonClick(Sender: TObject);
    procedure ItalicButtonClick(Sender: TObject);
    procedure FontSizeChange(Sender: TObject);
    procedure AlignButtonClick(Sender: TObject);
    procedure FontNameChange(Sender: TObject);
    procedure UnderlineButtonClick(Sender: TObject);
    procedure BulletsButtonClick(Sender: TObject);
    procedure RulerItemMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RulerItemMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FirstIndMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LeftIndMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RightIndMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure RichEditChange(Sender: TObject);
    procedure ActionList2Update(Action: TBasicAction;
      var Handled: Boolean);
    procedure FileNewCmdUpdate(Sender: TObject);
    procedure FileOpenCmdUpdate(Sender: TObject);
    procedure FileSaveCmdUpdate(Sender: TObject);
    procedure FileSaveAsCmdUpdate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FFileName: string;
    FUpdating: Boolean;
    FDragOfs: Integer;
    FDragging: Boolean;
    function CurrText: TTextAttributes;
    procedure GetFontNames;
    procedure SetFileName(const FileName: String);
    procedure CheckFileSave;
    procedure SetupRuler;
    procedure SetEditRect;
    procedure UpdateCursorPos;
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
    procedure PerformFileOpen(const AFileName: string);
    procedure SetModified(Value: Boolean);
  public
    procedure SetParam(pName, pValue: String);
    procedure DrawOn(pCanvas: TCanvas; pLeft, pTop: Integer; pHSize, pVSize: Double); overload;
    procedure DrawOn(pCanvas: TCanvas; pTextRect: TRect); overload;
  end;

//  function ShowEzRichTextEditor(RichText: TEzRtfText; FileName: String): Boolean;
  procedure RTF_DrawOn(pFilename: String; pCanvas: TCanvas; pRect: TRect);

var
  frmEzRichTextEditor: TfrmEzRichTextEditor;
  
implementation

uses RichEdit, ShellAPI, Printers, uCommonUtils;

resourcestring
  sSaveChanges = 'Сохранить изменения в %s?';
  sOverWrite = 'Заменить %s';
  sUntitled = 'Безимянный';
  sModified = 'Изменен';
  sColRowInfo = 'Строка: %3d   Столбец: %3d';

const
  RulerAdj = 4/3;
  GutterWid = 6;

{$R *.dfm}


{function ShowEzRichTextEditor(RichText: TEzRtfText; FileName: String): Boolean;
var
  Mstr: TMemoryStream;
  UseStream: Boolean;
begin
  if frmEzRichTextEditor = nil then frmEzRichTextEditor := TfrmEzRichTextEditor.Create(Application);
  with frmEzRichTextEditor do
  begin
    UseStream := FileName = EmptyStr;
    if UseStream then
    try
      Mstr := TMemoryStream.Create;
      RichText.Lines.SaveToStream(Mstr);
      Mstr.Position := 0;
      Editor.Lines.LoadFromStream(Mstr);
    finally
      FreeAndNil(Mstr);
    end
//      Editor.Lines := RichText.Lines
    else
      Editor.Lines.LoadFromFile(filename);
    Result := ShowModal = mrYes ;
    if Result then
      if UseStream then
      try
        Mstr := TMemoryStream.Create;
        Editor.Lines.SaveToStream(Mstr);
        Mstr.Position := 0;
        RichText.Lines.LoadFromStream(Mstr);
      finally
        FreeAndNil(Mstr);
      end
      else
      begin
        Editor.Lines.SaveToFile(filename);
        Richtext.Lines.LoadFromFile(filename);
      end;
  end;
end;  }

procedure RTF_DrawOn(pFilename: String; pCanvas: TCanvas; pRect: TRect);
begin
  if frmEzRichTextEditor = nil then frmEzRichTextEditor := TfrmEzRichTextEditor.Create(Application);
  with frmEzRichTextEditor do
  begin
    Editor.Lines.LoadFromFile(pFilename);
    DrawOn(pCanvas, pRect);
  end;
end;

procedure TfrmEzRichTextEditor.SelectionChange(Sender: TObject);
begin
  with Editor.Paragraph do
  try
    FUpdating := True;
    FirstInd.Left := Trunc(FirstIndent*RulerAdj)-4+GutterWid;
    LeftInd.Left := Trunc((LeftIndent+FirstIndent)*RulerAdj)-4+GutterWid;
    RightInd.Left := Ruler.ClientWidth-6-Trunc((RightIndent+GutterWid)*RulerAdj);
    BoldButton.Down := fsBold in Editor.SelAttributes.Style;
    ItalicButton.Down := fsItalic in Editor.SelAttributes.Style;
    UnderlineButton.Down := fsUnderline in Editor.SelAttributes.Style;
    BulletsButton.Down := Boolean(Numbering);
    FontSize.Text := IntToStr(Editor.SelAttributes.Size);
    FontName.Text := Editor.SelAttributes.Name;
    case Ord(Alignment) of
      0: LeftAlign.Down := True;
      1: RightAlign.Down := True;
      2: CenterAlign.Down := True;
    end;
    UpdateCursorPos;
  finally
    FUpdating := False;
  end;
end;

function TfrmEzRichTextEditor.CurrText: TTextAttributes;
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

procedure TfrmEzRichTextEditor.GetFontNames;
var
  DC: HDC;
begin
  DC := GetDC(0);
  EnumFonts(DC, nil, @EnumFontsProc, Pointer(FontName.Items));
  ReleaseDC(0, DC);
  FontName.Sorted := True;
end;

procedure TfrmEzRichTextEditor.SetFileName(const FileName: String);
begin
  FFileName := FileName;
  Caption := Format('%s - %s', [ExtractFileName(FileName), Application.Title]);
end;

procedure TfrmEzRichTextEditor.CheckFileSave;
var
  SaveResp: Integer;
begin
  if not Editor.Modified then Exit;
  SaveResp := MessageDlg(Format(sSaveChanges, [FFileName]),
    mtConfirmation, mbYesNoCancel, 0);
  case SaveResp of
    idYes: FileSave(Self);
    idNo: {Nothing};
    idCancel: Abort;
  end;
end;

procedure TfrmEzRichTextEditor.SetupRuler;
var
  I: Integer;
  S: String;
begin
  SetLength(S, 201);
  I := 1;
  while I < 200 do
  begin
    S[I] := #9;
    S[I+1] := '|';
    Inc(I, 2);
  end;
  Ruler.Caption := S;
end;

procedure TfrmEzRichTextEditor.SetEditRect;
var
  R: TRect;
begin
  with Editor do
  begin
    R := Rect(GutterWid, 0, ClientWidth-GutterWid, ClientHeight);
    SendMessage(Handle, EM_SETRECT, 0, Longint(@R));
  end;
end;

{ Event Handlers }

procedure TfrmEzRichTextEditor.FormCreate(Sender: TObject);
begin
//  Application.OnHint := ShowHint;
  OpenDialog.InitialDir := ExtractFilePath(ParamStr(0));
  SaveDialog.InitialDir := OpenDialog.InitialDir;
  SetFileName(sUntitled);
  GetFontNames;
  SetupRuler;
  SelectionChange(Self);

  CurrText.Name := DefFontData.Name;
  CurrText.Size := -MulDiv(DefFontData.Height, 72, Screen.PixelsPerInch);
end;

procedure TfrmEzRichTextEditor.FileNew(Sender: TObject);
begin
  SetFileName(sUntitled);
  Editor.Lines.Clear;
  Editor.Modified := False;
  SetModified(False);
end;

procedure TfrmEzRichTextEditor.PerformFileOpen(const AFileName: string);
begin
  Editor.Lines.LoadFromFile(AFileName);
  SetFileName(AFileName);
  Editor.SetFocus;
  Editor.Modified := False;
  SetModified(False);
end;

procedure TfrmEzRichTextEditor.FileOpen(Sender: TObject);
begin
  CheckFileSave;
  if OpenDialog.Execute then
  begin
    PerformFileOpen(OpenDialog.FileName);
    Editor.ReadOnly := ofReadOnly in OpenDialog.Options;
  end;
end;

procedure TfrmEzRichTextEditor.FileSave(Sender: TObject);
begin
  if FFileName = sUntitled then
    FileSaveAs(Sender)
  else
  begin
    Editor.Lines.SaveToFile(FFileName);
    Editor.Modified := False;
    SetModified(False);
  end;
end;

procedure TfrmEzRichTextEditor.FileSaveAs(Sender: TObject);
begin
  if SaveDialog.Execute then
  begin
    if FileExists(SaveDialog.FileName) then
      if MessageDlg(Format(sOverWrite, [SaveDialog.FileName]),
        mtConfirmation, mbYesNoCancel, 0) <> idYes then Exit;
    Editor.Lines.SaveToFile(SaveDialog.FileName);
    SetFileName(SaveDialog.FileName);
    Editor.Modified := False;
    SetModified(False);
  end;
end;

procedure TfrmEzRichTextEditor.FilePrint(Sender: TObject);
var
  r: TRect;
begin
  if PrintDialog.Execute then
  begin
    r := Editor.PageRect;
    Editor.PageRect := r;
    Editor.Print(FFileName);
  end;
end;

procedure TfrmEzRichTextEditor.FileExit(Sender: TObject);
begin
  Close;
end;

procedure TfrmEzRichTextEditor.EditUndo(Sender: TObject);
begin
  with Editor do
    if HandleAllocated then SendMessage(Handle, EM_UNDO, 0, 0);
end;

procedure TfrmEzRichTextEditor.EditCut(Sender: TObject);
begin
  Editor.CutToClipboard;
end;

procedure TfrmEzRichTextEditor.EditCopy(Sender: TObject);
begin
  Editor.CopyToClipboard;
end;

procedure TfrmEzRichTextEditor.EditPaste(Sender: TObject);
begin
  Editor.PasteFromClipboard;
end;

procedure TfrmEzRichTextEditor.SelectFont(Sender: TObject);
begin
  FontDialog1.Font.Assign(Editor.SelAttributes);
  if FontDialog1.Execute then
    CurrText.Assign(FontDialog1.Font);
  SelectionChange(Self);
  Editor.SetFocus;
end;

procedure TfrmEzRichTextEditor.RulerResize(Sender: TObject);
begin
  RulerLine.Width := Ruler.ClientWidth - (RulerLine.Left*2);
end;

procedure TfrmEzRichTextEditor.FormResize(Sender: TObject);
begin
  SetEditRect;
  SelectionChange(Sender);
end;

procedure TfrmEzRichTextEditor.FormPaint(Sender: TObject);
begin
  SetEditRect;
end;

procedure TfrmEzRichTextEditor.BoldButtonClick(Sender: TObject);
begin
  if FUpdating then Exit;
  if BoldButton.Down then
    CurrText.Style := CurrText.Style + [fsBold]
  else
    CurrText.Style := CurrText.Style - [fsBold];
end;

procedure TfrmEzRichTextEditor.ItalicButtonClick(Sender: TObject);
begin
  if FUpdating then Exit;
  if ItalicButton.Down then
    CurrText.Style := CurrText.Style + [fsItalic]
  else
    CurrText.Style := CurrText.Style - [fsItalic];
end;

procedure TfrmEzRichTextEditor.FontSizeChange(Sender: TObject);
begin
  if FUpdating then Exit;
  CurrText.Size := StrToInt(FontSize.Text);
end;

procedure TfrmEzRichTextEditor.AlignButtonClick(Sender: TObject);
begin
  if FUpdating then Exit;
  Editor.Paragraph.Alignment := TAlignment(TControl(Sender).Tag);
end;

procedure TfrmEzRichTextEditor.FontNameChange(Sender: TObject);
begin
  if FUpdating then Exit;
  CurrText.Name := FontName.Items[FontName.ItemIndex];
end;

procedure TfrmEzRichTextEditor.UnderlineButtonClick(Sender: TObject);
begin
  if FUpdating then Exit;
  if UnderlineButton.Down then
    CurrText.Style := CurrText.Style + [fsUnderline]
  else
    CurrText.Style := CurrText.Style - [fsUnderline];
end;

procedure TfrmEzRichTextEditor.BulletsButtonClick(Sender: TObject);
begin
  if FUpdating then Exit;
  Editor.Paragraph.Numbering := TNumberingStyle(BulletsButton.Down);
end;

{ Ruler Indent Dragging }

procedure TfrmEzRichTextEditor.RulerItemMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FDragOfs := (TLabel(Sender).Width div 2);
  TLabel(Sender).Left := TLabel(Sender).Left+X-FDragOfs;
  FDragging := True;
end;

procedure TfrmEzRichTextEditor.RulerItemMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if FDragging then
    TLabel(Sender).Left :=  TLabel(Sender).Left+X-FDragOfs
end;

procedure TfrmEzRichTextEditor.FirstIndMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FDragging := False;
  Editor.Paragraph.FirstIndent := Trunc((FirstInd.Left+FDragOfs-GutterWid) / RulerAdj);
  LeftIndMouseUp(Sender, Button, Shift, X, Y);
end;

procedure TfrmEzRichTextEditor.LeftIndMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FDragging := False;
  Editor.Paragraph.LeftIndent := Trunc((LeftInd.Left+FDragOfs-GutterWid) / RulerAdj)-Editor.Paragraph.FirstIndent;
  SelectionChange(Sender);
end;

procedure TfrmEzRichTextEditor.RightIndMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FDragging := False;
  Editor.Paragraph.RightIndent := Trunc((Ruler.ClientWidth-RightInd.Left+FDragOfs-2) / RulerAdj)-2*GutterWid;
  SelectionChange(Sender);
end;

procedure TfrmEzRichTextEditor.UpdateCursorPos;
var
  CharPos: TPoint;
begin
  CharPos.Y := SendMessage(Editor.Handle, EM_EXLINEFROMCHAR, 0,
    Editor.SelStart);
  CharPos.X := (Editor.SelStart -
    SendMessage(Editor.Handle, EM_LINEINDEX, CharPos.Y, 0));
  Inc(CharPos.Y);
  Inc(CharPos.X);
  StatusBar.Panels[0].Text := Format(sColRowInfo, [CharPos.Y, CharPos.X]);
end;

procedure TfrmEzRichTextEditor.FormShow(Sender: TObject);
begin
  UpdateCursorPos;
  DragAcceptFiles(Handle, True);
  RichEditChange(nil);
  Editor.SetFocus;
  { Check if we should load a file from the command line }
  if (ParamCount > 0) and FileExists(ParamStr(1)) then
    PerformFileOpen(ParamStr(1));
end;

procedure TfrmEzRichTextEditor.WMDropFiles(var Msg: TWMDropFiles);
var
  CFileName: array[0..MAX_PATH] of Char;
begin
  try
    if DragQueryFile(Msg.Drop, 0, CFileName, MAX_PATH) > 0 then
    begin
      CheckFileSave;
      PerformFileOpen(CFileName);
      Msg.Result := 0;
    end;
  finally
    DragFinish(Msg.Drop);
  end;
end;

procedure TfrmEzRichTextEditor.RichEditChange(Sender: TObject);
begin
  SetModified(Editor.Modified);
end;

procedure TfrmEzRichTextEditor.SetModified(Value: Boolean);
begin
  if Value then StatusBar.Panels[1].Text := sModified
  else StatusBar.Panels[1].Text := EmptyStr;
end;

procedure TfrmEzRichTextEditor.ActionList2Update(Action: TBasicAction;
  var Handled: Boolean);
begin
 { Update the status of the edit commands }
  EditCutCmd.Enabled := Editor.SelLength > 0;
  EditCopyCmd.Enabled := EditCutCmd.Enabled;
  if Editor.HandleAllocated then
  begin
    EditUndoCmd.Enabled := Editor.Perform(EM_CANUNDO, 0, 0) <> 0;
    EditPasteCmd.Enabled := Editor.Perform(EM_CANPASTE, 0, 0) <> 0;
  end;
end;

procedure TfrmEzRichTextEditor.SetParam(pName, pValue: String);
var
  i: Integer;
begin
  with Editor do
  begin
    i := FindText(pName, 0, Length(Text), []);
    SelStart := i;
    SelLength := Length(pName);
    SelText := pValue;
  end;
end;

procedure TfrmEzRichTextEditor.FileNewCmdUpdate(Sender: TObject);
begin
  FileNewCmd.Enabled := False;
end;

procedure TfrmEzRichTextEditor.FileOpenCmdUpdate(Sender: TObject);
begin
  FileOpenCmd.Enabled := True;
end;

procedure TfrmEzRichTextEditor.FileSaveCmdUpdate(Sender: TObject);
begin
  FileSaveCmd.Enabled := True;
end;

procedure TfrmEzRichTextEditor.FileSaveAsCmdUpdate(Sender: TObject);
begin
  FileSaveAsCmd.Enabled := True;
end;

procedure TfrmEzRichTextEditor.DrawOn(pCanvas: TCanvas; pLeft,
  pTop: Integer; pHSize, pVSize: Double);
var
  Range: TFormatRange;
  intPPI_X, intPPI_Y: Integer;
  //pPWidth, pPHeight,
  pPLeft, pPTop: Integer;
begin
      with Editor, Range do
      begin
        SendMessage(Handle, EM_FORMATRANGE, 0, 0);
        FillChar(Range, SizeOf(TFormatRange), 0);
        hdc := pCanvas.Handle;
        hdcTarget := pCanvas.Handle;
        intPPI_X := GetDeviceCaps(pCanvas.Handle, LOGPIXELSX);
        intPPI_Y := GetDeviceCaps(pCanvas.Handle, LOGPIXELSY);
        //pPWidth := GetDeviceCaps(pCanvas.Handle, HORZRES);
        //pPHeight := GetDeviceCaps(pCanvas.Handle, VERTRES);
        pPLeft := pLeft;
        pPTop := pTop;
        rc := Rect(pPLeft, pPTop,
                   Trunc(pPLeft + pHSize * intPPI_X),
                   Trunc(pPTop + pVSize * intPPI_Y));
//        rcPage := Rect(0, 0, pPWidth, pPHeight);
        rcPage := rc;
        chrg.cpMax := -1;
        Perform(EM_FORMATRANGE, 1, Longint(@Range));
        Perform(EM_FORMATRANGE, 0, 0);
      end;
end;

procedure TfrmEzRichTextEditor.DrawOn(pCanvas: TCanvas; pTextRect: TRect);
var
  Range: TFormatRange;
  intPPI_X, intPPI_Y: Integer;
begin
  with Editor, Range do
  begin
    SendMessage(Handle, EM_FORMATRANGE, 0, 0);
    FillChar(Range, SizeOf(TFormatRange), 0);
    hdc := pCanvas.Handle;
    hdcTarget := pCanvas.Handle;
    intPPI_X := GetDeviceCaps(pCanvas.Handle, LOGPIXELSX);
    intPPI_Y := GetDeviceCaps(pCanvas.Handle, LOGPIXELSY);
    with pTextRect do
    rc := Rect(Trunc(Left * 1440 / intPPI_X),
               Trunc(Top * 1440 / intPPI_Y),
               Trunc(Right * 1440 / intPPI_X),
               Trunc(Bottom * 1440 / intPPI_Y));
    rcPage := rc;
    chrg.cpMax := -1;
    Perform(EM_FORMATRANGE, 1, Longint(@Range));
    Perform(EM_FORMATRANGE, 0, 0);
  end;
end;

procedure TfrmEzRichTextEditor.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  Res: TModalResult;
begin
  CanClose := True;
  Res := MessageBox(Handle, PChar('Сохранить изменения?'), PChar('Подтерждение'),
    MB_YESNOCANCEL + MB_ICONQUESTION) ;
  CanClose := Res <> mrCancel;
  if CanClose then
    ModalResult := Res;
end;

end.
