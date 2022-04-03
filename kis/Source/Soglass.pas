unit Soglass;

interface

uses

  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  IBCHILD, JvFormPlacement, Db, IBCustomDataSet, IBQuery, IBUpdateSQL, IBDatabase,
  Menus, ActnList, ImgList, Grids, DBGrids, ComCtrls, ToolWin, IBSQL, ExtCtrls,
  // jedi
  JvComponentBase,
  // kis comps
  uDBGrid, uLegend,
  // shared
  uDB, uIBXUtils;

type
  TSoglassForm = class(TIBChildForm)
    ib: TIBSQL;
    ibqNAMEISP: TIBQuery;
    ibqADMIN: TIBQuery;
    ibsDelValues: TIBSQL;
    ibqREGION: TIBQuery;
    QueryREGION: TStringField;
    QueryID: TIntegerField;
    QueryPROJECTID: TSmallintField;
    QueryPROJECT: TIBStringField;
    QueryADDRESS: TIBStringField;
    QuerySTADIA: TIBStringField;
    QueryMEN: TIBStringField;
    QueryCOMPANY: TIBStringField;
    QueryIDFORFIRMS: TIntegerField;
    QueryDOKUMENT: TMemoField;
    QueryZHPLOSH: TIBBCDField;
    QueryPLOSH: TIBBCDField;
    QueryOBPLOSH: TIBBCDField;
    QueryRESHENIE: TMemoField;
    QueryPODRAZD: TIBStringField;
    QueryISPOLNIT: TIBStringField;
    QueryDATEZAP: TDateTimeField;
    QueryIZMNAME: TIBStringField;
    QueryDATEIZM: TDateTimeField;
    QueryNAMEISP: TIBStringField;
    QueryIDFORCOMPANY: TIntegerField;
    QueryCOMPLIC: TMemoField;
    QueryCOMPINN: TIBStringField;
    QueryCOMPADDR: TIBStringField;
    QueryOBEM: TIBBCDField;
    QueryDATE_PODPIS: TDateField;
    QueryREGIONS_ID: TIntegerField;
    procedure actShowExecute(Sender: TObject);
    procedure ModifyRecord(New: Boolean=False);
    procedure QueryAfterInsert(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actDeleteExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  end;

var
  SoglassForm: TSoglassForm;

implementation

{$R *.DFM}

uses
  SoglassDoc, uKisConsts;

procedure TSoglassForm.actShowExecute(Sender: TObject);
begin
  inherited;
  ModifyRecord;
end;

procedure TSoglassForm.ModifyRecord(New: Boolean = False);
var
  ID: integer;
begin
  if ShowSoglassDoc(Query, DataSource) then
  begin
    ID := Query.FieldByName(SF_ID).AsInteger;
    Query.SoftPost();
    Transaction.CommitRetaining;
    Query.Locate(SF_ID, ID, []);
  end
  else
  begin
    Query.SoftCancel();
//    if New then Query.Delete;
    Transaction.RollbackRetaining;
  end;
end;

procedure TSoglassForm.QueryAfterInsert(DataSet: TDataSet);
begin
  inherited;
  ibqNAMEISP.Open;
  try
    Query.FieldByName('NAMEISP').AsString := ibqNAMEISP.Fields[0].AsString;
  finally
    ibqNAMEISP.Close;
  end;
  ModifyRecord;
end;

procedure TSoglassForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  SoglassForm := nil;
end;

procedure TSoglassForm.actDeleteExecute(Sender: TObject);
begin
  ibsDelValues.Params.ByName('IDOFSOGLASS').AsInteger:=
    Query.FieldByName(SF_ID).AsInteger;
  inherited;
  ibsDelValues.ExecQuery;
end;

procedure TSoglassForm.FormActivate(Sender: TObject);
begin
 inherited;
  Query.Close;
  Query.Open;
end;

end.
