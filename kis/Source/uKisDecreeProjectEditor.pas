unit uKisDecreeProjectEditor;

{$I KisFlags.pas}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uKisEntityEditor, StdCtrls, Grids, DBGrids, ComCtrls, Buttons,
  DB, uDBGrid, DBCtrls, Mask, JvBaseDlg, JvDesktopAlert;
  
type
  TKisDecreeProjectEditor = class(TKisEntityEditor)
    PageControl1: TPageControl;
    tshDecreePrj: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    cbOffice: TComboBox;
    Label3: TLabel;
    cbExecutor: TComboBox;
    tshAddresses: TTabSheet;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    dbgDecreeAddresses: TkaDBGrid;
    dsDecreeAddresses: TDataSource;
    dbgLetterAddresses: TkaDBGrid;
    dsLetterAddresses: TDataSource;
    btnNewAddress: TSpeedButton;
    btnDelAddress: TSpeedButton;
    btnEditAddress: TSpeedButton;
    dsVisas: TDataSource;
    GroupBox3: TGroupBox;
    dbgVisas: TkaDBGrid;
    btnVisaCreate: TButton;
    btnVisaDelete: TButton;
    GroupBox4: TGroupBox;
    Label6: TLabel;
    edNumberMP: TEdit;
    Label7: TLabel;
    edDateMP: TEdit;
    btnSelectLetter: TButton;
    Label4: TLabel;
    edSeqNumber: TEdit;
    edHeader: TMemo;
    tsDecree: TTabSheet;
    PrintDialog: TPrintDialog;
    Label5: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    edDecreeTypes: TEdit;
    edDate: TEdit;
    edNumber: TEdit;
    edInt_Date: TEdit;
    edInt_Number: TEdit;
    mHeader: TMemo;
    mContent: TMemo;
    PrintDialog1: TPrintDialog;
    btnSelectDecree: TButton;
    tsDesc: TTabSheet;
    Label14: TLabel;
    memoDesc: TMemo;
    procedure btnNewAddressClick(Sender: TObject);
    procedure btnEditAddressClick(Sender: TObject);
    procedure btnDelAddressClick(Sender: TObject);
    procedure dbgVisasExit(Sender: TObject);
    procedure btnVisaDeleteClick(Sender: TObject);
    procedure btnVisaCreateClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;



implementation

{$R *.dfm}

uses
  uKisConsts, uKisAppModule;

procedure TKisDecreeProjectEditor.btnNewAddressClick(Sender: TObject);
begin
  inherited;
  dbgDecreeAddresses.DataSource.DataSet.Append;
end;

procedure TKisDecreeProjectEditor.btnEditAddressClick(Sender: TObject);
begin
  inherited;
  if not dbgDecreeAddresses.DataSource.DataSet.IsEmpty then
    dbgDecreeAddresses.DataSource.DataSet.Edit;
end;

procedure TKisDecreeProjectEditor.btnDelAddressClick(Sender: TObject);
begin
  inherited;
  if not dbgDecreeAddresses.DataSource.DataSet.IsEmpty then
  if MessageBox(Handle, PChar(S_CONFIRM_DELETE_RECORD), PChar(S_WARN), MB_YESNO + MB_ICONQUESTION) = ID_YES then
    dbgDecreeAddresses.DataSource.DataSet.Delete;
end;

procedure TKisDecreeProjectEditor.dbgVisasExit(Sender: TObject);
begin
  if dbgVisas.DataSource.DataSet.State in [dsEdit, dsInsert] then
    dbgVisas.DataSource.DataSet.Post;
end;

procedure TKisDecreeProjectEditor.btnVisaDeleteClick(Sender: TObject);
begin
  inherited;
  dbgVisas.DataSource.DataSet.Delete;
end;

procedure TKisDecreeProjectEditor.btnVisaCreateClick(Sender: TObject);
begin
  inherited;
  dbgVisas.DataSource.DataSet.Append;
end;

procedure TKisDecreeProjectEditor.FormShow(Sender: TObject);
begin
  inherited;
  AppModule.ReadGridProperties(Self, dbgVisas);
end;

procedure TKisDecreeProjectEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  AppModule.WriteGridProperties(Self, dbgVisas);
end;

end.
