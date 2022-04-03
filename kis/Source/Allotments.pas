unit Allotments;

interface

{$I KisFlags.pas}

uses                                                   
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  IBCHILD, Db, IBCustomDataSet, IBQuery, IBUpdateSQL, IBDatabase,
  Menus, DBActns, ActnList, ImgList, Grids, DBGrids, ComCtrls, ToolWin, ExtCtrls, IBSQL, StdCtrls,
  //
  FR_Class,
  //
  JvFormPlacement, JvComponentBase,
  //
  uDBGrid, uLegend, uSplitter;

type
  TAllotmentsForm = class(TIBChildForm)
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    actCopy: TAction;
    N18: TMenuItem;
    N19: TMenuItem;
    ibqRegions: TIBQuery;
    ibqOwners: TIBQuery;
    dsOwners: TDataSource;
    ibsPeople: TIBSQL;
    ibqCopyAllotments: TIBQuery;
    ibsCopyOther: TIBSQL;
    Splitter: TSplitter;
    dbgOwners: TkaDBGrid;
    QueryID: TIntegerField;
    QueryDOC_NUMBER: TIBStringField;
    QueryDOC_DATE: TDateTimeField;
    QueryYEAR_NUMBER: TIBStringField;
    QueryINFORMATION: TMemoField;
    QueryCHECKED: TSmallintField;
    QueryCANCELLED: TSmallintField;
    QueryCANCELLED_INFO: TIBStringField;
    QueryERROR_COORD: TSmallintField;
    QueryADDRESS: TIBStringField;
    QueryREGIONS_ID: TIntegerField;
    QueryINFO_LANDSCAPE: TMemoField;
    QueryINFO_REALTY: TMemoField;
    QueryINFO_MONUMENT: TMemoField;
    QueryINFO_MINERALS: TMemoField;
    QueryINFO_FLORA: TMemoField;
    QueryAREA: TFloatField;
    QueryEXECUTOR: TIBStringField;
    QueryINSERT_NAME: TIBStringField;
    QueryINSERT_TIME: TDateTimeField;
    QueryREGIONS_NAME: TStringField;
    QueryREGIONS_NAME_PREP: TIBStringField;
    QueryDOCUMENTS: TIBStringField;
    QueryPARENT_NUMBER: TIBStringField;
    QueryCHILD_NUMBER: TIBStringField;
    QueryVERSION: TIntegerField;
    ibqOwnersNAME: TIBStringField;
    ibqOwnersPERCENT: TFloatField;
    ibqOwnersPURPOSE: TIBStringField;
    QueryDECREE_PREPARED: TIBStringField;
    QueryANNUL_DATE: TDateField;
    QueryNEW_NUMBER: TIBStringField;
    QueryNEIGHBOURS: TMemoField;
    QueryPZ: TMemoField;
    QueryNOMENCLATURA: TIBStringField;
    QueryDESCRIPTION: TMemoField;
    QueryACCOMPLISHMENT_AREA: TFloatField;
    QueryTEMP_BUILDING_AREA: TFloatField;
    acShowLegend: TAction;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    QueryBOUNDARY_PROJECT_PREPARED: TStringField;
    QueryCREATOR: TStringField;
    QueryCADASTRE: TStringField;
    QueryLOT_KINDS_ID: TIntegerField;
    ibqLotKinds: TIBQuery;
    QueryLOT_KINDS_NAME: TStringField;
    QueryMSK36: TSmallintField;
    QueryLINK_CONSULTANT: TStringField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure QueryAfterScroll(DataSet: TDataSet);
    procedure actInsertUpdate(Sender: TObject);
    procedure actDeleteUpdate(Sender: TObject);
    procedure actShowExecute(Sender: TObject);
    procedure QueryAfterInsert(DataSet: TDataSet);
    procedure actCopyUpdate(Sender: TObject);
    procedure actCopyExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure acShowLegendExecute(Sender: TObject);
    procedure ibqLotKindsAfterOpen(DataSet: TDataSet);
    procedure GridCellColors(Sender: TObject; Field: TField; var Background,
      FontColor: TColor; State: TGridDrawState; var FontStyle: TFontStyles);
  private
    CanModify: Boolean;
    procedure ModifyRecord(New: Boolean=False);
  public
    Registration: Boolean;
  end;

var
  AllotmentsForm: TAllotmentsForm;

implementation

{$R *.DFM}

