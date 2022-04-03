unit uMStFormCoordTableSettingsEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, JvColorCombo, JvExStdCtrls, JvCombobox;

type
  TmstCoordTableSettingsEditor = class(TForm)
    gbCaption: TGroupBox;
    cbFont1: TJvFontComboBox;
    edSize1: TEdit;
    UpDown1: TUpDown;
    FontDialog: TFontDialog;
    btnSel1: TButton;
    Label1: TLabel;
    gbContour: TGroupBox;
    Label2: TLabel;
    cbFont2: TJvFontComboBox;
    edSize2: TEdit;
    UpDown2: TUpDown;
    btnSel2: TButton;
    gbCell: TGroupBox;
    Label3: TLabel;
    cbFont3: TJvFontComboBox;
    edSize3: TEdit;
    UpDown3: TUpDown;
    btnSel3: TButton;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSel1Click(Sender: TObject);
    procedure btnSel2Click(Sender: TObject);
    procedure btnSel3Click(Sender: TObject);
    procedure cbFont1Change(Sender: TObject);
    procedure cbFont2Change(Sender: TObject);
    procedure cbFont3Change(Sender: TObject);
    procedure edSize1Change(Sender: TObject);
    procedure edSize2Change(Sender: TObject);
    procedure edSize3Change(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    FFont1: TFont;
    FFont2: TFont;
    FFont3: TFont;
    procedure SetFont1(const Value: TFont);
    procedure SetFont2(const Value: TFont);
    procedure SetFont3(const Value: TFont);
  public
    property Font1: TFont read FFont1 write SetFont1;
    property Font2: TFont read FFont2 write SetFont2;
    property Font3: TFont read FFont3 write SetFont3;
  end;

implementation

{$R *.dfm}

procedure TmstCoordTableSettingsEditor.btnSel1Click(Sender: TObject);
begin
  FontDialog.Font := Font1;
  if FontDialog.Execute then
    Font1 := FontDialog.Font;
end;

procedure TmstCoordTableSettingsEditor.SetFont1(const Value: TFont);
begin
  FFont1.Assign(Value);
  cbFont1.FontName := Font1.Name;
  UpDown1.Position := Font1.Size;
end;

procedure TmstCoordTableSettingsEditor.SetFont2(const Value: TFont);
begin
  FFont2.Assign(Value);
  cbFont2.FontName := Font2.Name;
  UpDown2.Position := Font2.Size;
end;

procedure TmstCoordTableSettingsEditor.SetFont3(const Value: TFont);
begin
  FFont3.Assign(Value);
  cbFont3.FontName := Font3.Name;
  UpDown3.Position := Font3.Size;
end;

procedure TmstCoordTableSettingsEditor.FormCreate(Sender: TObject);
begin
  FFont1 := TFont.Create;
  FFont2 := TFont.Create;
  FFont3 := TFont.Create;
end;

procedure TmstCoordTableSettingsEditor.FormDestroy(Sender: TObject);
begin
  FFont3.Free;
  FFont2.Free;
  FFont1.Free;
end;

procedure TmstCoordTableSettingsEditor.btnSel2Click(Sender: TObject);
begin
  FontDialog.Font := Font2;
  if FontDialog.Execute then
    Font2 := FontDialog.Font;
end;

procedure TmstCoordTableSettingsEditor.btnSel3Click(Sender: TObject);
begin
  FontDialog.Font := Font3;
  if FontDialog.Execute then
    Font3 := FontDialog.Font;
end;

procedure TmstCoordTableSettingsEditor.cbFont1Change(Sender: TObject);
begin
  if Assigned(Font1) then
    Font1.Name := cbFont1.FontName;
end;

procedure TmstCoordTableSettingsEditor.cbFont2Change(Sender: TObject);
begin
  if Assigned(Font2) then
    Font2.Name := cbFont2.FontName;
end;

procedure TmstCoordTableSettingsEditor.cbFont3Change(Sender: TObject);
begin
  if Assigned(Font3) then
    Font3.Name := cbFont3.FontName;
end;

procedure TmstCoordTableSettingsEditor.edSize1Change(Sender: TObject);
begin
  if Assigned(Font1) then
    Font1.Size := UpDown1.Position;
end;

procedure TmstCoordTableSettingsEditor.edSize2Change(Sender: TObject);
begin
  if Assigned(Font2) then
    Font2.Size := UpDown2.Position;
end;

procedure TmstCoordTableSettingsEditor.edSize3Change(Sender: TObject);
begin
  if Assigned(Font3) then
    Font3.Size := UpDown3.Position;
end;

procedure TmstCoordTableSettingsEditor.FormResize(Sender: TObject);
begin
  btnOK.Top := gbCell.Top + gbCell.Height + 8;
  btnCancel.Top := btnOK.Top;
  ClientHeight := btnOK.Top + btnOK.Height + 8;
end;

end.
