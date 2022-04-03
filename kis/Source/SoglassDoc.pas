unit SoglassDoc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Menus,
  Mask, DBCtrls, Grids, DBGrids, Buttons, StdCtrls, ExtCtrls, ComCtrls, Db,
  IBCustomDataSet, IBQuery, IBUpdateSQL, IBSQL, IBChild, IBDatabase, DBTables,
  // jedi
  JvFormPlacement,
  // shared
  uDB, uIBXUtils;

type
  TSoglassDocForm = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    btnPrint: TButton;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    dbeZAKL: TDBEdit;
    dbePROJECT: TDBEdit;
    dbeDATA: TDBEdit;
    dbeNAMEISP: TDBEdit;
    dbeSTADIA: TDBEdit;
    dbeADDRESS: TDBEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    dbeMEN: TDBEdit;
    dbeCOMPANY: TDBEdit;
    dbmCOMPLIC: TDBMemo;
    dbeCOMPINN: TDBEdit;
    dbeCOMPADDR: TDBEdit;
    dbeZHPLOSH: TDBEdit;
    dbePLOSH: TDBEdit;
    dbeOBPLOSH: TDBEdit;
    dbeOBEM: TDBEdit;
    btnSel1: TButton;
    btnFirmsShow1: TButton;
    btnClear1: TButton;
    btnClear2: TButton;
    btnFirmsShow2: TButton;
    btnSel2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    GroupBox3: TGroupBox;
    ibsValuesMaxId: TIBSQL;
    dbmDOCUMENT: TDBMemo;
    dbmRESHENIE: TDBMemo;
    Label16: TLabel;
    Label17: TLabel;
    Label10: TLabel;
    ibsCountValues: TIBSQL;
    dbgValues: TDBGrid;
    ibqVal: TIBQuery;
    dsValues: TDataSource;
    btnAdd: TButton;
    btnDel: TButton;
    btnDialog: TButton;
    ibuValues: TIBUpdateSQL;
    ibsValues: TIBSQL;
    Label11: TLabel;
    dblsREGION: TDBLookupComboBox;
    MainDS: TDataSource;
    procedure btnOKClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure frReport1GetValue(const ParName: String;
      var ParValue: Variant);
    procedure btnSel1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnFirmsShow1Click(Sender: TObject);
    procedure BtnSel2Click(Sender: TObject);
    procedure btnFirmsShow2Click(Sender: TObject);
    procedure BtnClear1Click(Sender: TObject);
    procedure btnClear2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SetControls;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure ibqValAfterInsert(DataSet: TDataSet);
    procedure btnAddClick(Sender: TObject);
    procedure btnDialogClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure ibqValBeforeDelete(DataSet: TDataSet);
    procedure PutParams;
    procedure FormCreate(Sender: TObject);

  private
//    SoglassDocID: Integer;
    SOGLASOVANIEID: INTEGER;
    procedure SetSecondControls;
    procedure InitIBX;
    procedure ReportParameterInit;
  public
    { Public declarations }
  end;

var
  SoglassDocForm: TSoglassDocForm;
  ReportParameter: array[1..26] of String;
  Priznak: Boolean = False;

  function ShowSoglassDoc(MainQuery: TIBQuery; DS: TDataSource;
    CanCancel: Boolean = True): Boolean;

implementation

{$R *.DFM}

uses
  // Common
  uGC,
  // Project
  uKisMainView, Soglass, uKisConsts, uKisAppModule, uKisIntf,
  SoglassDocAdd, uKisPrintModule, uKisClasses, uKisSQLClasses, uKisFirms,
  uKisEntityEditor;

function ShowSoglassDoc(MainQuery: TIBQuery; DS: TDataSource;
  CanCancel: Boolean = True): Boolean;
var
  I: Integer;
begin
  with TSoglassDocForm.Create(Application) do
  try
    for I := 0 to Pred(ComponentCount) do
      if Components[I] is TDBEdit then
        TDBEdit(Components[I]).DataSource := DS
      else
      if Components[I] is TDBMemo then
        TDBMemo(Components[I]).DataSource := DS
      else
      if Components[I] is TDBLookupComboBox then
        TDBLookupComboBox(Components[I]).DataSource := DS
      else
      if Components[I] is TDBComboBox then
        TDBComboBox(Components[I]).DataSource := DS;
    btnCancel.Visible := CanCancel;
    Result := (ShowModal = mrOk) or not CanCancel;
  finally
    Release;
  end;
