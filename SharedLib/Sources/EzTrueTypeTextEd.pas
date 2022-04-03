unit EzTrueTypeTextEd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, EzEntities, ovcbase, ovcrlbl, ovccmbx,
  ovcftcbx, ExtCtrls;

type
  TfrmTrueTypeTextEditor = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    FontDlg: TFontDialog;
    lFontExample: TLabel;
    edAngle: TEdit;
    udAngle: TUpDown;
    btnSelectFont: TButton;
    rlAngle: TOvcRotatedLabel;
    FontCombobox: TOvcFontComboBox;
    Button1: TButton;
    Button2: TButton;
    edFontSize: TEdit;
    udFontSize: TUpDown;
    mText: TMemo;
    procedure btnSelectFontClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure udAngleChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Smallint; Direction: TUpDownDirection);
    procedure FontComboboxChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edAngleKeyPress(Sender: TObject; var Key: Char);
    procedure edFontSizeKeyPress(Sender: TObject; var Key: Char);
    procedure udFontSizeChangingEx(Sender: TObject;
      var AllowChange: Boolean; NewValue: Smallint;
      Direction: TUpDownDirection);
  private
    FObj: TEzTrueTypeText;
    procedure FontChange;
  public
    { Public declarations }
  end;

  function ShowTrueTypeTextEditor(var ttt_obj: TEzTrueTypeText): Boolean;

implementation

uses
  EzLib, EzScene,
  EzUtils, uCommonUtils;

{$R *.dfm}

var
  frmTrueTypeTextEditor: TfrmTrueTypeTextEditor;

function ShowTrueTypeTextEditor(var ttt_obj: TEzTrueTypeText): Boolean;
var
  xMax, xMin, yMax, yMin: Double;
begin
  if frmTrueTypeTextEditor = nil then frmTrueTypeTextEditor := TfrmTrueTypeTextEditor.Create(Application);
  with frmTrueTypeTextEditor do
  try
    FObj.Assign(ttt_obj);
    mText.Text := ttt_obj.Text;
    FontDlg.Font.Name := ttt_obj.FontTool.Name;
    FontDlg.Font.Style := ttt_obj.FontTool.Style;
    ttt_obj.MaxMinExtents(xMin, yMin, xMax, yMax);
    FontDlg.Font.Height := ScreenFontHeight500(ttt_obj.FontTool.Height, Screen.PixelsPerInch);
    FontDlg.Font.Color := ttt_obj.FontTool.Color;
    FontChange;
    udAngle.Position := Trunc(ttt_obj.FontTool.Angle / pi * 180);
    result := ShowModal = mrOK;
    if result then
    begin
      FObj.Text := mText.Text;
      ttt_obj.Assign(FObj);
    end;
  finally
    ;
  end;
end;

procedure TfrmTrueTypeTextEditor.btnSelectFontClick(Sender: TObject);
begin
  if FontDlg.Execute then
  begin
    FontChange;
  end;
end;

procedure TfrmTrueTypeTextEditor.Button1Click(Sender: TObject);
begin
  if Trim(mText.Text) = '' then
  begin
    mText.SetFocus;
    MessageDlg('Необходимо ввести текст!', mtWarning, [mbOK], 0);
  end
  else
    ModalResult := mrOK;
end;

procedure TfrmTrueTypeTextEditor.FontChange;
begin
  with FontDlg.Font do
  begin
    FObj.FontTool.Name := Name;
    FObj.FontTool.Style := Style;
    FObj.FontTool.Height := WorldFontHeight500(FontDlg.Font);
    FObj.FontTool.Color := Color;
    lFontExample.Font.Assign(FontDlg.Font);
    FontCombobox.FontName := Name;
    udFontSize.Position := Size;
  end;
end;

procedure TfrmTrueTypeTextEditor.udAngleChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
  AllowChange := (NewValue >= -360) and (NewValue <= 360);
  if AllowChange then
  begin
    rlAngle.FontAngle := NewValue;
    FObj.FontTool.Angle := NewValue / 180 * pi;
  end;
end;

procedure TfrmTrueTypeTextEditor.FontComboboxChange(Sender: TObject);
begin
  FontDlg.Font.Name := FontCombobox.FontName;
  FontChange;
end;

procedure TfrmTrueTypeTextEditor.FormCreate(Sender: TObject);
begin
  FObj := EmptyEzTrueTypeText;
end;

procedure TfrmTrueTypeTextEditor.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FObj);
end;

procedure TfrmTrueTypeTextEditor.edAngleKeyPress(Sender: TObject;
  var Key: Char);
var
  i: Integer;
begin
  if Key = #13 then
  begin
    try
      i := StrToInt(edAngle.Text);
    except
      i := udAngle.Position;
    end;
    rlAngle.FontAngle := i;
    udAngle.Position := i;
  end;
end;

procedure TfrmTrueTypeTextEditor.edFontSizeKeyPress(Sender: TObject;
  var Key: Char);
var
  i: Integer;
begin
  if Key = #13 then
  begin
    try
      i := StrToInt(edFontSize.Text);
    except
      i := udFontSize.Position;
    end;
    udFontSize.Position := i;
  end;
end;

procedure TfrmTrueTypeTextEditor.udFontSizeChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
  if FontDlg.Font.Size <> NewValue then
  begin
    FontDlg.Font.Size := NewValue;
    FontChange;
  end;
end;

end.
