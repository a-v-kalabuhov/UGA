unit SHXDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TFontSettingsDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    cbUseSHXFonts: TCheckBox;
    gbSHXFonts: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Edit3: TEdit;
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure cbUseSHXFontsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FontSettingsDlg: TFontSettingsDlg;

implementation

uses CADIntf;

{$R *.dfm}


procedure TFontSettingsDlg.CancelBtnClick(Sender: TObject);
begin
  FontSettingsDlg.Close;
end;

procedure TFontSettingsDlg.cbUseSHXFontsClick(Sender: TObject);
begin
  gbSHXFonts.Enabled := cbUseSHXFonts.Checked;
  Label1.Enabled := cbUseSHXFonts.Checked;
  Label2.Enabled := cbUseSHXFonts.Checked;
  Label3.Enabled := cbUseSHXFonts.Checked;
  Edit1.Enabled := cbUseSHXFonts.Checked;
  Edit2.Enabled := cbUseSHXFonts.Checked;
  Edit3.Enabled := cbUseSHXFonts.Checked;
end;

procedure TFontSettingsDlg.OKBtnClick(Sender: TObject);
begin
  CADSetSHXOptions(PChar(Edit1.Text), PChar(Edit2.Text), PChar(Edit3.Text), cbUseSHXFonts.Checked, True);
  FontSettingsDlg.Close;
end;

end.