end;


procedure TSoglassDocForm.btnOKClick(Sender: TObject);
var
  I: Integer;
begin
  ibqVal.SoftPost();
  if not TryStrToInt(dbeZakl.Text, I) then
  begin
    MessageBox(Handle, PChar(S_PLEASE_FILL_FIELD + ' "Номер заключения"!'), PChar(S_WARN), MB_ICONWARNING);
    dbeZakl.SetFocus;
    Exit;
  end;
  ModalResult := mrOk;
end;

procedure TSoglassDocForm.ReportParameterInit;
var
  I: Integer;
begin
  for I := Low(ReportParameter) to High(ReportParameter) do
    ReportParameter[I] := '';
end;

procedure TSoglassDocForm.btnPrintClick(Sender: TObject);
var
  I: Integer;
begin
   ibqVal.SoftPost();
   ReportParameterInit;
   with SoglassForm.Query do
   begin
     ReportParameter[1]:= FieldByName('PROJECTID').AsString;
     ReportParameter[2]:= FieldByName('PROJECT').AsString;
     ReportParameter[3]:= FieldByName(SF_ADDRESS).AsString;
     ReportParameter[4]:= FieldByName('STADIA').AsString;
     ReportParameter[5]:= FieldByName('MEN').AsString;
     ReportParameter[6]:= FieldByName('COMPANY').AsString;
     ReportParameter[7]:= FieldByName('DOKUMENT').AsString;
     ReportParameter[8]:= FieldByName('ZHPLOSH').AsString;
     ReportParameter[9]:= FieldByName('PLOSH').AsString;
     ReportParameter[10]:= FieldByName('OBPLOSH').AsString;
     ReportParameter[11]:= FieldByName('RESHENIE').AsString;
     ReportParameter[12]:= FieldByName('COMPADDR').AsString;
     ReportParameter[13]:= FieldByName('COMPLIC').AsString;
     ReportParameter[14]:= FieldByName('COMPINN').AsString;
     ReportParameter[15]:= FieldByName('OBEM').AsString;
     ReportParameter[16]:= FieldByName('NAMEISP').AsString;
   end;

   PutParams;

   ibsCountValues.Params.ByName('IDOFSOGLASS').AsInteger:=
     SoglassForm.Query.FieldByName(SF_ID).AsInteger;
   ibsCountValues.ExecQuery;
   ibsCountValues.Close;

   with PrintModule(True) do
   begin
     ReportFile := AppModule.ReportsPath + 'Soglas.frf';
     for I := 1 to 21 do
       SetParamValue(Format('STRING%.2d', [I]), ReportParameter[I]);
     PrintReport;
   end;
end;

procedure TSoglassDocForm.frReport1GetValue(const ParName: String;
  var ParValue: Variant);
begin
  ParValue := ReportParameter[StrToInt(Copy(ParName,7,2))];
end;

procedure TSoglassDocForm.btnSel1Click(Sender: TObject);
var
  Firm: TKisFirm;
  aId: Integer;
begin
  aId := SoglassForm.Query.FieldByName('IDFORFIRMS').AsInteger;
  with AppModule.SQLMngrs[kmFirms] do
  begin
    Firm := KisObject(SelectEntity(True, nil, False, aId)).AEntity as TKisFirm;
    if not (SoglassForm.Query.State in [dsEdit, dsInsert]) then
      SoglassForm.Query.Edit;
    SoglassForm.Query.FieldByName('IDFORFIRMS').AsInteger := Firm.ID;
    SoglassForm.Query.FieldByName('MEN').AsString := Firm.Name;
  end;
  SetControls;
end;

procedure TSoglassDocForm.FormDestroy(Sender: TObject);
begin
  SoglassDocForm := nil;
end;

procedure TSoglassDocForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TSoglassDocForm.btnFirmsShow1Click(Sender: TObject);
begin
  with KisObject(AppModule[kmFirms].GetEntity(SoglassForm.Query.FieldByName('IDFORFIRMS').AsInteger)).AEntity as TKisVisualEntity do
  begin
    ReadOnly := True;
    Edit;
  end;
