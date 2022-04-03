unit GFAPreview;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, FileCtrl, StdCtrls, OleCtrls, NCSECWLib_TLB;

type
  TfrmGFAPreview = class(TForm)
    Panel: TPanel;
    FileListBox: TFileListBox;
    DriveComboBox: TDriveComboBox;
    DirectoryListBox: TDirectoryListBox;
    Renderer: TNCSRenderer;
    Button1: TButton;
    Button2: TButton;
    CheckBox: TCheckBox;
    Image: TImage;
    procedure FileListBoxChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CheckBoxClick(Sender: TObject);
  private
  public
    { Public declarations }
  end;

  procedure ShowGFAPreView(cap: String);

implementation

{$R *.dfm}

procedure ShowGFAPreView(cap: String);
begin
  with TfrmGFAPreview.Create(Application) do
  begin
    Caption := cap;
    ShowModal;
    Release;
  end;
end;

procedure TfrmGFAPreview.FileListBoxChange(Sender: TObject);
var
  barray: OleVariant;
  BAr: array of Integer;
  plBRX, plBRY, plTLX, plTLY: Double;
begin
  if CheckBox.Checked and (FileListBox.SelCount = 1) then
  begin
    SetLength(BAr, 3);
    BAr[0] := 0;
    BAr[1] := 1;
    BAr[2] := 2;
    barray := BAr;
    Renderer.Close(True);
    if FileListBox.FileName <> '' then
    begin
      Renderer.Open(FileListBox.FileName, True);
      Renderer.ConvertDatasetToWorld(0, 0, plTLX, plTLY);//planshet.Left, planshet.Top);
      Renderer.ConvertDatasetToWorld(Renderer.ImageWidth - 1, Renderer.ImageHeight - 1, plBRX, plBRY);
      Renderer.SetView(3, barray, Image.Width, Image.Height, plTLX, plTLY, plBRX, plBRY);
      Renderer.ReadImage(plTLX, plTLY, plBRX, plBRY, Image.Width, Image.Height);
      Renderer.DrawImage(Image.Canvas.Handle, 0, 0, Image.Width - 1, Image.Height - 1,
                         plTLX, plTLY, plBRX, plBRY);
      Image.Refresh;
    end;
    SetLength(BAr, 0);
  end;
end;

procedure TfrmGFAPreview.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Renderer.Close(True);
end;

procedure TfrmGFAPreview.CheckBoxClick(Sender: TObject);
begin
  FileListboxChange(nil);
end;

end.
