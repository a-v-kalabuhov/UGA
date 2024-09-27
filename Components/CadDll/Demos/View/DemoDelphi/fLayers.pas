unit fLayers;

interface

uses                              
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtDlgs, Buttons, StdCtrls, sgCADImage, sgConsts,
  ComCtrls, CheckLst, ImgList;

type
  TfmLayers = class(TForm)
    btnOK: TButton;
    ImageList: TImageList;
    clbLayers: TCheckListBox;
    procedure edtNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure clbLayersClickCheck(Sender: TObject);
    procedure clbLayersKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnOKClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmLayers: TfmLayers;

implementation

{$R *.dfm}

procedure TfmLayers.edtNameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Close;
    ModalResult := mrOk;
  end;
end;

procedure TfmLayers.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE: Close;
  end;
end;

procedure TfmLayers.clbLayersClickCheck(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to clbLayers.Items.Count - 1 do
  begin
    CADLayerVisible(THandle(clbLayers.Items.Objects[I]), Ord(clbLayers.Checked[I]));
  end;
  Application.MainForm.Invalidate;
end;

procedure TfmLayers.clbLayersKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    ModalResult := mrOk;
end;

procedure TfmLayers.btnOKClick(Sender: TObject);
begin
  Hide;
end;

end.
