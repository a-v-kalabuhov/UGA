unit uMStDialogSelectOrg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Grids, DBGrids,
  DB, IBCustomDataSet, IBQuery, IBDatabase,
  uDBGrid,
  uMStConsts,
  uMStModuleMapMngrIBX;

type
  TmstSelectOrgDialog = class(TForm)
    dbgrid: TkaDBGrid;
    Button1: TButton;
    Button2: TButton;
    IBQuery1: TIBQuery;
    DataSource1: TDataSource;
    ibxSelectOrgTransaction: TIBTransaction;
    IBQuery1ID: TIntegerField;
    IBQuery1NAME: TIBStringField;
    IBQuery1ADDRESS: TIBStringField;
    IBQuery1START_DATE: TDateField;
    IBQuery1END_DATE: TDateField;
    IBQuery1MAPPER_FIO: TIBStringField;
    Label1: TLabel;
    edSearch: TEdit;
    procedure edSearchChange(Sender: TObject);
    procedure dbgridDblClick(Sender: TObject);
  public
    function Execute(var Id: Integer; out OrgName: string): Boolean; 
  end;

var
  mstSelectOrgDialog: TmstSelectOrgDialog;

implementation

{$R *.dfm}

procedure TmstSelectOrgDialog.dbgridDblClick(Sender: TObject);
var
  Pt: TPoint;
  Cell: TGridCoord;
begin
  //
  Pt := dbgrid.ScreenToClient(Mouse.CursorPos);
  Cell := dbgrid.MouseCoord(Pt.X, Pt.Y);
  if Cell.X > 0 then
  if Cell.Y > 0 then
  begin
    if Cell.X = dbgrid.Col then
    if Cell.Y = dbgrid.Row then
      ModalResult := mrOk;
  end;
end;

procedure TmstSelectOrgDialog.edSearchChange(Sender: TObject);
var
  R: Integer;
begin
  if Trim(edSearch.Text) <> '' then
  begin
    IBQuery1.DisableControls;
    try
      R := IBQuery1.RecNo;
      if not IBQuery1.Locate(SF_NAME, edSearch.Text, [loCaseInsensitive, loPartialKey]) then
        IBQuery1.RecNo := R;
    finally
      IBQuery1.EnableControls;
    end;
  end;
end;

function TmstSelectOrgDialog.Execute(var Id: Integer; out OrgName: string): Boolean;
begin
  IBQuery1.Active := True;
  try
    IBQuery1.DisableControls;
    try
      if not IBQuery1.Locate(SF_ID, Id, []) then
        IBQuery1.First;
    finally
      IBQuery1.EnableControls;
    end;
    Result := ShowModal = mrOK;
    if Result then
    begin
      Id := IBQuery1.FieldByName(SF_ID).AsInteger;
      OrgName := IBQuery1.FieldByName(SF_NAME).AsString;
    end;
  finally
    IBQuery1.Active := False;
    if ibxSelectOrgTransaction.Active then
      ibxSelectOrgTransaction.Commit;
  end;
end;

end.
