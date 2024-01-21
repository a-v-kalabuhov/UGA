unit uKisLicensedOrgEditor;

interface

{$I KisFlags.pas}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uKisEntityEditor, StdCtrls, JvBaseDlg, JvDesktopAlert, DB, ComCtrls, Grids, DBGrids, ActnList;

type
  TKisLicensedOrgEditor = class(TKisEntityEditor)
    Label1: TLabel;
    edName: TEdit;
    Label2: TLabel;
    edAddress: TEdit;
    Label3: TLabel;
    edStartDate: TEdit;
    edEndDate: TEdit;
    Label4: TLabel;
    edMapperFio: TEdit;
    Label5: TLabel;
    dsSROPeriods: TDataSource;
    PageControl1: TPageControl;
    tsMain: TTabSheet;
    tsSRO: TTabSheet;
    dbgSRO: TDBGrid;
    btnSROAdd: TButton;
    btnSRODel: TButton;
    btnSROEdoit: TButton;
    ActionList1: TActionList;
    acSROAdd: TAction;
    acSRODel: TAction;
    acSROEdit: TAction;
    procedure acSROAddExecute(Sender: TObject);
    procedure acSROAddUpdate(Sender: TObject);
    procedure acSRODelExecute(Sender: TObject);
    procedure acSRODelUpdate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure acSROEditExecute(Sender: TObject);
    procedure acSROEditUpdate(Sender: TObject);
  end;

implementation

{$R *.dfm}

procedure TKisLicensedOrgEditor.acSROAddExecute(Sender: TObject);
begin
  inherited;
  dbgSRO.DataSource.DataSet.Append;
end;

procedure TKisLicensedOrgEditor.acSROAddUpdate(Sender: TObject);
begin
  inherited;
  acSROAdd.Enabled := not Entity.ReadOnly and dsSROPeriods.DataSet.Active;
end;

procedure TKisLicensedOrgEditor.acSRODelExecute(Sender: TObject);
begin
  inherited;
  dbgSRO.DataSource.DataSet.Delete;
end;

procedure TKisLicensedOrgEditor.acSRODelUpdate(Sender: TObject);
begin
  inherited;
  acSRODel.Enabled := not Entity.ReadOnly and dsSROPeriods.DataSet.Active and not dsSROPeriods.DataSet.IsEmpty;
end;

procedure TKisLicensedOrgEditor.acSROEditExecute(Sender: TObject);
begin
  inherited;
  dbgSRO.DataSource.DataSet.Edit;
end;

procedure TKisLicensedOrgEditor.acSROEditUpdate(Sender: TObject);
begin
  inherited;
  acSROEdit.Enabled := not Entity.ReadOnly and dsSROPeriods.DataSet.Active and not dsSROPeriods.DataSet.IsEmpty;
end;

procedure TKisLicensedOrgEditor.FormShow(Sender: TObject);
begin
  inherited;
  PageControl1.ActivePageIndex := 0;
end;

end.
