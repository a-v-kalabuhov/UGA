unit uKisArchivalDocsEditor;

interface

{$I KisFlags.pas}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uKisEntityEditor, StdCtrls, DB, Grids, DBGrids, JvBaseDlg, JvDesktopAlert;

type
  TKisArchivalDocsEditor = class(TKisEntityEditor)
    cbDocType: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    edArchNumber: TEdit;
    Label3: TLabel;
    edShelveDate: TEdit;
    Label4: TLabel;
    edObjectName: TEdit;
    Label5: TLabel;
    edAddress: TEdit;
    Label7: TLabel;
    edBasis: TEdit;
    Label10: TLabel;
    edComment: TEdit;
    GroupBox1: TGroupBox;
    dbgDocList: TDBGrid;
    dsDocList: TDataSource;
    btnAddMove: TButton;
    btnDeleteMove: TButton;
    btnBackDoc: TButton;
    GroupBox2: TGroupBox;
    edFirm: TEdit;
    btnSelectFirm: TButton;
    btnClearFirm: TButton;
    GroupBox3: TGroupBox;
    edLicensedOrg: TEdit;
    btnSelectOrg: TButton;
    btnClearOrg: TButton;
    procedure btnAddMoveClick(Sender: TObject);
    procedure btnDeleteMoveClick(Sender: TObject);
    procedure dbgDocListExit(Sender: TObject);
    procedure btnBackDocClick(Sender: TObject);
    procedure edShelveDateKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  end;


implementation

{$R *.dfm}

uses
  uKisConsts, uKisAppModule;

procedure TKisArchivalDocsEditor.btnAddMoveClick(Sender: TObject);
begin
  inherited;
  dbgDocList.DataSource.DataSet.Append;
end;

procedure TKisArchivalDocsEditor.btnDeleteMoveClick(Sender: TObject);
begin
  inherited;
  if not dbgDocList.DataSource.DataSet.IsEmpty then
     dbgDocList.DataSource.DataSet.Delete;
end;

procedure TKisArchivalDocsEditor.dbgDocListExit(Sender: TObject);
begin
  if dbgDocList.DataSource.DataSet.State in [dsEdit, dsInsert] then
    dbgDocList.DataSource.DataSet.Post;
end;

procedure TKisArchivalDocsEditor.btnBackDocClick(Sender: TObject);
begin
  if not dbgDocList.DataSource.DataSet.IsEmpty then
    dbgDocList.DataSource.DataSet.Edit;
end;

procedure TKisArchivalDocsEditor.edShelveDateKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  if not (Key in DateEditKeys) then
    Key := 0;
end;

procedure TKisArchivalDocsEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  AppModule.WriteGridProperties(Self, dbgDocList);
end;

procedure TKisArchivalDocsEditor.FormShow(Sender: TObject);
begin
  inherited;
  AppModule.ReadGridProperties(Self, dbgDocList);
end;

end.
