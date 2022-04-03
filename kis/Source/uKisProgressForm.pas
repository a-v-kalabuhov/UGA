unit uKisProgressForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList;

type
  TKisProgressForm = class(TForm)
    Timer1: TTimer;
    Label1: TLabel;
    ImageList1: TImageList;
    Image1: TImage;
    Timer2: TTimer;
    procedure Timer2Timer(Sender: TObject);
  private
    FPictureCount: Integer;
    FIndex: Integer;
    procedure ChangePicture;
  public
    procedure Start;
    procedure Stop;
  end;

var
  KisProgressForm: TKisProgressForm;

implementation

{$R *.dfm}

procedure TKisProgressForm.ChangePicture;
begin
  Inc(FIndex);
  if FIndex >= FPictureCount then
    FIndex := 0;
  if FIndex < FPictureCount then
  begin
    if not Assigned(Image1.Picture.Bitmap) then
      Image1.Picture.Bitmap := TBitmap.Create;
    ImageList1.GetBitmap(FIndex, Image1.Picture.Bitmap);
  end;
end;

procedure TKisProgressForm.Start;
begin
  FPictureCount := ImageList1.Count;
  FIndex := -1;
  Timer1.Enabled := True;
end;

procedure TKisProgressForm.Stop;
begin
  Timer1.Enabled := False;
end;

procedure TKisProgressForm.Timer2Timer(Sender: TObject);
begin
  ChangePicture;
  Application.ProcessMessages;
end;

end.
