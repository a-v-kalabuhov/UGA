unit uMStDialogNomenclature;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, Dialogs, ExtCtrls, ImgList,
  // shared
  uGC, uCommonUtils, uGeoUtils;

type
  // TODO : добавить краснолесный
  TmstNomenclatureForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    edNomenclature: TEdit;
    Label1: TLabel;
    Image1: TImage;
    Label2: TLabel;
    ImageList1: TImageList;
    procedure edNomenclatureChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    function GetNomenclature(): string;
  public
    class function ShowNomenclature(var aNomenclature: String): Boolean;
  end;

implementation

{$R *.dfm}

procedure TmstNomenclatureForm.Button1Click(Sender: TObject);
var
  N: TNomenclature;
  B: Boolean;
  Bmp: TBitmap;
  Idx: Integer;
begin
  N.Init(edNomenclature.Text, False);
  if N.Valid then
    Idx := 0
  else
    Idx := 1;
  Bmp := TBitmap.Create;
  Bmp.Forget();
  B := ImageList1.GetBitmap(Idx, Bmp);
  if B then
    Image1.Picture.Bitmap := Bmp;
  Image1.Visible := B;
  Label2.Visible := True;
  if N.Valid then
    ModalResult := mrOK
  else
    ShowMessage('Ошибка в номенклатуре!');
end;

procedure TmstNomenclatureForm.edNomenclatureChange(Sender: TObject);
var
  S: string;
  N: TNomenclature;
  B: Boolean;
  Bmp: TBitmap;
  Idx: Integer;
begin
  S := Trim(edNomenclature.Text);
  if S  = '' then
  begin
    Image1.Visible := False;
    Label2.Visible := False;
  end
  else
  begin
    N.Init(edNomenclature.Text, False);
    if N.Valid then
      Idx := 0
    else
      Idx := 1;
    Bmp := TBitmap.Create;
    Bmp.Forget();
    B := ImageList1.GetBitmap(Idx, Bmp);
    if B then
      Image1.Picture.Bitmap := Bmp;
    Image1.Visible := B;
    Label2.Visible := True;
    if B then
      S := 'Номенклатура верна!'
    else
      S := 'Ошибка в номенклатуре!';
  end;
end;

function TmstNomenclatureForm.GetNomenclature: string;
var
  N: TNomenclature;
begin
  N.Init(edNomenclature.Text, False);
  if N.Valid then
    Result := N.Nomenclature()
  else
    Result := edNomenclature.Text;
end;

class function TmstNomenclatureForm.ShowNomenclature(var aNomenclature: String): Boolean;
var
  N: TNomenclature;
begin
  with TmstNomenclatureForm.Create(Application) do
  try
    N.Init(aNomenclature, False);
    Result := ShowModal = mrOK;
    if Result then
      aNomenclature := GetNomenclature();
  finally
    Free;
  end;
end;

end.