end;

procedure TSoglassDocForm.BtnSel2Click(Sender: TObject);
var
  Firm: TKisFirm;
  aId: Integer;
begin
  aId := SoglassForm.Query.FieldByName('IDFORCOMPANY').AsInteger;
  Firm := KisObject(AppModule.SQLMngrs[kmFirms].SelectEntity(True, nil, True, aId)).AEntity as TKisFirm;
  if not Assigned(Firm) then
    Exit;
  if not(SoglassForm.Query.State in [dsEdit, dsInsert]) then
    SoglassForm.Query.Edit;
  SoglassForm.Query.FieldByName('IDFORCOMPANY').AsInteger := Firm.ID;
  SoglassForm.Query.FieldByName('COMPANY').AsString := Firm.Name;
  SoglassForm.Query.FieldByName('COMPINN').AsString := Firm.INN;
  SoglassForm.Query.FieldByName('COMPADDR').AsString := Firm.Address;
  SetControls;
end;


procedure TSoglassDocForm.btnFirmsShow2Click(Sender: TObject);
var
  aId: Integer;
begin
  aId := SoglassForm.Query.FieldByName('IDFORCOMPANY').AsInteger;
  with KisObject(AppModule[kmFirms].GetEntity(aId)).AEntity as TKisVisualEntity do
  begin
    ReadOnly := True;
    Edit;
  end;
end;

procedure TSoglassDocForm.BtnClear1Click(Sender: TObject);
begin
  SoglassForm.Query.SoftEdit();
  SoglassForm.Query.FieldByName('MEN').Clear;
  dbeMen.Text := '';
  SoglassForm.Query.FieldByName('IDFORFIRMS').AsInteger :=0;
  dbeMEN.SetFocus;
  btnFirmsShow1.Enabled := False;
  dbeMEN.ReadOnly := False;
end;

procedure TSoglassDocForm.btnClear2Click(Sender: TObject);
begin
  SoglassForm.Query.SoftEdit();
  SoglassForm.Query.FieldByName('COMPANY').AsString:='';
  SoglassForm.Query.FieldByName('COMPADDR').AsString:='';
  SoglassForm.Query.FieldByName('COMPINN').AsString:='';
  dbeCompany.text:='';
  SoglassForm.Query.FieldByName('IDFORCOMPANY').AsInteger:=0;
  dbeCOMPANY.SetFocus;
  btnFirmsShow2.Enabled:=False;
  dbeCOMPANY.ReadOnly:=False;
end;



procedure TSoglassDocForm.FormShow(Sender: TObject);
begin
  SetControls;
end;

procedure TSoglassDocForm.SetControls;
begin
  btnFirmsShow1.Enabled:=(not SoglassForm.Query.FieldByName('IDFORFIRMS').IsNull)
    and  (SoglassForm.Query.FieldByName('IDFORFIRMS').AsInteger<>0);
  dbeMEN.ReadOnly:= (not SoglassForm.Query.FieldByName('IDFORFIRMS').IsNull)
    and  (SoglassForm.Query.FieldByName('IDFORFIRMS').AsInteger<>0);

  btnFirmsShow2.Enabled:=(not SoglassForm.Query.FieldByName('IDFORCOMPANY').IsNull)
     and  (SoglassForm.Query.FieldByName('IDFORCOMPANY').AsInteger<>0) ;
  dbeCOMPANY.ReadOnly:=not SoglassForm.Query.FieldByName('IDFORCOMPANY').IsNull
     and  (SoglassForm.Query.FieldByName('IDFORCOMPANY').AsInteger<>0);
end;

procedure TSoglassDocForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 SoglassDocForm := nil;
end;


procedure TSoglassDocForm.FormActivate(Sender: TObject);
begin
   SOGLASOVANIEID:=SoglassForm.Query.FieldByName(SF_ID).AsInteger;
   ibqVal.ParamByName('IDOFSOGLASS').AsInteger:= SOGLASOVANIEID;
   ibqVal.Open;
   SetSecondControls;
end;