uses
  AGrids6, Allotment, AProc6, uKisClasses, uKisAppModule, uKisConsts, uGC,
  uKisExceptions;

procedure TAllotmentsForm.FormCreate(Sender: TObject);
begin
  inherited;
  Transaction.DefaultDatabase := AppModule.Database;
  AutoCommitAfterPost := False;
  Registration := True;
  CanModify := True;
  AppModule.ReadGridProperties(Self, dbgOwners);
  AppModule.ReadFormPosition(Self, Self);
  ibqRegions.Open;
  ibqRegions.FetchAll;
end;

procedure TAllotmentsForm.GridCellColors(Sender: TObject; Field: TField;
  var Background, FontColor: TColor; State: TGridDrawState;
  var FontStyle: TFontStyles);
begin
  inherited;
  if gdSelected in State then
  begin
    BackGround := clHighlight;
    FontColor := clWhite;
  end
  else
  if Boolean(Query.FieldByName(SF_CANCELLED).AsInteger) then
  begin
    BackGround := 8421600;
//    FontColor := clRed;
  end
  else
    if Boolean(Query.FieldByName(SF_CHECKED).AsInteger) then
      BackGround := clInfoBk;
end;

procedure TAllotmentsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  AllotmentsForm := nil;
  AppModule.WriteGridProperties(Self, dbgOwners);
  AppModule.WriteFormPosition(Self, Self);

end;

procedure TAllotmentsForm.QueryAfterScroll(DataSet: TDataSet);
begin
  inherited;
  with ibqOwners do begin
    Close;
    ParamByName(SF_ALLOTMENTS_ID).Value:=Query.FieldByName(SF_ID).Value;
    Open;
  end;
end;

procedure TAllotmentsForm.actInsertUpdate(Sender: TObject);
begin
  actInsert.Enabled := GetActionEnabled(actInsert) and Registration and Query.Active and CanModify;
end;

procedure TAllotmentsForm.actDeleteUpdate(Sender: TObject);
begin
  actDelete.Enabled := GetActionEnabled(actDelete) and Registration;
end;

procedure TAllotmentsForm.ModifyRecord(New: Boolean=False);
begin
  try
    if not CanModify then
      Exit;
    if New then
      QueryLOT_KINDS_ID.AsInteger := 0;
    if ShowAllotment(Registration) then
      Transaction.CommitRetaining
    else
    begin
      if New then
        Query.Delete
      else
        if Query.State in [dsInsert, dsEdit] then
          Query.Cancel;
      Transaction.RollbackRetaining;
    end;
  except
    on E: Exception do
      with EAllotmentException.Create(E, '') do
      begin
        Id := QueryID.AsInteger;
        raise Me;
      end;
  end;
end;

procedure TAllotmentsForm.actShowExecute(Sender: TObject);
begin
  inherited;
  ModifyRecord;
end;

procedure TAllotmentsForm.QueryAfterInsert(DataSet: TDataSet);
begin
  inherited;
  QueryDOC_DATE.Value := Date;
  Query.Post;
  Query.Edit;
  QueryCREATOR.Value := AppModule.User.ShortName;
  ibsPeople.ExecQuery;
  try
    if not ibsPeople.Eof then
      QueryEXECUTOR.Value := ibsPeople.FieldByName(SF_LAST_NAME).Value;
  finally
    ibsPeople.Close;
  end;
  ModifyRecord(True);
end;

procedure TAllotmentsForm.actCopyUpdate(Sender: TObject);
begin
  actCopy.Enabled:= {Registration and} not(Query.Bof and Query.Eof);
end;

procedure TAllotmentsForm.actCopyExecute(Sender: TObject);
var
  AllotmentsId, NewId: Integer;
  old_reg: Boolean;
