unit uKisMapTracingEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uKisEntityEditor, StdCtrls, Grids, DBGrids, DB, uDBGrid;

type
  TKisMapTracingEditor = class(TKisEntityEditor)
    edNomenclature: TEdit;
    Label1: TLabel;
    cbIsSecret: TCheckBox;
    gGivings: TkaDBGrid;
    DataSource: TDataSource;
    edNom2: TEdit;
    edNom3: TEdit;
    btnEditLast: TButton;
    btnDeleteLast: TButton;
    procedure edNom3KeyPress(Sender: TObject; var Key: Char);
    procedure edNom2KeyPress(Sender: TObject; var Key: Char);
    procedure edNomenclatureKeyPress(Sender: TObject; var Key: Char);
    procedure edNomenclatureKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edNom2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  end;

implementation

{$R *.dfm}

uses
  uKisConsts;

procedure TKisMapTracingEditor.edNom3KeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if Key in [#8, #10] then
    Exit;
  if not (Key in uKisConsts.NumberChars) then
    Key := #0;
end;

procedure TKisMapTracingEditor.edNom2KeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if Key in [#8, #10] then
    Exit;
  case Key of
  'X', 'x', '[', '{',   // Lat
  'Õ', 'õ', '×', '÷' :  // Rus
    begin
      Key := 'X';
    end;
  '1', 'I', 'i', 'Ø', 'ø', '!', '|':
    begin
      Key := 'I';
    end;
  '5', 'V', 'v', 'Ì', 'ì', '%':
    begin
      Key := 'V';
    end;
  else
    if Key <> '0' then
      Key := #0;
  end;
end;

procedure TKisMapTracingEditor.edNomenclatureKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if Key in [#8, #10] then
    Exit;
  if Key = '0' then
  begin
    if Length(edNomenclature.Text) > 0 then
      if (edNomenclature.Text[1] = '0') or (edNomenclature.SelStart > 0) then
        Key := #0;
  end
  else
    if (Key = '0') or ((Key >= 'À') and (Key <= 'ß'))
       or ((Key >= 'à') and (Key <= 'ÿ'))
    then
      Key := String(UpperCase(Key))[1]
    else
      if not (Key in ['(', ')']) then
        Key := #0;
end;

procedure TKisMapTracingEditor.edNomenclatureKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_RIGHT then
    if edNomenclature.SelStart = Length(edNomenclature.Text) then
      edNom2.SetFocus;
end;

procedure TKisMapTracingEditor.edNom2KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_RIGHT then
    if edNom2.SelStart = Length(edNom2.Text) then
      edNom3.SetFocus;
end;

end.