procedure TSoglassDocForm.ibqValAfterInsert(DataSet: TDataSet);
begin
  with ibqVal do begin
    FieldValues['IDOFSOGLASS']:=SOGLASOVANIEID;
    ibsValuesMaxId.Params.ByName('IDOFSOGLASS').AsInteger:=SOGLASOVANIEID;

    ibsValuesMaxId.ExecQuery;
    try
      FieldValues[SF_ID] := Succ(ibsValuesMaxId.FieldByName(SF_MAX_ID).AsInteger);
    finally
      ibsValuesMaxId.Close;
    end;
    ibqVal.SoftPost();
  end;
end;

procedure TSoglassDocForm.btnAddClick(Sender: TObject);
begin
  SoglassDocAddForm.Init;
  SetSecondControls;
  ibqVal.SoftPost();
end;

procedure TSoglassDocForm.btnDialogClick(Sender: TObject);
begin
  if not ibqVal.IsEmpty then SoglassDocAddForm.Init;
end;

procedure TSoglassDocForm.btnDelClick(Sender: TObject);
begin
  if not ibqVal.IsEmpty then ibqVal.Delete;
  SetSecondControls;
end;

procedure TSoglassDocForm.ibqValBeforeDelete(DataSet: TDataSet);
begin
  if MessageBox(0, PChar(S_CONFIRM_DELETE_RECORD), PChar(S_CONFIRM), MB_ICONQUESTION+MB_OKCANCEL)<>IDOK then Abort;
end;

procedure TSoglassDocForm.SetSecondControls;
begin
  btnDialog.Enabled := not ibqVal.IsEmpty;
  btnDel.Enabled := not ibqVal.IsEmpty;
end;

procedure TSoglassDocForm.PutParams;
var
  stName, stPlosh, stZhplosh, stObPlosh, stObem: String;

  procedure AddProbels;
  var
    Long1: integer;
    count, i :integer;
  begin
    long1 := 14;
    count := long1 - length(ibsValues.FieldByName(SF_NAME).AsString);
    for i := 1 to count do stName := stName + ' ';
    count := long1 - length(ibsValues.FieldByName('ZHPLOSH').AsString);
    for i := 1 to count + 10 do stZhPlosh := stZhPlosh + ' ';
    count := long1 - length(ibsValues.FieldByName('PLOSH').AsString);
    Inc(count, 10);
    for i := 1 to count do stPlosh := stPlosh + ' ';
    count := long1 - length(ibsValues.FieldByName('OBPLOSH').AsString);
    Inc(count, 10);
    for i := 1 to count do stObPlosh := stObPlosh + ' ';
    count := long1 - length(ibsValues.FieldByName('OBEM').AsString);
    Inc(count, 10);
    for i := 1 to count do stOBEM := stOBEM + ' ';
  end;

begin
  stName := EmptyStr;
  stPlosh := EmptyStr;
  stZhPlosh := EmptyStr;
  stObPlosh := EmptyStr;
  stObem := EmptyStr;

  with ibsValues do
  begin
    Params.ByName('IDOFSOGLASS').AsInteger:= SoglassForm.Query.FieldByName(SF_ID).AsInteger;
    ExecQuery;
    try
      while not Eof do
      begin
       {  Основное заполнение  }
        stName := stName + FieldByName(SF_NAME).AsString;
        stZhplosh := stZhplosh + FieldByName('ZHPLOSH').AsString;
        stPlosh := stPlosh + FieldByName('PLOSH').AsString;
        stObPlosh := stObPlosh + FieldByName('OBPLOSH').AsString;
        stObem := stObem + FieldByName('OBEM').AsString;
        AddProbels;
        Next;
      end;
    finally
      Close;
    end;
   end;

  ReportParameter[17] := stName;
  ReportParameter[18] := stZhPlosh;
  ReportParameter[19] := stPlosh;
  ReportParameter[20] := stObPlosh;
  ReportParameter[21] := stObem;
end;

procedure TSoglassDocForm.InitIBX;
begin
  ibsValuesMaxId.Transaction := SoglassForm.Transaction;
  ibsCountValues.Transaction := SoglassForm.Transaction;
  ibqVal.Transaction := SoglassForm.Transaction;
  ibsValues.Transaction := SoglassForm.Transaction;
end;

procedure TSoglassDocForm.FormCreate(Sender: TObject);
begin
  InitIBX;
end;

end.