begin
  CanModify := False;
  AllotmentsId := Query.FieldByName(SF_ID).Value;
  try
    with ibqCopyAllotments do
    begin
      ParamByName(SF_ID).Value := AllotmentsId;
      Open;
      if not Eof then
        try
          //копируем из ALLOTMENTS
          Query.Insert;
          NewId := Query.FieldByName(SF_ID).Value;
          Query.FieldByName(SF_ADDRESS).Value := FieldByName(SF_ADDRESS).Value;
          Query.FieldByName(SF_REGIONS_ID).Value := FieldByName(SF_REGIONS_ID).Value;
          Query.FieldByName(SF_AREA).Value := FieldByName(SF_AREA).Value;
          Query.FieldByName(SF_CANCELLED).Value := FieldByName(SF_CANCELLED).Value;
          Query.FieldByName(SF_CANCELLED_INFO).Value := FieldByName(SF_CANCELLED_INFO).Value;
          Query.FieldByName(SF_ERROR_COORD).Value := FieldByName(SF_ERROR_COORD).Value;
          Query.FieldByName(SF_INFORMATION).Value := FieldByName(SF_INFORMATION).Value;
          Query.FieldByName(SF_INFO_LANDSCAPE).Value := FieldByName(SF_INFO_LANDSCAPE).Value;
          Query.FieldByName(SF_INFO_REALTY).Value := FieldByName(SF_INFO_REALTY).Value;
          Query.FieldByName(SF_INFO_MONUMENT).Value := FieldByName(SF_INFO_MONUMENT).Value;
          Query.FieldByName(SF_INFO_MINERALS).Value := FieldByName(SF_INFO_MINERALS).Value;
          Query.FieldByName(SF_INFO_FLORA).Value := FieldByName(SF_INFO_FLORA).Value;
          Query.FieldByName(SF_PZ).Value := FieldByName(SF_PZ).Value;
          Query.FieldByName(SF_NEIGHBOURS).Value := FieldByName(SF_NEIGHBOURS).Value;
          Query.FieldByName(SF_EXECUTOR).Value := AppModule.User.ShortName;
        finally
          Close;
        end
      else
        raise Exception.Create(S_RECORD_NOT_FOUND);
    end;
    with ibsCopyOther do
    begin
      //копируем из ALLOTMENT_CONTOURS
      SQL.Clear;
      SQL.Add('INSERT INTO ALLOTMENT_CONTOURS');
      SQL.Add('SELECT ' + IntToStr(NewId) + ', ID, ENABLED, POSITIVE');
      SQL.Add('FROM ALLOTMENT_CONTOURS');
      SQL.Add('WHERE ALLOTMENTS_ID=' + IntToStr(AllotmentsId));
      ExecQuery;
      //копируем из ALLOTMENT_POINTS
      SQL.Clear;
      SQL.Add('INSERT INTO ALLOTMENT_POINTS');
      SQL.Add('SELECT ' + IntToStr(NewId) + ', CONTOURS_ID, ID, NAME, X, Y');
      SQL.Add('FROM ALLOTMENT_POINTS');
      SQL.Add('WHERE ALLOTMENTS_ID=' + IntToStr(AllotmentsId));
      ExecQuery;
      //копируем из ALLOTMENT_DOCS
      SQL.Clear;
      SQL.Add('INSERT INTO ALLOTMENT_DOCS (ALLOTMENTS_ID, ID, DECREES_ID)');
      SQL.Add('SELECT ' + IntToStr(NewId) + ', ID, DECREES_ID');
      SQL.Add('FROM ALLOTMENT_DOCS');
      SQL.Add('WHERE ALLOTMENTS_ID=' + IntToStr(AllotmentsId));
      ExecQuery;
      //копируем из ALLOTMENT_OWNERS
      SQL.Clear;
      SQL.Add('INSERT INTO ALLOTMENT_OWNERS');
      SQL.Add('SELECT ' + IntToStr(NewId) + ', ID, FIRMS_ID, NAME, PERCENT, PURPOSE, PROP_FORMS_ID, RENT_PERIOD');
      SQL.Add('FROM ALLOTMENT_OWNERS');
      SQL.Add('WHERE ALLOTMENTS_ID=' + IntToStr(AllotmentsId));
      ExecQuery;
    end;
  finally
    CanModify := True;
  end;
  old_reg := Registration;
  Registration := True;
  ModifyRecord;
  Registration := old_reg;
end;

procedure TAllotmentsForm.actDeleteExecute(Sender: TObject);
begin
  if not AppModule.User.IsAdministrator and
    (AppModule.User.UserName <> Query.FieldByName(SF_INSERT_NAME).AsString) then
    raise Exception.Create(S_ONLY_OWNER_CAN_DELETE_LOT);
  inherited;
end;

procedure TAllotmentsForm.ibqLotKindsAfterOpen(DataSet: TDataSet);
begin
  inherited;
  ibqLotKinds.FetchAll;
end;

procedure TAllotmentsForm.acShowLegendExecute(Sender: TObject);
begin
  Legend.ShowLegend(Self.Height - Legend.FormHeight, Self.Width - Legend.FormWidth);
end;

end.
