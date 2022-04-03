unit uKisMap500Editor;

{$I KisFlags.pas}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, ComCtrls, DB, ExtCtrls,
  JvBaseDlg, JvDesktopAlert,
 uCommonUtils,  uDBGrid,
  uKisEntityEditor;

type
  TKisMap500Editor = class(TKisEntityEditor)
    pcMap500: TPageControl;
    tbMapCase: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    edOriginYear: TEdit;
    Label3: TLabel;
    cbOriginOrg: TComboBox;
    Label4: TLabel;
    edBasisType: TComboBox;
    Label5: TLabel;
    cbStatus: TCheckBox;
    Label6: TLabel;
    edAnnulDate: TEdit;
    cbScanStatus: TCheckBox;
    Label7: TLabel;
    edNumber: TEdit;
    tbHistory: TTabSheet;
    GroupBox1: TGroupBox;
    tbScan: TTabSheet;
    dbgGivenMapList: TDBGrid;
    btnGiveMap: TButton;
    btnDeleteGivenMap: TButton;
    Panel1: TPanel;
    dsMapHistory: TDataSource;
    dsScanning: TDataSource;
    dbgHistoryList: TDBGrid;
    dbgScanningList: TDBGrid;
    btnAddHistory: TButton;
    btnDeleteHistory: TButton;
    btnEditHistory: TButton;
    btnAddScan: TButton;
    btnDeleteScan: TButton;
    btnEditScann: TButton;
    dsGivenMap: TDataSource;
    btnBack: TButton;
    edNomenclature: TEdit;
    edNom2: TEdit;
    edNom3: TEdit;
    Panel2: TPanel;
    pbPreview: TPaintBox;
    procedure btnDeleteGivenMapClick(Sender: TObject);
    procedure btnGiveCalcClick(Sender: TObject);
    procedure dbgGivenMapListExit(Sender: TObject);
    procedure dbgHistoryListExit(Sender: TObject);
    procedure btnAddHistoryClick(Sender: TObject);
    procedure btnDeleteHistoryClick(Sender: TObject);
    procedure dbgScanningListExit(Sender: TObject);
    procedure btnAddScanClick(Sender: TObject);
    procedure btnDeleteScanClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure cbStatusClick(Sender: TObject);
    procedure edNomenclatureKeyPress(Sender: TObject; var Key: Char);
    procedure edNom2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edNomenclatureKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edNom2KeyPress(Sender: TObject; var Key: Char);
    procedure edNom3KeyPress(Sender: TObject; var Key: Char);
    procedure btnGiveMapClick(Sender: TObject);
  private
    procedure SetUseScanningList(const Value: Boolean);
    function GetUseScanningList: Boolean;
  public
    property UseScanningList: Boolean read GetUseScanningList write SetUseScanningList;
  end;



implementation

{$R *.dfm}

uses
  uKisAppModule, uKisConsts;

procedure TKisMap500Editor.btnDeleteGivenMapClick(Sender: TObject);
begin
  inherited;
  if not dbgGivenMapList.DataSource.DataSet.IsEmpty then
     dbgGivenMapList.DataSource.DataSet.Delete;
end;

procedure TKisMap500Editor.btnGiveCalcClick(Sender: TObject);
begin
  inherited;
  if not dbgGivenMapList.DataSource.DataSet.IsEmpty then
    dbgGivenMapList.DataSource.DataSet.Edit;
end;

procedure TKisMap500Editor.btnGiveMapClick(Sender: TObject);
begin
  inherited;
;
end;

procedure TKisMap500Editor.dbgGivenMapListExit(Sender: TObject);
begin
  inherited;
  if dbgGivenMapList.DataSource.DataSet.State in [dsEdit, dsInsert] then
    dbgGivenMapList.DataSource.DataSet.Post;
end;

procedure TKisMap500Editor.dbgHistoryListExit(Sender: TObject);
begin
  inherited;
  if dbgHistoryList.DataSource.DataSet.State in [dsEdit, dsInsert] then
    dbgHistoryList.DataSource.DataSet.Post;
end;

procedure TKisMap500Editor.btnAddHistoryClick(Sender: TObject);
begin
  inherited;
  dbgHistoryList.DataSource.DataSet.Append;
end;

procedure TKisMap500Editor.btnDeleteHistoryClick(Sender: TObject);
begin
  inherited;
  if not dbgHistoryList.DataSource.DataSet.IsEmpty then
     dbgHistoryList.DataSource.DataSet.Delete;
end;

procedure TKisMap500Editor.dbgScanningListExit(Sender: TObject);
begin
  inherited;
  if dbgScanningList.DataSource.DataSet.State in [dsEdit, dsInsert] then
    dbgScanningList.DataSource.DataSet.Post;
end;

procedure TKisMap500Editor.btnAddScanClick(Sender: TObject);
begin
  inherited;
  dbgScanningList.DataSource.DataSet.Append;
end;

procedure TKisMap500Editor.btnDeleteScanClick(Sender: TObject);
begin
  inherited;
  if not dbgScanningList.DataSource.DataSet.IsEmpty then
     dbgScanningList.DataSource.DataSet.Delete;
end;

procedure TKisMap500Editor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  AppModule.WriteGridProperties(Self, dbgGivenMapList);
  AppModule.WriteGridProperties(Self, dbgHistoryList);
  if UseScanningList then
    AppModule.WriteGridProperties(Self, dbgScanningList);
end;

procedure TKisMap500Editor.FormShow(Sender: TObject);
begin
  inherited;
  pcMap500.ActivePageIndex := 0;
  AppModule.ReadGridProperties(Self, dbgGivenMapList);
  AppModule.ReadGridProperties(Self, dbgHistoryList);
  if UseScanningList then
    AppModule.ReadGridProperties(Self, dbgScanningList);
end;

function TKisMap500Editor.GetUseScanningList: Boolean;
begin
  Result := tbScan.Enabled;
end;

procedure TKisMap500Editor.SetUseScanningList(const Value: Boolean);
begin
  tbScan.Enabled := Value;
  cbScanStatus.Enabled := Value;
end;

procedure TKisMap500Editor.cbStatusClick(Sender: TObject);
begin
  inherited;
  if cbStatus.Checked then
  begin
    edAnnulDate.Enabled := True;
    edAnnulDate.Color := clWindow;
  end
  else
  begin
    edAnnulDate.Enabled := False;
    edAnnulDate.Color := clBtnFace;
    edAnnulDate.Clear;
  end;
end;

procedure TKisMap500Editor.edNomenclatureKeyPress(Sender: TObject;
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

procedure TKisMap500Editor.edNom2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_RIGHT then
    if edNom2.SelStart = Length(edNom2.Text) then
      edNom3.SetFocus;
end;

procedure TKisMap500Editor.edNomenclatureKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_RIGHT then
    if edNomenclature.SelStart = Length(edNomenclature.Text) then
      edNom2.SetFocus;
end;

procedure TKisMap500Editor.edNom2KeyPress(Sender: TObject; var Key: Char);
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

procedure TKisMap500Editor.edNom3KeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if Key in [#8, #10] then
    Exit;
  if not (Key in NumberChars) then
    Key := #0;
end;

end.
