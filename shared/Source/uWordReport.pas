unit uWordReport;

interface

uses
  SysUtils, Classes, Windows, ComObj, Variants, ClipBrd;

type
  TReport = class
  private
    FCycled: Boolean;
  public
    constructor Create; virtual;
    //
    procedure Duplicate; virtual; abstract;
    procedure OpenFile(const Filename: String); virtual; abstract;
    procedure SaveAs(const FileName: String); virtual; abstract;
    procedure SaveText; virtual; abstract;
    procedure Show; virtual; abstract;
    procedure Shutdown; virtual; abstract;
    procedure ReplaceText(const FindText, ReplaceWith: String); virtual; abstract;
    procedure RestoreText; virtual; abstract;
    //
    property Cycled: Boolean read FCycled write FCycled;
  end;

  TMSWordReport = class(TReport)
  private
    FApp: Variant;
    FClipBoard: String;
    function AppEnabled: Boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
    //
    procedure Duplicate; override;
    procedure OpenFile(const FileName: String); override;
    procedure SaveAs(const FileName: String); override;
    procedure SaveText; override;
    procedure RestoreText; override;
    procedure Show; override;
    procedure ReplaceText(const FindText, ReplaceWith: String); override;
    procedure Shutdown; override;
  end;

implementation

function IsMSWordAvailable: Boolean;
var
  V: Variant;
begin
  try
    V := CreateOleObject('Word.Application');
    Result := not (VarIsEmpty(V) or VarIsNull(V) or VarIsClear(V));
    if Result then
      V.Quit;
    V := Unassigned;
  except
    Result := False;
  end;
end;

{ TReport }

constructor TReport.Create;
begin
  inherited;
end;

{ TMSWordReport }

constructor TMSWordReport.Create;
begin
  inherited;
  FApp := CreateOleObject('Word.Application');
end;

destructor TMSWordReport.Destroy;
begin
  FApp := Unassigned;
  inherited;
end;

procedure TMSWordReport.Duplicate;
const
  wdPageBreak = $00000007;
  wdCharacter = $00000001;
  wdGoToPage = $00000001;
begin
  FApp.Selection.GoToNext(wdGoToPage);
  FApp.Selection.InsertBreak(wdPageBreak);
  FApp.Selection.GoToPrevious(wdGoToPage);
  FApp.Selection.Paste;
end;

procedure TMSWordReport.OpenFile(const FileName: String);
var
  aFileName: OleVariant;
begin
  if not AppEnabled then
    Exit;
  aFileName := FileName;
  FApp.Documents.Open(aFilename, EmptyParam, EmptyParam, EmptyParam,
    EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam,
    EmptyParam, EmptyParam, EmptyParam);
end;

procedure TMSWordReport.ReplaceText(const FindText, ReplaceWith: String);
const
  wdReplaceAll = 2;
var
  S1, S2, Replace: OleVariant;
begin
  if not AppEnabled then
    Exit;
  S1 := FindText;
  S2 := ReplaceWith;
  Replace := 1;
  FApp.Selection.End := 0;
  FApp.Selection.Start := 0;
  FApp.Selection.Find.Forward := True;
  FApp.Selection.Find.Text := S1;
  while FApp.Selection.Find.Execute do
  begin
    FApp.Selection.Delete;
    FApp.Selection.TypeText(S2);
    FApp.Selection.End := 0;
    FApp.Selection.Start := 0;
  end;
end;

procedure TMSWordReport.RestoreText;
begin
  if FClipboard = '' then
    Clipboard.Clear
  else
    Clipboard.AsText := FClipboard;
end;

function TMSWordReport.AppEnabled: Boolean;
var
  S: OleVariant;
begin
  try
    S := FApp.Caption;
    Result := True;
  except
    Result := False;
  end;
end;

procedure TMSWordReport.SaveAs(const FileName: String);
var
  aFileName: OleVariant;
begin
  if not AppEnabled then
    Exit;
  aFileName := FileName;
  FApp.ActiveDocument.SaveAs(aFileName, EmptyParam, EmptyParam,
    EmptyParam, EmptyParam, EmptyParam, EmptyParam , EmptyParam,
    EmptyParam, EmptyParam, EmptyParam);
end;

procedure TMSWordReport.SaveText;
begin
  if Clipboard.HasFormat(CF_TEXT) then
    FClipboard := Clipboard.AsText
  else
    FClipboard := '';
  FApp.Selection.WholeStory;
  FApp.Selection.Copy;
end;

procedure TMSWordReport.Show;
begin
  if not FApp.Visible then
    FApp.Visible := OleVariant(True);
  FApp.{ActiveWindow.}Activate;
end;

procedure TMSWordReport.Shutdown;
begin
  if AppEnabled then
    FApp.Quit;
end;

end.
