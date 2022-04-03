unit NomenclatureFrame;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin;

type
  NPart = record
    Number: Integer;
    Positive: Boolean;
    FPart: String;
  end;

  TfrNomenclature = class(TFrame)
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
  private
    FOnChange: TNotifyEvent;
    FPartI: Integer;
    FPartII: Integer;
    FPartIII: Integer;
    function GetNomenclature: String;
    procedure SetNomenclature(Value: String);
    procedure Change;
  public
    property Nomenclature: String read GetNomenclature write SetNomenclature;
    procedure Init(fill_combos: Boolean = True; part1: String = ''; part2: String = ''; part3: String = '');
  published
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

implementation

{$R *.dfm}

uses
  uCommonUtils;

var
  PartI, PartII, PartIII: array of String;

function TfrNomenclature.GetNomenclature: String;
begin
  result := PartI[FPartI] + '-' + PartII[FPartII] + '-' + PartIII[FPartIII];
end;

procedure TfrNomenclature.Change;
begin
  inherited Changed;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TfrNomenclature.Init(fill_combos: Boolean = True; part1: String = ''; part2: String = ''; part3: String = '');
var
  i: Integer;
begin
  if fill_combos then
  begin
    ComboBox1.Items.Clear;
    for i := 0 to Length(PartI) - 1 do
      ComboBox1.Items.Add(PartI[i]);
    ComboBox2.Items.Clear;
    for i := 0 to Length(PartII) - 1 do
      ComboBox2.Items.Add(PartII[i]);
    ComboBox3.Items.Clear;
    for i := 0 to Length(PartIII) - 1 do
      ComboBox3.Items.Add(PartIII[i]);
    ComboBox1.ItemIndex := 0;
  end;
  if part1 <> '' then
  begin
    i := ComboBox1.Items.IndexOf(part1);
    if i >= 0 then
    begin
      ComboBox1.ItemIndex := i;
      FPartI := i;
    end;
  end;
  ComboBox2.ItemIndex := 0;
  if part2 <> '' then
  begin
    i := ComboBox2.Items.IndexOf(part2);
    if i >= 0 then
    begin
      ComboBox2.ItemIndex := i;
      FPartII := i;
    end;
  end;
  ComboBox3.ItemIndex := 0;
  if part3 <> '' then
  begin
    i := ComboBox3.Items.IndexOf(part3);
    if i >= 0 then
    begin
      ComboBox3.ItemIndex := i;
      FPartIII := i;
    end;
  end;
end;

procedure TfrNomenclature.ComboBox1Change(Sender: TObject);
begin
  if ComboBox1.ItemIndex < 0 then ComboBox1.ItemIndex := 0;
  FPartI := ComboBox1.ItemIndex;
  Change;
end;

procedure TfrNomenclature.ComboBox2Change(Sender: TObject);
begin
  if ComboBox2.ItemIndex < 0 then ComboBox2.ItemIndex := 0;
  FPartII := ComboBox2.ItemIndex;
  Change;
end;

procedure TfrNomenclature.ComboBox3Change(Sender: TObject);
begin
  if ComboBox3.ItemIndex < 0 then ComboBox3.ItemIndex := 0;
  FPartIII := ComboBox3.ItemIndex;
  Change;
end;

procedure TfrNomenclature.SetNomenclature(Value: String);
var
  l: TStringList;
begin
  l := TStringList.Create;
  try
    uCommonUtils.GetNomenclatureParts(Value, l);
    if l.Count <> 3 then Init(False) else Init(False, l.Strings[0], l.Strings[1], l.Strings[2]);
  finally
    l.free;
  end;
end;

initialization
  SetLength(PartI, 48);
  PartI[0] := '0Ø';
  PartI[1] := '0Ù';
  PartI[2] := '0Ý';
  PartI[3] := '0Þ';
  PartI[4] := '0ß';
  PartI[5] := 'ß';
  PartI[6] := 'Þ';
  PartI[7] := 'Ý';
  PartI[8] := 'Ù';
  PartI[9] := 'Ø';
  PartI[10] := '×';
  PartI[11] := 'Ö';
  PartI[12] := 'Õ';
  PartI[13] := 'Ô';
  PartI[14] := 'Ó';
  PartI[15] := 'Ò';
  PartI[16] := 'Ñ';
  PartI[17] := 'Ð';
  PartI[18] := 'Ï';
  PartI[19] := 'Î';
  PartI[20] := 'Í';
  PartI[21] := 'Ì';
  PartI[22] := 'Ë';
  PartI[23] := 'Ê';
  PartI[24] := 'È';
  PartI[25] := 'Ç';
  PartI[26] := 'Æ';
  PartI[27] := 'Å';
  PartI[28] := 'Ä';
  PartI[29] := 'Ã';
  PartI[30] := 'Â';
  PartI[31] := 'Á';
  PartI[32] := 'À';
  PartI[33] := '0À';
  PartI[34] := '0Á';
  PartI[35] := '0Â';
  PartI[36] := '0Ã';
  PartI[37] := '0Ä';
  PartI[38] := '0Å';
  PartI[39] := '0Æ';
  PartI[40] := '0Ç';
  PartI[41] := '0È';
  PartI[42] := '0Ê';
  PartI[43] := '0Ë';
  PartI[44] := '0Ì';
  PartI[45] := '0Í';
  PartI[46] := '0Î';
  PartI[47] := '0Ï';
  SetLength(PartII, 41);
  PartII[0] := '0X';
  PartII[1] := '0IX';
  PartII[2] := '0VIII';
  PartII[3] := '0VII';
  PartII[4] := '0VI';
  PartII[5] := '0V';
  PartII[6] := '0IV';
  PartII[7] := '0III';
  PartII[8] := '0II';
  PartII[9] := '0I';
  PartII[10] := '0';
  PartII[11] := 'I';
  PartII[12] := 'II';
  PartII[13] := 'III';
  PartII[14] := 'IV';
  PartII[15] := 'V';
  PartII[16] := 'VI';
  PartII[17] := 'VII';
  PartII[18] := 'VIII';
  PartII[19] := 'IX';
  PartII[20] := 'X';
  PartII[21] := 'XI';
  PartII[22] := 'XII';
  PartII[23] := 'XIII';
  PartII[24] := 'XIV';
  PartII[25] := 'XV';
  PartII[26] := 'XVI';
  PartII[27] := 'XVII';
  PartII[28] := 'XVIII';
  PartII[29] := 'XIX';
  PartII[30] := 'XX';
  PartII[31] := 'XXI';
  PartII[32] := 'XXII';
  PartII[33] := 'XXIII';
  PartII[34] := 'XXIV';
  PartII[35] := 'XXV';
  PartII[36] := 'XXVI';
  PartII[37] := 'XXVII';
  PartII[38] := 'XXVIII';
  PartII[39] := 'XXIX';
  PartII[40] := 'XXX';
  SetLength(PartIII, 16);
  PartIII[0] := '1';
  PartIII[1] := '2';
  PartIII[2] := '3';
  PartIII[3] := '4';
  PartIII[4] := '5';
  PartIII[5] := '6';
  PartIII[6] := '7';
  PartIII[7] := '8';
  PartIII[8] := '9';
  PartIII[9] := '10';
  PartIII[10] := '11';
  PartIII[11] := '12';
  PartIII[12] := '13';
  PartIII[13] := '14';
  PartIII[14] := '15';
  PartIII[15] := '16';

finalization
  SetLength(PartI, 0);
  SetLength(PartII, 0);
  SetLength(PartIII, 0);

end.
