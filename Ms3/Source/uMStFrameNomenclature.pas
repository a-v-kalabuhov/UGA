unit uMStFrameNomenclature;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin,
  uGC, uGeoUtils;

type
  NPart = record
    Number: Integer;
    Positive: Boolean;
    FPart: String;
  end;

  // TODO : добавить краснолесный
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
    procedure Init(FillCombos: Boolean = True;
      const Part1: String = ''; Part2: String = ''; Part3: String = '');
  published
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

implementation

uses
  uCommonUtils;

var
  PartI, PartII, PartIII: array of String;


{$R *.dfm}

function TfrNomenclature.GetNomenclature: String;
begin
  result := PartI[FPartI] + '-' + PartII[FPartII] + '-' + PartIII[FPartIII];
end;

procedure TfrNomenclature.Change;
begin
  inherited Changed;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TfrNomenclature.Init(FillCombos: Boolean = True;
  const Part1: String = ''; Part2: String = ''; Part3: String = '');
var
  i: Integer;
begin
  if FillCombos then
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
  if ComboBox3.ItemIndex < 0 then
    ComboBox3.ItemIndex := 0;
  FPartIII := ComboBox3.ItemIndex;
  Change;
end;

procedure TfrNomenclature.SetNomenclature(Value: String);
var
  l: TStringList;
begin
  l := TStringList.Create;
  l.Forget();
  TGeoUtils.GetNomenclatureParts(Value, l);
  if l.Count <> 3 then
    Init(False)
  else
    Init(False, l.Strings[0], l.Strings[1], l.Strings[2]);
end;

initialization
  SetLength(PartI, 48);
  PartI[0] := '0Ш';
  PartI[1] := '0Щ';
  PartI[2] := '0Э';
  PartI[3] := '0Ю';
  PartI[4] := '0Я';
  PartI[5] := 'Я';
  PartI[6] := 'Ю';
  PartI[7] := 'Э';
  PartI[8] := 'Щ';
  PartI[9] := 'Ш';
  PartI[10] := 'Ч';
  PartI[11] := 'Ц';
  PartI[12] := 'Х';
  PartI[13] := 'Ф';
  PartI[14] := 'У';
  PartI[15] := 'Т';
  PartI[16] := 'С';
  PartI[17] := 'Р';
  PartI[18] := 'П';
  PartI[19] := 'О';
  PartI[20] := 'Н';
  PartI[21] := 'М';
  PartI[22] := 'Л';
  PartI[23] := 'К';
  PartI[24] := 'И';
  PartI[25] := 'З';
  PartI[26] := 'Ж';
  PartI[27] := 'Е';
  PartI[28] := 'Д';
  PartI[29] := 'Г';
  PartI[30] := 'В';
  PartI[31] := 'Б';
  PartI[32] := 'А';
  PartI[33] := '0А';
  PartI[34] := '0Б';
  PartI[35] := '0В';
  PartI[36] := '0Г';
  PartI[37] := '0Д';
  PartI[38] := '0Е';
  PartI[39] := '0Ж';
  PartI[40] := '0З';
  PartI[41] := '0И';
  PartI[42] := '0К';
  PartI[43] := '0Л';
  PartI[44] := '0М';
  PartI[45] := '0Н';
  PartI[46] := '0О';
  PartI[47] := '0П';
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
