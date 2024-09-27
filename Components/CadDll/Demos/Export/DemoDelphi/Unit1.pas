unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Vcl.ExtCtrls, ExtCtrls;

type
  TfmMetafileToCADExport = class(TForm)
    btnDoExport: TButton;
    OpenDialog1: TOpenDialog;
    edtSrc: TEdit;
    btnSelectMetafile: TButton;
    gbOutputSettings: TGroupBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    cbVersion: TComboBox;
    rgFormat: TRadioGroup;
    btnSelectDest: TButton;
    edtDst: TEdit;
    procedure btnSelectMetafileClick(Sender: TObject);
    procedure btnSelectDestClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnDoExportClick(Sender: TObject);
    procedure edtDstChange(Sender: TObject);
    procedure rgFormatClick(Sender: TObject);
    procedure cbVersionSelect(Sender: TObject);
  private
    FVersionStr: string;
    procedure UpdateVersionsCombo(AExt: string);
  public
    { Public declarations }
  end;

var
  fmMetafileToCADExport: TfmMetafileToCADExport;

implementation

{$R *.dfm}

type
   TsgDWGVersion = (acR09, acR10, acR11, acR12, acR13, acR14, acR2000, acR2004,
    acR2007, acR2010, acR2013);

const
  sgLibName = 'cad.dll';
  XP_USE01MM	= 1;
  XP_PARSEWHITE	= 2;
  XP_ALTERNATIVEBLACK = 4;
  DWGVersionStr: array[TsgDWGVersion] of string = ('R09', 'R10', 'R11', 'R12',
    'R13', 'R14', 'R2000', 'R2004', 'R2007', 'R2010', 'R2013');
  cnstExtDXF = '.dxf';
  cnstExtGCode = '.nc';
  cntAutoCAD = 'AutoCAD™';
  DXFFilter: string  = '|' + cntAutoCAD + ' DXF (*.dxf)|*.dxf';
  DWGFilter: string  = '|' + cntAutoCAD + ' DWG (*.dwg)|*.dwg';

function ExportToDXF(Hanlde: THandle; FileName: PChar; Flags: DWORD): Integer; stdcall; external sgLibName name 'ExportToDXF';
function ExportToCAD(Hanlde: THandle; FileName: PChar; Flags: DWORD; Version: Byte): Integer; stdcall; external sgLibName name 'ExportToCADFile';
function GetLastErrorCAD(ABuf: PChar; ASize: Integer): Integer; stdcall; external sgLibName name 'GetLastErrorCAD';

procedure TfmMetafileToCADExport.btnDoExportClick(Sender: TObject);
const
  cnstBufSize = 1024;
var
  MF: TMetafile;
  S: string;
  F: DWORD;
  DWGVersion: TsgDWGVersion;
  vMsg: array[1..1024] of Char;
begin
  MF := TMetafile.Create;
  F := 0;
  if CheckBox2.Checked then F := F or XP_PARSEWHITE;
  if CheckBox3.Checked then F := F or XP_ALTERNATIVEBLACK;
  try
    MF.LoadFromFile(edtSrc.Text);
    S := edtDst.Text;
    if cbVersion.Items.Count > 0 then
      DWGVersion := TsgDWGVersion(cbVersion.Items.Objects[cbVersion.ItemIndex])
    else
      DWGVersion := acR09;
    if ExportToCAD(MF.Handle, PChar(S), F, Ord(DWGVersion)) = 0 then
    begin
      GetLastErrorCAD(@vMsg[1], cnstBufSize);
      raise Exception.Create(vMsg);
    end;
  finally
    MF.Free;
  end;
end;

procedure TfmMetafileToCADExport.btnSelectMetafileClick(Sender: TObject);
begin
  OpenDialog1.Filter := GraphicFilter(TMetafile);
  if OpenDialog1.Execute then
  begin
    edtSrc.Text := OpenDialog1.FileName;
    if edtDst.Text = '' then
      edtDst.Text := ChangeFileExt(edtSrc.Text, cnstExtDXF);
  end;
end;

procedure TfmMetafileToCADExport.btnSelectDestClick(Sender: TObject);
var
  S: string;
begin
  S := DXFFilter + DWGFilter;
  Delete(S, 1, 1);
  OpenDialog1.Filter := S;
  if OpenDialog1.Execute then
    edtDst.Text := OpenDialog1.FileName;
end;

procedure TfmMetafileToCADExport.cbVersionSelect(Sender: TObject);
begin
  FVersionStr := cbVersion.Items[cbVersion.ItemIndex];
end;

procedure TfmMetafileToCADExport.edtDstChange(Sender: TObject);
var
  S: string;
begin
  S := AnsiLowerCase(ExtractFileExt(edtDst.Text));
  Delete(S, 1, 1);
  rgFormat.ItemIndex := rgFormat.Items.IndexOf(S);
end;

procedure TfmMetafileToCADExport.FormCreate(Sender: TObject);
begin
  FVersionStr := DWGVersionStr[acR2000];
  UpdateVersionsCombo(cnstExtDXF);
end;

procedure TfmMetafileToCADExport.rgFormatClick(Sender: TObject);
var
  S, Ext: string;
begin
  Ext := '.' + rgFormat.Items[rgFormat.ItemIndex];
  S := edtDst.Text;
  if S <> '' then
  begin
    S := ChangeFileExt(S, Ext);
    edtDst.Text := S;
    UpdateVersionsCombo(Ext);
  end
  else
    UpdateVersionsCombo(Ext);
end;

procedure TfmMetafileToCADExport.UpdateVersionsCombo(AExt: string);
var
  DWGVersion, DWGVersionHi: TsgDWGVersion;
begin
  if AExt = cnstExtGCode then
  begin
    cbVersion.Clear;
    cbVersion.Enabled := False;
    Exit;
  end
  else
    cbVersion.Enabled := True;
  if AExt = cnstExtDXF then
    DWGVersionHi := acR2007
  else
    DWGVersionHi := acR2004;
  cbVersion.Items.BeginUpdate;
  try
    cbVersion.Clear;
    for DWGVersion := acR2000 to DWGVersionHi do
      cbVersion.AddItem(DWGVersionStr[DWGVersion], TObject(Ord(DWGVersion)));
  finally
    cbVersion.Items.EndUpdate;
  end;
  cbVersion.ItemIndex := cbVersion.Items.IndexOf(FVersionStr);
  if cbVersion.ItemIndex = -1 then
  begin
    cbVersion.ItemIndex := 0;
    FVersionStr := cbVersion.Items[cbVersion.ItemIndex];
  end;
end;

end.
