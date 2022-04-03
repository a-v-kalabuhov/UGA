unit uKisGeoPunktsEditor;

{$I KisFlags.pas}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  //project
  uKisEntityEditor, ExtDlgs, JvBaseDlg, JvDesktopAlert;

type
  TKisGeoPunktsEditor = class(TKisEntityEditor)
    cbStatus: TCheckBox;
    Label9: TLabel;
    cbPunktType1: TComboBox;
    Label6: TLabel;
    edClass: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    edPartChief: TEdit;
    edCreator: TEdit;
    Label1: TLabel;
    edName: TEdit;
    Label2: TLabel;
    edCenterType: TEdit;
    Label7: TLabel;
    edSymbolInfo: TMemo;
    Label8: TLabel;
    edSymbolInfo2: TMemo;
    btnPrintReport: TButton;
    Label10: TLabel;
    cbPunktType2: TComboBox;
    Label3: TLabel;
    edPunktDate: TEdit;
    Label11: TLabel;
    edPlaceInfo: TMemo;
    pImage: TPanel;
    Panel1: TPanel;
    ImgGeoPunkt: TImage;
    btnLoadImage: TButton;
    btnClearImage: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnClearImageClick(Sender: TObject);
    procedure btnLoadImageClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

procedure TKisGeoPunktsEditor.btnClearImageClick(Sender: TObject);
begin
  inherited;
  ImgGeoPunkt.Picture.Bitmap := nil;
end;

procedure TKisGeoPunktsEditor.btnLoadImageClick(Sender: TObject);
var
  Bmp: TBitmap;
begin
  inherited;
  if OpenPictureDialog1.Execute then
  begin
    Bmp := TBitmap.Create;
    try
      Bmp.LoadFromFile(OpenPictureDialog1.FileName);
      ImgGeoPunkt.Picture.Bitmap := Bmp;
    finally
      FreeAndNil(Bmp);
    end;
  end;
end;

procedure TKisGeoPunktsEditor.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (ssCtrl in Shift) and (Key = Ord('P')) then
    if Assigned(btnPrintReport.OnClick) then
      btnPrintReport.OnClick(Self);
end;

end.
