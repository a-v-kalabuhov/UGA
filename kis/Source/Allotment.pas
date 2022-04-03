unit Allotment;

{$I KisFlags.pas}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  StdCtrls, ComCtrls, Mask, DBCtrls, Grids, DBGrids, Buttons, Math, Contnrs,
  IBQuery, IBCustomDataSet,IBUpdateSQL, IBSQL, ImgList, Db, Menus, ActnList,
  ToolWin, Contour, Point, Draw, IBTable, IBDatabase, ExtCtrls, Dialogs, ShellAPi,
  // Fast Report
  FR_Class, FR_IBXQuery,
  // Common
  uCommonUtils, uDB, uGraphics,
  // Project
  uKisPrintModule, uKisAppModule, uKisAllotmentClasses;

type
  TDoubleRec = record
    X, Y: Double;
  end;
  TDoubleArray = array of TDoubleRec;

  TkisExportFormat = (efDXF, efText);

  TAllotmentForm = class(TForm)
    PageControl: TPageControl;
    tshData: TTabSheet;
    tshCoordinats: TTabSheet;
    btnOk: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    dbeAddress: TDBEdit;
    Label2: TLabel;
    dbcbRegion: TDBLookupComboBox;
    dbeArea: TDBEdit;
    Label3: TLabel;
    PictPanel: TPanel;
    PaintBox: TPaintBox;
    tshInfo: TTabSheet;
    dbmLandscape: TDBMemo;
    Label16: TLabel;
    dbeCancelledInfo: TDBEdit;
    Label12: TLabel;
    dbeDocDate: TDBEdit;
    dbchErrorCoord: TDBCheckBox;
    Label4: TLabel;
    dbmRealty: TDBMemo;
    Label5: TLabel;
    dbmMonument: TDBMemo;
    Label9: TLabel;
    dbmFlora: TDBMemo;
    Label13: TLabel;
    dbmInformation: TDBMemo;
    ibqOwners: TIBQuery;
    dsOwners: TDataSource;
    gbOwners: TGroupBox;
    gbDecrees: TGroupBox;
    dbgOwners: TDBGrid;
    ibusOwners: TIBUpdateSQL;
    bntOwnerNew: TButton;
    btnOwnerDel: TButton;
    btnOwnerEdit: TButton;
    dbgDocs: TDBGrid;
    btnDecreeNew: TButton;
    btnDecreeDel: TButton;
    btnDecreeEdit: TButton;
    ibqDocs: TIBQuery;
    ibusDocs: TIBUpdateSQL;
    dsDocs: TDataSource;
    dbchChecked: TDBCheckBox;
    ibsOwnersNextId: TIBSQL;
    ibsOwnersSumPercent: TIBSQL;
    dbchCancelled: TDBCheckBox;
    btnDecreeDetail: TButton;
    ibqDecrees: TIBQuery;
    ibsDocsNextId: TIBSQL;
    lvPoints: TListView;
    ImageList: TImageList;
    lvContours: TListView;
    Label7: TLabel;
    Label14: TLabel;
    edtArea: TEdit;
    Label17: TLabel;
    Label18: TLabel;
    ibsContoursNew: TIBSQL;
    ibsContoursUpdate: TIBSQL;
    ibsContoursDel: TIBSQL;
    PopupMenu: TPopupMenu;
    ActionList: TActionList;
    actNew: TAction;
    actDel: TAction;
    actEdit: TAction;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    tbRecord: TToolBar;
    btnNew: TToolButton;
    btnDel: TToolButton;
    btnEdit: TToolButton;
    ibsPointsNew: TIBSQL;
    ibsPointsUpdate: TIBSQL;
    ibsPointsDel: TIBSQL;
    btnPointCopy: TSpeedButton;
    ibsPointsMaxId: TIBSQL;
    btnChecked: TButton;
    ibqPoints: TIBQuery;
    btnWriteArea: TSpeedButton;
    ibqAllPoints: TIBQuery;
    ibqContours: TIBQuery;
    btnPrint: TButton;
    ibtrReports: TIBTransaction;
    ibtReports: TIBTable;
    dsReports: TDataSource;
    ibsFirms: TIBSQL;
    Label33: TLabel;
    dbeExecutor: TDBEdit;
    ibqOwnersALLOTMENTS_ID: TIntegerField;
    ibqOwnersID: TSmallintField;
    ibqOwnersFIRMS_ID: TIntegerField;
    ibqOwnersNAME: TIBStringField;
    ibqOwnersPERCENT: TFloatField;
    ibqOwnersPURPOSE: TIBStringField;
    ibqOwnersPROP_FORMS_ID: TIntegerField;
    ibqOwnersRENT_PERIOD: TSmallintField;
    ibqOwnersPROP_FORMS_NAME: TStringField;
    ibqOwnersPROP_FORMS_NAME_ACC: TIBStringField;
    ibqPropForms: TIBQuery;
    ibsDocs: TIBSQL;
    dbeDocuments: TDBEdit;
    Label6: TLabel;
    ibtReportsUSER_NAME: TIBStringField;
    ibtReportsSTRING01: TIBStringField;
    ibtReportsSTRING02: TIBStringField;
    ibtReportsSTRING03: TIBStringField;
    ibtReportsSTRING04: TIBStringField;
    ibtReportsSTRING05: TIBStringField;
    ibtReportsSTRING06: TIBStringField;
    ibtReportsSTRING07: TIBStringField;
    ibtReportsSTRING08: TIBStringField;
    ibtReportsSTRING09: TIBStringField;
    ibtReportsSTRING10: TIBStringField;
    ibtReportsMEMO1: TMemoField;
    ibtReportsMEMO2: TMemoField;
    ibtReportsMEMO3: TMemoField;
    ibqGetPrintInf: TIBQuery;
    ibtList: TIBTransaction;
    Label11: TLabel;
    dbeDocNumber: TDBEdit;
    dbeParentNumber: TDBEdit;
    Label10: TLabel;
    dbeChildNumber: TDBEdit;
    Label15: TLabel;
    Label19: TLabel;
    dbeDecreePrepared: TDBEdit;
    Label20: TLabel;
    dbeAnnulDate: TDBEdit;
    dbeNewNumber: TDBEdit;
    Label21: TLabel;
    tshOther: TTabSheet;
    Label23: TLabel;
    dbmNeighbours: TDBMemo;
    Label22: TLabel;
    dbeNomenclatura: TDBEdit;
    btnCalcNomenclatur: TButton;
    dbmPZ: TDBMemo;
    Label24: TLabel;
    ibqDocsALLOTMENTS_ID: TIntegerField;
    ibqDocsID: TSmallintField;
    ibqDocsDECREES_ID: TIntegerField;
    ibqDocsDOC_NUMBER: TIBStringField;
    ibqDocsDOC_DATE: TDateTimeField;
    ibqDocsHEADER: TIBStringField;
    ibqDocsDECREE_TYPES_NAME: TIBStringField;
    ibqDocsDECREE_TYPES_ID: TIntegerField;
    dbmDescr: TDBMemo;
    Label25: TLabel;
    acPasteContour: TAction;
    acPasteContour1: TMenuItem;
    acCopyPoints: TAction;
    acCopyAllPoints: TAction;
    dbedAccomplishmentArea: TDBEdit;
    Label26: TLabel;
    dbedTempBuildingArea: TDBEdit;
    Label27: TLabel;
    acExportToDXF: TAction;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    DXF1: TMenuItem;
    N7: TMenuItem;
    SaveDialog: TSaveDialog;
    dbeBoundaryProjectPrepared: TDBEdit;
    Label8: TLabel;
    Label28: TLabel;
    N8: TMenuItem;
    Label29: TLabel;
    dbeCreator: TDBEdit;
    Label30: TLabel;
    dbeCadastr: TDBEdit;
    btnClearCadastre: TButton;
    dbcbLotKinds: TDBLookupComboBox;
    Label31: TLabel;
    dbchMSK36: TDBCheckBox;
    chbShowMSK36: TCheckBox;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    SaveDialog1: TSaveDialog;
    SpeedButton1: TSpeedButton;
    alPoints: TActionList;
    acPointAdd: TAction;
    acPointDelete: TAction;
    acPointEdit: TAction;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    acPointCopy: TAction;
    acPointNamePlus: TAction;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    acCntAdd: TAction;
    acCntEdit: TAction;
    acCntDel: TAction;
    ilContours: TImageList;
    ilContoursDefault: TImageList;
    Label32: TLabel;
    dbeConsultant: TDBEdit;
    btnOpenLinkConsultant: TButton;
    procedure bntOwnerNewClick(Sender: TObject);
    procedure btnOwnerEditClick(Sender: TObject);
    procedure btnOwnerDelClick(Sender: TObject);
    procedure btnDecreeDetailClick(Sender: TObject);
    procedure btnDecreeDelClick(Sender: TObject);
    procedure btnDecreeNewClick(Sender: TObject);
    procedure btnDecreeEditClick(Sender: TObject);
    procedure lvPointsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure actNewExecute(Sender: TObject);
    procedure actDelExecute(Sender: TObject);
    procedure actEditExecute(Sender: TObject);
    procedure lvPointsEditing(Sender: TObject; Item: TListItem; var AllowEdit: Boolean);
    procedure lvContoursEditing(Sender: TObject; Item: TListItem; var AllowEdit: Boolean);
    procedure lvContoursSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure lvPointsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lvPointsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lvContoursDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lvContoursDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure btnCheckedClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnWriteAreaClick(Sender: TObject);
    procedure PaintBoxPaint(Sender: TObject);
    procedure PaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnPrintClick(Sender: TObject);
    procedure btnCalcNomenclaturClick(Sender: TObject);
    procedure dbeAddressChange(Sender: TObject);
    procedure acPasteContourExecute(Sender: TObject);
    procedure acPasteContourUpdate(Sender: TObject);
    procedure acCopyPointsUpdate(Sender: TObject);
    procedure acCopyAllPointsUpdate(Sender: TObject);
    procedure acCopyPointsExecute(Sender: TObject);
    procedure acCopyAllPointsExecute(Sender: TObject);
    procedure acExportToDXFExecute(Sender: TObject);
    procedure dbchCheckedClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure btnClearCadastreClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure dbchMSK36Click(Sender: TObject);
    procedure chbShowMSK36Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure acPointAddUpdate(Sender: TObject);
    procedure acPointAddExecute(Sender: TObject);
    procedure acPointDeleteExecute(Sender: TObject);
    procedure acPointDeleteUpdate(Sender: TObject);
    procedure acPointEditUpdate(Sender: TObject);
    procedure acPointEditExecute(Sender: TObject);
    procedure acPointCopyExecute(Sender: TObject);
    procedure acPointCopyUpdate(Sender: TObject);
    procedure acPointNamePlusExecute(Sender: TObject);
    procedure acPointNamePlusUpdate(Sender: TObject);
    procedure acCntEditExecute(Sender: TObject);
    procedure acCntEditUpdate(Sender: TObject);
    procedure acCntDelUpdate(Sender: TObject);
    procedure acCntAddUpdate(Sender: TObject);
    procedure acCntAddExecute(Sender: TObject);
    procedure acCntDelExecute(Sender: TObject);
    procedure btnOpenLinkConsultantClick(Sender: TObject);
  private
    FMainQuery: TIBQuery;
    AllotmentsId: Integer;
    ReadOnly: Boolean;
    FContours: TContours;
    fArea: Double;
    procedure AddEmptyContour;
    procedure CalcNomenclature;
    procedure ContourDel;
    procedure ContourEdit;
    procedure ContourInsert(Contour: TContour);
    procedure ContourNew;
    procedure DBDeletePoint(Pt: TKisPoint; Cnt: TContour);
    procedure DBSaveContour(Cnt: TContour);
    procedure DBSavePoint(Pt: TKisPoint; Cnt: TContour; Update: Boolean);
    function  GetActiveContour(const DoRaise: Boolean): TContour;
    function  GetShowCS: TCoordSystem;
    function  GetDocs: string;
    function  GetFullFirmName(WithAddress, AllOwners: Boolean): String;
    function  IncPointName(PointName: String; delta: integer):String;
    procedure InitIBX;
    procedure LoadContourPoints(Cnt: TContour);

    procedure SetOwnersControls;
    procedure SetDecreesControls;
    procedure LoadContours(Selected: Integer = 0);
    procedure PrepareContourIcon(Cnt: TContour);

    procedure PointDel;
    procedure PointEdit;
    procedure PointInsert;
    procedure PointCopy();
    procedure PointNamePlus();
    procedure ShowContours(Selected: Integer = 0);

    procedure PointNew;
    procedure PrepareReportParams(Module: TKisPrintModule; AllOwners: Boolean);
    procedure SelectItem(ListItem: TListItem);
    procedure SetCaption(const ACaption: String = '');

    procedure SetItemVisible(ListItem: TListItem; BottomIndent: Integer = 20);
    procedure ShowArea;
    procedure ShowPoints(Cnt: TContour; PointId: Integer; Flg: Boolean = false);

    procedure PrintAllotment(ReportIndex: Integer; AllOwners: Boolean);
    function  MapCasesByAllotment: TStringList;
    procedure PrintFROtvodRoman1(const AReportName: String; AllOwners: Boolean);
    procedure PrintFROther(const AReportName: String; AllOwners: Boolean);
    procedure PrintFRTech(const AReportName: String; AllOwners: Boolean);
    procedure CopyPoints(All: Boolean);
    function  PointsToDXF(const FileName: String; const Points: TContour): Boolean;
    function  PointsToTxt(const FileName: String; const Points: TContour): Boolean;
    procedure ExportToFile(Format: TkisExportFormat);
  strict private
    function GetPointsDebugInfo: String;
    procedure CheckIfPointExists(Sender: TObject; const PointName: String;
      const aPoint: TKisPoint; var Exists: Boolean);
  end;

function ShowAllotment(Registration: Boolean): Boolean;

implementation

{$R *.DFM}

uses
  ClipBrd, Types,
  uGC,
  Allotments,
  AllotmentOwner, AProc6, Decree, ReNum, Geodesy, Decrees,
  PrintSel, AllotmentPrintEdit, AGraph6, PrintOtvod, StrUtils,
  AGrids6, KavUtils,
  uKisMainView, uKisClasses, uKisConsts, uKisSQLClasses, uCK36,
  uKisIntf, uKisExceptions, uKisPastePointsOptionsDialog;

resourcestring
  SQ_SELECT_POST_NAME_FROM_PEOPLE = 'SELECT POST, INITIAL_NAME FROM PEOPLE WHERE ID=%d';
  SQ_LOT_POINT_COUNT = 'SELECT COUNT(*) FROM ALLOTMENT_POINTS WHERE ALLOTMENTS_ID=%d';

var
  Reg, CheckError: Boolean;

procedure SetDataControlsReadOnly(Control: TWinControl);
var
  I: Integer;
begin
  with Control do
    for I:=0 to ControlCount-1 do
      if Controls[I] is TDBGrid then
        TDBGrid(Controls[I]).ReadOnly:=True
      else if Controls[I] is TDBEdit then
        TDBEdit(Controls[I]).ReadOnly:=True
      else if Controls[I] is TDBMemo then
        TDBMemo(Controls[I]).ReadOnly:=True
      else if Controls[I] is TDBListBox then
        TDBListBox(Controls[I]).ReadOnly:=True
      else if Controls[I] is TDBComboBox then
        TDBComboBox(Controls[I]).ReadOnly:=True
      else if Controls[I] is TDBCheckBox then
        TDBCheckBox(Controls[I]).ReadOnly:=True
      else if Controls[I] is TDBRadioGroup then
        TDBRadioGroup(Controls[I]).ReadOnly:=True
      else if Controls[I] is TDBLookupListBox then
        TDBLookupListBox(Controls[I]).ReadOnly:=True
      else if Controls[I] is TDBLookupComboBox then
        TDBLookupComboBox(Controls[I]).ReadOnly:=True
      else if Controls[I] is TDBRichEdit then
        TDBRichEdit(Controls[I]).ReadOnly:=True
      else if Controls[I] is TWinControl then
        SetDataControlsReadOnly(TWinControl(Controls[I]));
end;

function ShowAllotment(Registration: Boolean): Boolean;
var
  AllotmentForm: TAllotmentForm;
  i: Integer;
  b: Boolean;
begin
  AllotmentForm := TAllotmentForm.Create(Application);
  AllotmentForm.InitIBX;
  reg := Registration;
  with AllotmentForm do
  try
    FMainQuery := TIBQuery(dbeDocDate.DataSource.DataSet);
    i := FMainQuery.FieldByName(SF_ID).AsInteger;
    AllotmentsId := i;
    PageControl.ActivePage := tshData;
    //устанавливаем доступ
    if AppModule.User.IsAdministrator then
    begin
      if Registration then
      begin
        ReadOnly := False;
      end
      else
      begin
        ReadOnly := dbchChecked.Checked;
        if ReadOnly then
        begin
          SetDataControlsReadonly(AllotmentForm);
          dbchChecked.ReadOnly := False;
        end;
      end;
    end
    else
    begin
      ReadOnly := not Registration;
      dbeParentNumber.ReadOnly := True;
      dbeChildNumber.ReadOnly := True;
      dbeNewNumber.ReadOnly := True;
      dbeAnnulDate.ReadOnly := True;
      if not Registration or
        (AppModule.User.UserName <> FMainQuery.FieldByName(SF_INSERT_NAME).AsString)
      then
      begin
        ReadOnly := True;
        dbeDocDate.ReadOnly := ReadOnly;
        SetDataControlsReadonly(AllotmentForm);
        btnCancel.Visible := False;
        actNew.Enabled := False;
        actDel.Enabled := False;
        actEdit.Enabled := False;
        btnPointCopy.Enabled := False;
        btnWriteArea.Enabled := False;
        ibqOwners.UpdateObject := nil;
        ibqDocs.UpdateObject := nil;
      end;
      if Registration and (AppModule.User.RoleName = S_ROLE_GEOSERVICE) then
      begin
        btnChecked.Visible := True;
        dbeDocNumber.ReadOnly := False;
        dbeDocDate.ReadOnly := True;
        dbeParentNumber.ReadOnly := False;
        dbeChildNumber.ReadOnly := False;
        dbeNewNumber.ReadOnly := False;
        dbeAnnulDate.ReadOnly := False;
      end;
      if AppModule.User.RoleName = S_ROLE_GEOSERVICE_CONTR then
      begin
        btnChecked.Visible := True;
        dbchChecked.ReadOnly := False;
        dbeDocNumber.ReadOnly := False;
        dbeDocDate.ReadOnly := True;
        if Registration then
        begin
          dbeParentNumber.ReadOnly := False;
          dbeChildNumber.ReadOnly := False;
          dbeNewNumber.ReadOnly := False;
          dbeAnnulDate.ReadOnly := False;
        end;
      end;
    end;
    b := (AppModule.User.RoleID = ID_ROLE_PDT_TOPO) or AppModule.User.IsAdministrator;
    dbedAccomplishmentArea.Visible := b;
    dbedTempBuildingArea.Visible := b;
    Label26.Visible := b;
    Label27.Visible := b;

    ibqPropForms.Open;
    ibqPropForms.FetchAll;
    ibqOwners.ParamByName(SF_ALLOTMENTS_ID).Value := AllotmentsId;
    ibqOwners.Open;
    ibqDocs.ParamByName(SF_ALLOTMENTS_ID).Value := AllotmentsId;
    ibqDocs.Open;
    SetOwnersControls;
    SetDecreesControls;
    LoadContours;
    if FContours.Count = 0 then
      AddEmptyContour;
    ShowContours(0);
    AppModule.ReadGridProperties(AllotmentForm, dbgOwners);
    AppModule.ReadGridProperties(AllotmentForm, dbgDocs);
    Result := (ShowModal = mrOk);
  finally
    AppModule.WriteGridProperties(AllotmentForm, dbgOwners);
    AppModule.WriteGridProperties(AllotmentForm, dbgDocs);
    Free;
  end;
end;

function CompareContourId(Item1, Item2: Pointer): Integer;
begin
  Result := TContour(Item1).Id - TContour(Item2).Id;
end;

procedure TAllotmentForm.bntOwnerNewClick(Sender: TObject);
var
  P: Double;
begin
  with ibqOwners do begin
    ibsOwnersNextId.Params.ByName(SF_ALLOTMENTS_ID).AsInteger:=AllotmentsId;
    ibsOwnersNextId.ExecQuery;
    ibsOwnersSumPercent.Params.ByName(SF_ALLOTMENTS_ID).AsInteger:=AllotmentsId;
    ibsOwnersSumPercent.ExecQuery;
    try
      Append;
      FieldByName(SF_ALLOTMENTS_ID).AsInteger:=AllotmentsId;
      FieldByName(SF_ID).AsInteger:=ibsOwnersNextId.FieldByName(SF_MAX_ID).AsInteger+1;
      P := 100 - ibsOwnersSumPercent.FieldByName(SF_SUM_PERCENT).AsFloat;
      if P < N_ZERO then
        P := N_ZERO
      else
        if P > 100 then
          P := 100;
      FieldByName(SF_PERCENT).AsFloat := P;
    finally
      ibsOwnersNextId.Close;
      ibsOwnersSumPercent.Close;
    end;
  end;
  ShowOwner;
  SetOwnersControls;
end;

procedure TAllotmentForm.btnOwnerEditClick(Sender: TObject);
begin
  if not btnOwnerEdit.Enabled then Exit;
  ShowOwner(ReadOnly);
end;

procedure TAllotmentForm.btnOwnerDelClick(Sender: TObject);
begin
  if MessageBox(Handle,
                PChar(S_CONFIRM_DELETE_OWNER),
                PChar(S_CONFIRM),
                MB_ICONQUESTION + MB_OKCANCEL) = IDOK
  then
    ibqOwners.Delete;
  SetOwnersControls;
end;

procedure TAllotmentForm.SetOwnersControls;
begin
  bntOwnerNew.Enabled := not ReadOnly;
  btnOwnerDel.Enabled := not ReadOnly and not ibqOwners.IsEmpty;
  btnOwnerEdit.Enabled := not (ibqOwners.IsEmpty);
end;

procedure TAllotmentForm.ShowArea;
var
  I: Integer;
  Cnt: TContour;
  A: Double;
  Li: TListItem;
begin
  fArea := 0;
  if Assigned(FContours) then
    for I := 0 to FContours.Count - 1 do
    begin
      Cnt := FContours[I] as TContour;

      A := Cnt.Area(GetShowCS);
      ///
      ///  edde отключен кусок проверки суммирования площади
      ///
      ///if Cnt.Enabled then
        ///A := Cnt.Area(GetShowCS)
      ///else
        ///A := 0;

      //суммарная площадь += (+А если Cnt.Positive = ДА)(-А если Cnt.Positive = НЕТ) * (1 если контур виден)(0 если контур не виден)
      fArea := fArea + (IfThen(Cnt.Positive, 1, -1) * A) * IfThen(Cnt.Enabled,1,0);
      Li := lvContours.FindData(0, Cnt, True, False);
      if Assigned(Li) then
        Li.SubItems[4] := Format(S_COORD_FORMAT, [A]);
    end;
  edtArea.Text := Format(S_COORD_FORMAT, [fArea]);
end;

procedure TAllotmentForm.ShowContours(Selected: Integer);
var
  I: Integer;
  Cnt: TContour;
  ListItem: TListItem;
begin
  lvContours.Items.BeginUpdate;
  try
    lvContours.Items.Clear;
    I := 0;
    while I < FContours.Count do
    begin
      Cnt := FContours[I] as TContour;
      with lvContours.Items.Add do
      begin
        Caption := IntToSTr(Cnt.Id);
        Data := Cnt;
        ImageIndex := Cnt.Id;
        SubItems.Add(Cnt.Name);
        SubItems.Add(IfThen(Cnt.Enabled, S_YES, S_NO));
        SubItems.Add(IfThen(Cnt.Positive, '+', '-'));
        SubItems.Add(IfThen(Cnt.Closed, '+', '-'));
        SubItems.Add('');
      end;
      Inc(I);
    end;
  finally
    lvContours.Items.EndUpdate;
  end;
  //позиционируем курсор
  ListItem := lvContours.FindCaption(0, IntToStr(Selected), False, False, True);
  if ListItem = nil then
    if lvContours.Items.Count > 0 then
       ListItem := lvContours.Items[0];
  if Assigned(ListItem) then
  begin
    ListItem.Selected := True;
    ListItem.Focused := True;
  end;
  SetItemVisible(ListItem);
end;

procedure TAllotmentForm.ShowPoints(Cnt: TContour; PointId: Integer; Flg: Boolean = false);
var
  ListItem: TListItem;
  I, J: Integer;
  X, Y: Double;
  Cs: TCoordSystem;
begin
  if not Assigned(Cnt) then
    Exit;
  lvPoints.Items.BeginUpdate;
  try
    lvPoints.Items.Clear;
    J := 0;
    //Cs := GetShowCS; //ed
    if Flg then
    begin
      if dbchMSK36.Checked then
        Cs := csMCK36
      else
        Cs := csVrn;
    end
    else
      Cs := GetShowCS;
    for I := 0 to Pred(Cnt.Count) do
    begin
      ListItem := lvPoints.Items.Add;
      with ListItem do
      begin
        ImageIndex := 0;
        Caption := Cnt[I].Name;
        Data := Cnt[I];
        if Cs = csVrn then
        begin
          X := Cnt[I].X;
          Y := Cnt[I].Y;
        end
        else
        begin
          X := Cnt[I].X36;
          Y := Cnt[I].Y36;
        end;
        SubItems.Add(Format(S_COORD_FORMAT,[X]));
        SubItems.Add(Format(S_COORD_FORMAT,[Y]));
        SubItems.Add(Format(S_COORD_FORMAT,[Cnt.GetLength(I, Cs)]));
        SubItems.Add(GetDegreeCorner(Cnt.Azimuth(I, Cs)));
        if Cnt[I].Id = PointId then
          J := I;
      end;
    end;
    //позиционируем курсор
    ListItem := lvPoints.Items[J];
    if ListItem <> nil then
    begin
      ListItem.Selected := True;
      ListItem.Focused := True;
    end;
  finally
    lvPoints.Items.EndUpdate;
  end;
  //делаем scroll, чтобы выделенный пункт стал виден
  SetItemVisible(ListItem);
  //Пишем площади
  ShowArea;
  //Перерисовываем картинку
  PaintBox.Repaint;
end;

procedure TAllotmentForm.SetDecreesControls;
begin
  btnDecreeNew.Enabled:=not ReadOnly;
  btnDecreeDel.Enabled:=not ReadOnly and not ibqDocs.IsEmpty;
  btnDecreeEdit.Enabled:=not ReadOnly and not ibqDocs.IsEmpty;
  btnDecreeDetail.Enabled:=not ibqDocs.IsEmpty;
end;

procedure TAllotmentForm.btnDecreeDetailClick(Sender: TObject);
begin
  ibqDecrees.ParamByName(SF_ID).Value:=ibqDocs.FieldByName(SF_DECREES_ID).Value;
  ibqDecrees.Open;
  try
    ShowDecree(ibqDecrees,True);
  finally
    ibqDecrees.Close;
  end;
end;

procedure TAllotmentForm.btnDecreeDelClick(Sender: TObject);
begin
  if MessageBox(0, PChar(S_CONFIRM_DELETE_ACT), PChar(S_Confirm), MB_ICONQUESTION + MB_OKCANCEL) = IDOK then
    ibqDocs.Delete;
  SetDecreesControls;
end;

procedure TAllotmentForm.btnDecreeNewClick(Sender: TObject);
var
  DecreeId: Integer;
begin
  DecreeId := N_ZERO;
  if SelectDecree(DecreeId) then
    with ibqDocs do
    begin
      ibsDocsNextId.Params.ByName(SF_ALLOTMENTS_ID).AsInteger := AllotmentsId;
      ibsDocsNextId.ExecQuery;
      try
        Append;
        FieldByName(SF_ALLOTMENTS_ID).AsInteger := AllotmentsId;
        FieldByName(SF_ID).AsInteger := Succ(ibsDocsNextId.FieldByName(SF_MAX_ID).AsInteger);
      finally
        ibsDocsNextId.Close;
      end;
      FieldByName(SF_DECREES_ID).Value := DecreeId;
      Post;
    end;
  SetDecreesControls;
end;

procedure TAllotmentForm.btnDecreeEditClick(Sender: TObject);
var
  DecreeId: Integer;
begin
  if not btnDecreeEdit.Enabled then
    Exit;
  with ibqDocs do
  begin
    DecreeId:=FieldByName(SF_DECREES_ID).AsInteger;
    if SelectDecree(DecreeId) then
    begin
      if not(State in [dsEdit, dsInsert]) then
        Edit;
      FieldByName(SF_DECREES_ID).Value:=DecreeId;
      Post;
    end;
  end;
end;

procedure TAllotmentForm.lvPointsDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept:= (Source = lvPoints) and not ReadOnly;
end;

procedure TAllotmentForm.lvContoursDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := (Source = lvPoints) and not ReadOnly;
end;

procedure TAllotmentForm.LoadContourPoints(Cnt: TContour);
var
  Pt: TKisPoint;
begin
  if not Assigned(Cnt) then
    Exit;
  Cnt.Clear;
  ibqPoints.Active := False;
  ibqPoints.ParamByName(SF_ALLOTMENTS_ID).AsInteger := AllotmentsId;
  ibqPoints.ParamByName(SF_CONTOURS_ID).AsInteger := Cnt.Id;
  ibqPoints.Active := True;
  while not ibqPoints.Eof do
  begin
    Pt := TKisPoint.Create(ibqPoints.FieldByName(SF_X).AsFloat,
                           ibqPoints.FieldByName(SF_Y).AsFloat);
    Pt.Id := ibqPoints.FieldByName(SF_ID).AsInteger;
    Pt.Name := ibqPoints.FieldByName(SF_NAME).AsString;
    Cnt.Add(Pt);
    ibqPoints.Next;
  end;
  ibqPoints.Active := False;
end;

procedure TAllotmentForm.LoadContours(Selected: Integer = 0);
var
  Cnt: TContour;
begin
  while ilContours.Count > 1 do
    ilContours.Delete(1);
  with ibqContours do
  begin
    ParamByName(SF_ALLOTMENTS_ID).Value:=AllotmentsId;
    Open;
    FContours.Clear;
    while not Eof do
    begin
      Cnt := TContour.Create;
      Cnt.Name := FieldByName(SF_NAME).AsString;
      Cnt.Id := FieldByName(SF_ID).AsInteger;
      Cnt.Enabled := FieldByName(SF_ENABLED).AsInteger > 0;
      Cnt.Positive := FieldByName(SF_POSITIVE).AsInteger > 0;
      Cnt.Closed := FieldByName(SF_CLOSED).AsInteger > 0;
      Cnt.Color := FieldByName(SF_COLOR).AsInteger;
      FContours.Add(Cnt);
      LoadContourPoints(Cnt);
      //
      PrepareContourIcon(Cnt);
      //
      Next;
    end;
    ibqContours.Close;
  end;
  ///
  ShowContours(Selected);
end;

procedure TAllotmentForm.ContourInsert(Contour: TContour);
//var
//  Txt: string;
begin
  with ibsContoursNew do
  begin
    Params.ByName(SF_ALLOTMENTS_ID).Value := AllotmentsId;
    Params.ByName(SF_ID).Value := Contour.Id;
    Params.ByName(SF_ENABLED).Value := Contour.Enabled;
    Params.ByName(SF_POSITIVE).Value := Contour.Positive;
    Params.ByName(SF_NAME).Value := Contour.Name;
    Params.ByName(SF_CLOSED).Value := Contour.Closed;
//      Txt := 'Params:' + #13#10 +
//         SF_ALLOTMENTS_ID + '=' + Params.ByName(SF_ALLOTMENTS_ID).AsString + #13#10 +
//         SF_ID + '=' + Params.ByName(SF_ID).AsString + #13#10 +
//         SF_ENABLED + '=' + Params.ByName(SF_ENABLED).AsString + #13#10 +
//         SF_POSITIVE + '=' + Params.ByName(SF_POSITIVE).AsString;
//
//      MessageBox(0, PChar(Txt), 'Data', MB_OK);
    ExecQuery;
 end;
  FContours.Add(Contour);
  FContours.Sort(CompareContourId);
end;

procedure TAllotmentForm.ContourNew;
var
  Cnt: TContour;
begin
  Cnt := TContour.Create;
  if FContours.Count > 0 then
    Cnt.Id := (FContours.Last as TContour).Id + 1
  else
    Cnt.Id := 1;
  Cnt.Enabled := True;
  Cnt.Positive := True;
  if TContourForm.EditContourParams(Cnt, FContours.Count + 1) then
  begin
    try
      ContourInsert(Cnt);
      PrepareContourIcon(Cnt);
      ShowContours(Cnt.Id);
    except
      FContours.Remove(Cnt);
      raise;
    end;
  end
  else
    FreeAndNil(Cnt);
end;

procedure TAllotmentForm.ContourEdit;
var
  Contour: TContour;
  OldId: Integer;
begin
  if lvContours.Selected = nil then
    Exit;
  Contour := lvContours.Selected.Data;

  OldId := Contour.Id;
  if TContourForm.EditContourParams(Contour, FContours.Count) then
    with ibsContoursUpdate do
    begin
      Params.ByName(SF_ALLOTMENTS_ID).Value := AllotmentsId;
      Params.ByName(SF_OLD_ID).Value := OldId;
      Params.ByName(SF_ID).Value := Contour.Id;
      Params.ByName(SF_ENABLED).Value := Contour.Enabled;
      Params.ByName(SF_POSITIVE).Value := Contour.Positive;
      Params.ByName(SF_NAME).Value := Contour.Name;
      Params.ByName(SF_CLOSED).Value := Contour.Closed;
      Params.ByName(SF_COLOR).Value := Contour.Color;
      ExecQuery;
      LoadContours(Contour.Id);
    end;
end;

procedure TAllotmentForm.CheckIfPointExists(Sender: TObject;
  const PointName: String; const aPoint: TKisPoint; var Exists: Boolean);
var
  Cnt: TContour;
  I: Integer;
begin
  Exists := False;
  Cnt := GetActiveContour(False);
  if Assigned(Cnt) then
    for I := 0 to Cnt.Count - 1 do
    begin
      if Cnt[I] <> aPoint then
        if Cnt[I].Name = PointName then
        begin
          Exists := True;
          Exit;
        end;
    end;
end;

procedure TAllotmentForm.ContourDel;
var
  I, Id: Integer;
  Cnt: TContour;
begin
  Cnt := GetActiveContour(True);
  if Assigned(Cnt)
     and
     (MessageBox(0, PChar(S_CONFIRM_DELETE_CONTOUR), PChar(S_Confirm),
                 MB_ICONQUESTION + MB_OKCANCEL) = IDOK)
  then
  begin
    if FContours.Count = 1 then
    begin
      I := FContours.IndexOf(Cnt);
      if I = Pred(FContours.Count) then //если удалили не последний
        Dec(I)
      else
        Inc(I);
      Id := FContours[I].Id;
    end
    else
      Id := 0;
    //
    with ibsContoursDel do
    begin
      Params.ByName(SF_ALLOTMENTS_ID).Value := AllotmentsId;
      Params.ByName(SF_ID).Value := lvContours.Selected.Caption;
      ExecQuery;
    end;
    //
    LoadContours(Id);
  end;
end;

procedure TAllotmentForm.PointNamePlus;
var
  Delta, I: Integer;
  Cnt: TContour;
  Pt: TKisPoint;
  S : String;
  PtNameList: TStringList; //тут будет список с именами точек для проверки на дублирование
begin
  if ReadOnly then
    Exit;
  Cnt := GetActiveContour(True);
  if not Assigned(lvPoints.Selected) then
    raise Exception.Create(S_NO_SELECTED_POINTS);
  if ShowRenum(Delta) then
  begin
   // Cnt1:= Cnt; //копируем контур для отката
    PtNameList := TStringList.Create; //список с именами точек
    PtNameList.Sorted := True;
    PtNameList.Duplicates := dupError; //чтоб отловить одинаковые имена
    for I := 0 to lvPoints.Items.Count - 1 do //пробегаем по точкам контура
      begin
        Pt := lvPoints.Items[I].Data; //берем точку по указателю
        S := Pt.Name; //копируем ее имя
        if lvPoints.Items[I].Selected then  //если точка выбрана
          Pt.Name := IncPointName(Pt.Name, Delta);// переименовываем
      try
        PtNameList.Add(Pt.Name);
      except
        ShowMessage('Точка с именем ' + Pt.Name + ' уже есть');
        Pt.Name := S;
        Break;
      end;
    end; // for I
    DBSaveContour(Cnt);
    ShowPoints(Cnt, TKisPoint(lvPoints.Selected.Data).Id);
  end;
end;

procedure TAllotmentForm.PointNew;
var
  Point, NewPt: TKisPoint;
  Contour: TContour;
begin
  Contour := GetActiveContour(True);
  NewPt := TKisPoint.Create(0, 0);
  if lvPoints.Items.Count > 0 then
  begin
    Point := lvPoints.Items[Pred(lvPoints.Items.Count)].Data;
    NewPt.Name := IntToStr(Point.Id + 1);
    NewPt.Id := Point.Id + 1;
  end
  else
  begin
    NewPt.Id := 1;
//    NewPt.Name := '1';
  end;
  ///
  if TPointForm.ShowPoint(NewPt, GetShowCS, CheckIfPointExists) then
  begin
    DBSavePoint(NewPt, Contour, False);
    Contour.Add(NewPt);
    Contour.CalcPointIds;
    ShowPoints(Contour, NewPt.Id);
  end
  else
    FreeAndNil(NewPt);
end;       

procedure TAllotmentForm.PointInsert;
var
  NewPt, Pt: TKisPoint;
  Cnt: TContour;
  J: Integer;
  NewPointCs: TCoordSystem;
begin
  Cnt := GetActiveContour(True);
  NewPt := TKisPoint.Create(0, 0); //создаем новую точку с 0 в старой и автопересчетом в новой
  Cnt.Add(NewPt);
  //берем .Id точки как 0 (а вдруг это первая точка в списке)
  NewPt.Id := 0;
  //а переберем-ка список точек и поищем в нем максимальный .Id
  for J := 0 to Pred(lvPoints.Items.Count) do
  begin //и если такие есть методом прямой выборки отлавливаем таковой
    Pt := lvPoints.Items[J].Data; //тоесть берем точку по ссылке
    if NewPt.Id < Pt.Id then //если его .Id больше нашего
      NewPt.Id := Pt.Id; // забираем себе
  end;
  // если нашли то имеем максимальный и притом такой же
  //а не нашли - тот же ноль, но полюбому плохо
  NewPt.Id := NewPt.Id + 1; //увеличим его на идиницу и возрадуемся
  //а именем точки возьмем тот же ID
  NewPt.Name := IntToStr(NewPt.Id);

{  if lvPoints.Selected <> nil then
  begin
    ///  ed "наследование" имени от предыдужей точки
    //отдаем функции имя точки под курсором, и ее приращение
    ////NewPt.Name:= IncPointName(Point.Name, 1);
    //проверяем, нет ли точки с таким именем
    for J := 0 to Pred(lvPoints.Items.Count) do
      begin
      Pt := lvPoints.Items[J].Data; //берем точку по указателю
      if NewPt.Name = Pt.Name then //если наше имя  совпадает
        begin
        //Информируем
        ShowMessage('Точка с названием ' + NewPt.Name + ' уже есть!');
        Exit; //выскакиваем из процесса создания точки
        end;
      end;//for J
    ///
  end
  else
  begin
    Cnt.Add(NewPt);
    NewPt.Id := 1;
    NewPt.Name := '1';
  end;
  ///  ed }

  if dbchMSK36.Checked then
    NewPointCs := csMCK36
  else
    NewPointCs := csVrn;
  ///
  if TPointForm.ShowPoint(NewPt, NewPointCs, CheckIfPointExists) then
  begin
    Cnt.CalcPointIds;
    ShowPoints(Cnt, NewPt.Id, true);
    DBSaveContour(Cnt);
  end
  else
  begin
    Cnt.Remove(NewPt);
  end;
end;

procedure TAllotmentForm.PointEdit;
var
  Point: TKisPoint;
  Contour: TContour;
begin
  if lvPoints.Selected = nil then
    Exit;
  Contour := GetActiveContour(True);
  Point := lvPoints.Selected.Data;
  if TPointForm.ShowPoint(Point, GetShowCS, CheckIfPointExists) then
  begin
    DBSavePoint(Point, Contour, True);
    ShowPoints(Contour, Point.Id);
  end;
end;

procedure TAllotmentForm.PointCopy;
var
  Cnt: TContour;
  I, J, N, NewId: Integer;
  S: String;
  Exists: Boolean;
begin
  if ReadOnly then
    Exit;
  if Assigned(lvPoints.Selected) then
  begin
    Cnt := GetActiveContour(True);
    I := Cnt.IndexOf(lvPoints.Selected.Data);
    if I < 0 then
      Exit;
    NewId := TKisPoint(Cnt.Last).Id + 1;
    J := Cnt.AddPoint(Cnt[I].X, Cnt[I].Y);
    Cnt[J].Id := NewId;
    N := Cnt[J].Id;
    Exists := True;
    while Exists do
    begin
      S := IntToStr(N);
      CheckIfPointExists(nil, S, Cnt[J], Exists);
      if Exists then
        Inc(N);
    end;
    Cnt[J].Name := IntToStr(N);
    DBSavePoint(Cnt[J], Cnt, False);
    ShowPoints(Cnt, 0);
  end;
end;

procedure TAllotmentForm.PointDel;
var
  Contour: TContour;
  I, J: Integer;
begin
  Contour := GetActiveContour(True);
  if Assigned(lvPoints.Selected) then
  if MessageBox(0, PChar(S_CONFIRM_DELETE_POINTS), PChar(S_CONFIRM), MB_ICONQUESTION + MB_OKCANCEL) = IDOK then
  begin
    J := 0;
    for I := lvPoints.Selected.Index to Pred(lvPoints.Items.Count) do
      if lvPoints.Items[I].Selected then
      begin
        DBDeletePoint(lvPoints.Items[I].Data, Contour);
        Contour.Remove(lvPoints.Items[I].Data);
        J := I;
      end;
    if J = Pred(lvPoints.Items.Count) then //если удалили не последний
      J := lvPoints.Selected.Index - 1;
    ShowPoints(Contour, J);
  end;
end;

procedure TAllotmentForm.actNewExecute(Sender: TObject);
begin
  if ReadOnly then
    Exit;
  if ActiveControl = lvContours then
    ContourNew
  else
  if ActiveControl = lvPoints then
    PointInsert
  else
    MessageBox(Handle,PChar(S_INSERT_CHOICE),PChar(S_WARN), MB_ICONINFORMATION);
end;

procedure TAllotmentForm.AddEmptyContour;
var
  Cnt: TContour;
begin
  Cnt := TContour.Create;
  Cnt.Id := 1;
  Cnt.Enabled := True;
  Cnt.Positive := True;
  ContourInsert(Cnt);
end;

procedure TAllotmentForm.actDelExecute(Sender: TObject);
begin
  if ReadOnly then
    Exit;
  if ActiveControl=lvContours then
    ContourDel
  else
  if ActiveControl=lvPoints then
    PointDel;
  PaintBox.Invalidate;
end;

procedure TAllotmentForm.actEditExecute(Sender: TObject);
begin
  if ReadOnly then
    Exit;
  if ActiveControl = lvContours then
    ContourEdit
  else
  if ActiveControl = lvPoints then
    PointEdit;
end;

procedure TAllotmentForm.lvPointsEditing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
  AllowEdit := False;
end;

procedure TAllotmentForm.lvContoursEditing(Sender: TObject; Item: TListItem; var AllowEdit: Boolean);
begin
  AllowEdit := False;
end;

function TAllotmentForm.GetActiveContour(const DoRaise: Boolean): TContour;
var
  L: TListItem;
begin
  L := lvContours.Selected;
  if Assigned(L) then
    Result := L.Data
  else
    if DoRaise then
      raise Exception.Create(S_NO_SELECTED_CONTOURS)
    else
      Result := nil;
end;

procedure TAllotmentForm.lvContoursSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  if Selected then
    ShowPoints(lvContours.Selected.Data, 0);
end;

procedure TAllotmentForm.lvPointsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  with lvPoints.Items do
    if (not ReadOnly) and (Key = VK_DOWN)
       and (Shift = []) and ((Count = 0) or Item[Pred(Count)].Focused)
    then
      PointNew;
end;

procedure TAllotmentForm.lvPointsDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  I, J: Integer;
  Last, Pt: TKisPoint;
  Cnt: TContour;
begin
  for I := lvPoints.Selected.Index to lvPoints.Items.Count-1 do
    if lvPoints.Items[I].Selected and (lvPoints.Items[I]=lvPoints.DropTarget) then
      Exit;
  ///
  Cnt := GetActiveContour(True);
  //сдвигаем "хвост"
  if Assigned(lvPoints.DropTarget) then
    Last := lvPoints.DropTarget.Data
  else
    Last := nil;
  for I := 0 to lvPoints.Items.Count - 1 do
    if lvPoints.Items[I].Selected  then
    begin
      Pt := lvPoints.Items[I].Data;
      Cnt.Extract(Pt);
      J := Cnt.IndexOf(Last);
      if J >= 0 then
        Inc(J)
      else
        J := 0;
      Cnt.Insert(J, Pt);
      Last := Pt;
    end;
  ///
  Cnt.CalcPointIds;
  ///
  ///
  DBSaveContour(Cnt);
  ShowPoints(Cnt, TKisPoint(lvPoints.Selected.Data).Id);
end;

procedure TAllotmentForm.lvContoursDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  I, J, K: Integer;
  Cnt, NewCnt: TContour;
  NewPt, Pt: TKisPoint;
begin
  if lvContours.DropTarget = lvContours.Selected then
    Exit;
  NewCnt := lvContours.DropTarget.Data;
  //определяем последний ID в новом контуре
  J := TKisPoint(FContours.Last).Id;
  //переносим точки в новый контур
  Cnt := GetActiveContour(True);
  for I := lvPoints.Selected.Index to lvPoints.Items.Count-1 do
    if lvPoints.Items[I].Selected then
    begin
      Inc(J);
      Pt := lvPoints.Items[I].Data;
      NewPt := TKisPoint.Create(Pt.X, Pt.Y);
      NewPt.Name := Pt.Name;
      if TryStrToInt(NewPt.Name, K) then
        NewPt.Name := IntToStr(J);
      NewPt.Id := J;
      NewCnt.Add(NewPt);
      Cnt.Remove(Pt);
    end;
  DBSaveContour(NewCnt);
  DBSaveContour(Cnt);
  ShowPoints(Cnt, 0);
end;

procedure TAllotmentForm.btnCheckedClick(Sender: TObject);
var
  S: Double;
begin
  if ibqOwners.IsEmpty then
    raise Exception.Create(S_OWNERS_MISSED);
  with ibsOwnersSumPercent do
  begin
    Params.ByName(SF_ALLOTMENTS_ID).AsInteger:=AllotmentsId;
    ExecQuery;
    try
      S:=FieldByName(SF_SUM_PERCENT).AsFloat;
    finally
      Close;
    end;
  end;
  ///
  if S <> 100 then
    raise Exception.Create(S_BAD_AREA_SUMM);
  ///
  if ibqDocs.IsEmpty then
    raise Exception.Create(S_DOCS_MISSED);
  ///
  if fArea <= 0 then
    raise Exception.Create(S_BAD_AREA_POINTS);
  ///
  if dbchErrorCoord.Checked then
    raise Exception.Create(S_ERROR_MODE_ON);
  if MessageBox(0, PChar(S_DO_YOU_SURE + #13 + S_SET_LOT_READONLY),
    PChar(S_Confirm), MB_ICONQUESTION + MB_OKCANCEL) = IDOK
  then
  begin
    FMainQuery.SoftEdit();
    FMainQuery.FieldByName(SF_CHECKED).Value := 1;
    btnChecked.Visible := False;
  end;
end;

procedure TAllotmentForm.btnOkClick(Sender: TObject);
begin
  if Empty(FMainQuery.FieldByName(SF_ADDRESS).AsString) then
  begin
    PageControl.ActivePageIndex := 0;
    dbeAddress.SetFocus;
    MessageBox(Handle, PChar(S_ADDRESS_MISSED), PChar(S_WARN), MB_OK + MB_ICONWARNING);
    Exit;
  end;
  if Empty(FMainQuery.FieldByName(SF_EXECUTOR).AsString) then
  begin
    PageControl.ActivePageIndex := 0;
    dbeExecutor.SetFocus;
    MessageBox(Handle, PChar(S_EXECUTOR_MISSED), PChar(S_WARN), MB_OK + MB_ICONWARNING);
    Exit;
  end;
  //ed в целях отладки ОутОфМемори 
  {if Empty(MainQuery.FieldByName(SF_NOMENCLATURA).AsString) then
  begin
    CalcNomenclature;      //вычисление номенклатуры планшетов по отводу (отводам???)
    if Empty(MainQuery.FieldByName(SF_NOMENCLATURA).AsString) then
    begin
      PageControl.ActivePageIndex := 3;
      dbeNomenclatura.SetFocus;
      MessageBox(Handle, PChar(S_NOMENCLATURA_MISSED), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      Exit;
    end;
  end;}
  if Empty(FMainQuery.FieldByName(SF_REGIONS_ID).AsString) then
  begin
    PageControl.ActivePageIndex := 0;
    dbcbRegion.SetFocus;
    MessageBox(Handle, PChar(S_REGIONS_NAME_MISSED), PChar(S_WARN), MB_OK + MB_ICONWARNING);
    Exit;
  end;
  FMainQuery.SoftPost();
  ModalResult := mrOk;
end;

procedure JumpToURL(const url: string);
begin
  ShellExecute(Application.Handle, nil, PChar(url), nil, nil, SW_SHOW);
end;

procedure TAllotmentForm.btnOpenLinkConsultantClick(Sender: TObject);
begin
  if Trim(dbeConsultant.Text) <> '' then
    JumpToURL(dbeConsultant.Text);
end;

procedure TAllotmentForm.btnWriteAreaClick(Sender: TObject);
begin
  if ReadOnly then
    Exit;
  FMainQuery.SoftEdit();
  FMainQuery.FieldByName(SF_AREA).AsFloat := Round(fArea);
end;

procedure TAllotmentForm.PaintBoxPaint(Sender: TObject);
var
  DrawRect: TRect;
begin
  DrawRect := Rect(5, 5, PaintBox.Width - 5, PaintBox.Height - 5);
  PrintRegion(FContours, PaintBox.Canvas, DrawRect, ScrPixPerMM, False);
end;

procedure TAllotmentForm.DBSaveContour(Cnt: TContour);
var
  I: Integer;
begin
  ibsContoursDel.ParamByName(SF_ALLOTMENTS_ID).AsInteger := AllotmentsId;
  ibsContoursDel.ParamByName(SF_ID).AsInteger := Cnt.Id;
  ibsContoursDel.ExecQuery;
  ///
  ibsContoursNew.ParamByName(SF_ALLOTMENTS_ID).AsInteger := AllotmentsId;
  ibsContoursNew.ParamByName(SF_ID).AsInteger := Cnt.Id;
  ibsContoursNew.ParamByName(SF_ENABLED).Value := Cnt.Enabled;
  ibsContoursNew.ParamByName(SF_POSITIVE).Value := Cnt.Positive;
  ibsContoursNew.Params.ByName(SF_NAME).Value := Cnt.Name;
  ibsContoursNew.Params.ByName(SF_CLOSED).Value := Cnt.Closed;
  ibsContoursNew.ExecQuery;
  ///
  for I := 0 to Cnt.Count - 1 do
    DBSavePoint(Cnt[I], Cnt, False);
end;

procedure TAllotmentForm.DBSavePoint(Pt: TKisPoint; Cnt: TContour; Update: Boolean);
begin
  if Update then
    with ibsPointsUpdate do
    begin
      Params.ByName(SF_ALLOTMENTS_ID).Value := AllotmentsId;
      Params.ByName(SF_CONTOURS_ID).Value := Cnt.Id;
      Params.ByName(SF_ID).Value := Pt.Id;
      Params.ByName(SF_NAME).Value := Pt.Name;
      Params.ByName(SF_X).Value := Pt.X;
      Params.ByName(SF_Y).Value := Pt.Y;
      ExecQuery;
    end
  else
    with ibsPointsNew do
    begin
      Params.ByName(SF_ALLOTMENTS_ID).Value := AllotmentsId;
      Params.ByName(SF_CONTOURS_ID).Value := Cnt.Id;
      Params.ByName(SF_ID).Value := Pt.Id;
      Params.ByName(SF_NAME).Value := Pt.Name;
      Params.ByName(SF_X).Value := Pt.X;
      Params.ByName(SF_Y).Value := Pt.Y;
      ExecQuery;
    end;
end;

procedure TAllotmentForm.SelectItem(ListItem: TListItem);
var
  I: Integer;
begin
  if ListItem <> nil then
  with ListItem do
  begin
    for I := 0 to TListView(ListView).Items.Count - 1 do
      TListView(ListView).Items[I].Selected := False;
    Selected := True;
    Focused := True;
    SetItemVisible(ListItem);
  end;
end;

procedure TAllotmentForm.PaintBoxMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  I,L,MinL: Integer;
  ListItem: TListItem;
  Cnt, TmpCnt: TContour;
  Pt1: TKisPoint;
  J: Integer;
begin
  Pt1 := nil;
  MinL := Trunc(Sqr(PaintBox.Height) + Sqr(PaintBox.Width));
  //Пробегаем точки дважды. Первый раз смотрим только текущий контур, тогда,
  //если две точки из раных контуров совпадают, то будет показана точка из
  //текущего контура, а не из первого из двух
  Cnt := GetActiveContour(True);
  if Assigned(Cnt) then
    for I := 0 to Pred(Cnt.Count) do
    begin
      L := Trunc(Sqr(X - Cnt[I].ScreenPt.X) + Sqr(Y - Cnt[I].ScreenPt.Y));
      if L < MinL then
      begin
        MinL := L;
        Pt1 := Cnt[I];
      end;
    end;
  ///
  for I := 0 to Pred(FContours.Count) do
  begin
    TmpCnt := FContours[I] as TContour;
    for J := 0 to TmpCnt.Count - 1 do
    begin
      L := Trunc(Sqr(X - TmpCnt[J].ScreenPt.X) + Sqr(Y - TmpCnt[J].ScreenPt.Y));
      if L < MinL then
      begin
        MinL := L;
        Cnt := TmpCnt;
        Pt1 := TmpCnt[J];
      end;
    end;
  end;
  ///
  if Assigned(Cnt) then
  begin
    ListItem := lvContours.FindData(0, Cnt, True, False);
    SelectItem(ListItem);
    if Assigned(Pt1) then
    begin
      ListItem := lvPoints.FindData(0, Pt1, True, False);
      SelectItem(ListItem);
    end;
  end;
end;

procedure TAllotmentForm.SetItemVisible(ListItem: TListItem; BottomIndent: Integer = 20);
var
  NewY: Integer;
begin
  if Assigned(ListItem) then
  begin
    NewY := ListItem.ListView.Height - BottomIndent;
    while NewY > (ListItem.ListView.ClientHeight - BottomIndent)  do
      NewY := NewY - BottomIndent;
    if ListItem.Position.Y > NewY then
      ListItem.ListView.Scroll(0,-NewY+ListItem.Position.Y);
  end;
end;

procedure TAllotmentForm.btnPrintClick(Sender: TObject);
var
  ReportIndex: Integer;
  AllOwners: Boolean;
begin
  try
    //если UpdateObject=nil, то Refresh вызывает ошибку
    if Assigned(FMainQuery.UpdateObject) then
      FMainQuery.Refresh;
    if Assigned(ibqOwners.UpdateObject) then
      ibqOwners.Refresh;
  except
    if ExceptObject is Exception then
      AppModule.LogException(Exception(ExceptObject), GetDebugInfo);
  end;
  ReportIndex := 0;
  AllOwners := False;
  if ShowPrintSel(ReportIndex, AllOwners) then
     PrintAllotment(ReportIndex, AllOwners);
end;

function TAllotmentForm.GetDocs: string;
var
  TypeId: Integer;
begin
  with ibsDocs do
  begin
    Params.ByName(SF_ALLOTMENTS_ID).AsInteger := AllotmentsId;
    ExecQuery;
    TypeId := -1;
    try
      while not Eof do
      begin
        if TypeId <> FieldByName(SF_DECREE_TYPES_ID).AsInteger then
        begin
          TypeId := FieldByName(SF_DECREE_TYPES_ID).AsInteger;
          if Result <> '' then Result := Result + ', ';
          Result := Result + FieldByName(SF_DECREE_TYPES_NAME).AsString + ' ';
        end
        else
          Result := Result + ', ';
          Result := Result + '№' + FieldByName(SF_DOC_NUMBER).AsString + ' от '
                  + FieldByName(SF_DOC_DATE).AsString;
        Next;
      end;
    finally
      Close;
    end;
  end;
  if Result <> '' then
    Result := Result + ', ';
  Result := Result + FMainQuery.FieldByName('DOCUMENTS').AsString;
end;

procedure TAllotmentForm.PrintAllotment(ReportIndex: Integer; AllOwners: Boolean);
var
  AReportPath: String;
  KindOfReport: String;

  function GetDocNames: String;
  var
    bkm: TBookmark;
  begin
    Result := '';
    bkm := ibqDocs.GetBookmark;
    ibqDocs.DisableControls;
    try
      ibqDocs.First;
      while not ibqDocs.Eof do
      begin
        if Result <> '' then
          Result := Result + ', ';
        Result := Result + ibqDocs.FieldByName(SF_DECREE_TYPES_NAME).AsString + ' №' +
          ibqDocs.FieldByName(SF_DOC_NUMBER).AsString + ' oт ' +
          ibqDocs.FieldByName(SF_DOC_DATE).AsString;
        ibqDocs.Next;
      end;
    finally
      ibqDocs.GotoBookmark(bkm);
      ibqDocs.FreeBookmark(bkm);
      ibqDocs.EnableControls;
    end;
  end;

  procedure PrintFReport(const FileName: String);
  begin
    if not FileExists(FileName) then
      raise Exception.Create(S_FILE + S_NOT_FOUND + #13 + FileName);

    if Pos('Акт_отвода_1_стр.frf', FileName) <> 0 then
      PrintFROtvodRoman1(FileName, AllOwners)
    else
    if Pos('Техзадание2.frf', Filename) <> 0 then
      PrintFRTech(FileName, AllOwners)
    else  
      PrintFROther(FileName, AllOwners);
  end;

  procedure PrintAReport(const FileName: String);
  var
    Params: TStrings;
    Info: String;
    Cs: TCoordSystem;
  begin
    if TContour(FContours[0]).Count = 0 then
    begin
      MessageBox(Handle, PChar(S_BAD_AREA_POINTS), PChar(S_WARN), MB_ICONWARNING);
      Exit;
    end;

    Params := TStringList.Create;
    Params.Forget();
    Params.Clear;
    Params.Values['Адрес'] := FMainQuery.FieldByName(SF_ADDRESS).AsString;
    Params.Values['Площадь'] := FMainQuery.FieldByName(SF_AREA).AsString + S_M2;
    Params.Values['Площадь благоустройства'] := FMainQuery.FieldByName(SF_ACCOMPLISHMENT_AREA).AsString + S_M2;
    Params.Values['Площадь временного сооружения'] := FMainQuery.FieldByName(SF_TEMP_BUILDING_AREA).AsString + S_M2;
    Params.Values['Постановления'] := GetDocs;
    Params.Values['Текущая дата'] := DateToStr(SysUtils.Date);
    Params.Values['Номер отвода'] := FMainQuery.FieldByName(SF_DOC_NUMBER).AsString;
    Params.Values['Дата отвода'] := FMainQuery.FieldByName(SF_DOC_DATE).AsString;
    Params.Values['Исполнители'] := FMainQuery.FieldByName(SF_EXECUTOR).AsString + #32 +
                                    FMainQuery.FieldByName(SF_DECREE_PREPARED).AsString;
    Params.Values['Владелец'] := GetFullFirmName(False, AllOwners);
    Params.Values['Форма собственности'] := ibqOwners.FieldByName(SF_PROP_FORMS_NAME).AsString;
    Params.Values['Срок аренды'] := ibqOwners.FieldByName(SF_RENT_PERIOD).AsString;
    Params.Values['Целевое использование'] := ibqOwners.FieldByName(SF_PURPOSE).AsString;
    Params.Values['Геодезист'] := FMainQuery.FieldByName(SF_EXECUTOR).AsString;
    Params.Values['Постановление подготовил'] := FMainQuery.FieldByName(SF_DECREE_PREPARED).AsString;
    Info := FMainQuery.FieldByName(SF_INFORMATION).AsString;
    Params.Values['Информация'] := Info;
    Params.Values['Смежества'] := FMainQuery.FieldByName(SF_NEIGHBOURS).AsString;
    Params.Values['Номенклатура'] := FMainQuery.FieldByName(SF_NOMENCLATURA).AsString;
    Params.Values['ПЗ'] := FMainQuery.FieldByName(SF_PZ).AsString;

    if FMainQuery.FieldByName(SF_CADASTRE).AsString = '' then
      Params.Values['Кадастр'] := 'отсутствует'
    else
      Params.Values['Кадастр'] := FMainQuery.FieldByName(SF_CADASTRE).AsString;

    ///  посмотреть координату по Х - если > 100000 это csMCK36 иначе csVrn
    ///  не, слишком много последствий! искать дальше
    //if FContours.Items[0].Points[0].X > 100000 then
    //Cs := csMCK36
    //else
    //  Cs := csVrn;

    if chbShowMSK36.Checked then
//    if dbchMSK36.Checked then
      Cs := csMCK36
    else
      Cs := csVrn;
    PrintOtvod.PrintAReport(FileName, Params, FContours, Cs, Info, '');
  end;

begin
  //Вырезаем  строку с нужным ID
  ibtList.StartTransaction;
  with ibqGetPrintInf do
  begin
    Params[0].AsInteger := ReportIndex;
    Open;
    KindOfReport := FieldByName(SF_KIND).AsString;
    AReportPath := AppModule.ReportsPath + FieldByName(SF_FILEPATH).AsString;
    Close;
    ibtList.Commit;
    if KindOfReport = 'AReport' then
       PrintAReport(AReportPath)
    else
      if KindOfReport = 'FReport' then
        PrintFReport(AReportPath);
  end;
end;

function TAllotmentForm.IncPointName(PointName: String; delta: integer): String;
// ed
// изменение имени переданной точки на переданное приращение
// нужно оптимизировать, но потом
var
 J, max, min: integer;
 s, s1, s2, s3: String;
 flag: Boolean;
begin
  S := PointName;
  max := 0;
  min := 0;
  J := Length(S);
  flag := False;
  while J > 0 do
  begin
    if S[J] in ['0'..'9'] then
    begin
      if max = 0  then
      begin
        max := J;
        flag := True;
      end;
      if flag then
        min := J;
    end
    else
      flag := False;
    Dec(J);
  end;  //while J
  s1 := Copy (s, 1, min-1);
  s2 := Copy (s, min, max-min+1);
  s3 := Copy (s, max+1, Length(S)-max);
  J := StrToInt(s2);
  J := J + delta;
  S := s1 + IntToStr(J) + s3;
  Result := S;
end;

procedure TAllotmentForm.InitIBX;
begin
  ibqOwners.Transaction := AllotmentsForm.Transaction;
  ibsOwnersNextID.Transaction := AllotmentsForm.Transaction;
  ibsOwnersSumPercent.Transaction := AllotmentsForm.Transaction;
  ibsFirms.Transaction := AllotmentsForm.Transaction;
  ibqPropForms.Transaction := AllotmentsForm.Transaction;
  ibqDocs.Transaction := AllotmentsForm.Transaction;
  ibqDecrees.Transaction := AllotmentsForm.Transaction;
  ibsDocsNextId.Transaction := AllotmentsForm.Transaction;
  ibqContours.Transaction := AllotmentsForm.Transaction;
  ibsContoursNew.Transaction := AllotmentsForm.Transaction;
  ibsContoursUpdate.Transaction := AllotmentsForm.Transaction;
  ibsContoursDel.Transaction := AllotmentsForm.Transaction;
  ibsDocs.Transaction := AllotmentsForm.Transaction;
  ibqPoints.Transaction := AllotmentsForm.Transaction;
  ibsPointsNew.Transaction := AllotmentsForm.Transaction;
  ibsPointsUpdate.Transaction := AllotmentsForm.Transaction;
  ibsPointsDel.Transaction := AllotmentsForm.Transaction;
  ibsPointsMaxId.Transaction := AllotmentsForm.Transaction;
  ibqAllPoints.Transaction := AllotmentsForm.Transaction;

  ibqGetPrintInf.Transaction := ibtList;
  ibtReports.Transaction := ibtrReports;
end;

procedure TAllotmentForm.btnCalcNomenclaturClick(Sender: TObject);
begin
  CalcNomenclature;
end;

const
  MapSize = 250;

function PointInMapCase(APoint: TKisPoint; ASquare: TSquare): Boolean;
begin
  Result := ((APoint.X <= ASquare.X0) and (APoint.X >= (ASquare.X0 - MapSize))) and
          ((APoint.Y >= ASquare.Y0) and (APoint.Y <= (ASquare.Y0 + MapSize)));
end;

function TAllotmentForm.MapCasesByAllotment: TStringList;
var
  I, J, J1, K, X, Y: Integer;
  Maps: array of TSquares;
  Squares: array of TSquares;
  Pnt: TKisPoint;
  Lim1X, Lim2X, Lim1Y, Lim2Y: Integer;
  XCount, YCount: Integer;
  Cnt: TContour;
  Ext, E: TKisExtent;
begin
  Result := nil;
  Ext := nil;
  for I := 0 to FContours.Count - 1 do
  begin
    Cnt := FContours[I] as TContour;
    if Cnt.Enabled and (Cnt.Count > 0) then
    begin
      E := Cnt.GetExtent;
      try
        if Assigned(E) then
        begin
          if not Assigned(Ext) then
            Ext := TKisExtent.Create(E)
          else
            Ext.Join(E);
        end;
      finally
        FreeAndNil(E);
      end;
    end;
  end;
  ///
  if not Assigned(Ext) then
    Exit;

  SetLength(Maps, 0);
  SetLength(Squares, 0);

// заполняем матрицу из планшетов, в которую вписаны контура
  Lim1X := GetNextMultiple(Ext.FXmax, MapSize, True);
  Lim2X := GetNextMultiple(Ext.FXmin, MapSize, False);
  XCount := (Lim1X - Lim2X) div MapSize;
  SetLength(Squares, XCount);
  Lim1Y := GetNextMultiple(Ext.FYmax, MapSize, True);
  Lim2Y := GetNextMultiple(Ext.FYmin, MapSize, False);
  YCount := (Lim1Y - Lim2Y) div MapSize;
  if (XCount > 100) or (YCount > 100) then
    raise Exception.Create(
      'Невозможно построить список номенклатур!' + #13#10 +
      'Возможно контуры содержат координаты в разных системах координат!');

  for I := 0 to High(Squares) do
    SetLength(Squares[I], YCount);

  Result := TStringList.Create;
  Result.CaseSensitive := False;
  Result.Sorted := True;
  Result.Duplicates := dupIgnore;

  X := Lim1X;
  for I := 0 to Pred(XCount) do
  begin
    Y := Lim2Y;
    for J := 0 to Pred(YCount) do
    begin
      Squares[I, J].X0 := X;
      Squares[I, J].Y0 := Y;
      Squares[I, J].Crossings := 0;
      Squares[I, J].Name := Geodesy.GetNomenclature(Pred(X), Succ(Y), True);
      Inc(Y, MapSize);
    end;
    Dec(X, MapSize);
  end;

// помечаем планшеты, через которые проходят контура
  for I := 0 to FContours.Count - 1 do
  begin
    Cnt := FContours[I] as TContour;
    if Cnt.Enabled and (Cnt.Count > 0) then
    begin
      for J1 := 0 to Pred(Cnt.Count) do
      begin
        if J1 = Pred(Cnt.Count) then
          Pnt := Cnt[0]
        else
          Pnt := Cnt[Succ(J1)];
        for J := 0 to High(Squares) do
        for K := 0 to High(Squares[J]) do
        begin
          if Squares[J, K].Crossings > 0 then
            Continue;
          if PointInMapCase(Cnt[J1], Squares[J, K]) or PointInMapCase(Pnt, Squares[J, K]) then
            Inc(Squares[J, K].Crossings)
          else
            if IsCrossedPieces(Cnt[J1].X, Cnt[J1].Y, Pnt.X, Pnt.Y,
                               Squares[J, K].X0, Squares[J, K].Y0,
                               Squares[J, K].X0 - MapSize, Squares[J, K].Y0) or
               IsCrossedPieces(Cnt[J1].X, Cnt[J1].Y, Pnt.X, Pnt.Y,
                               Squares[J, K].X0 - MapSize, Squares[J, K].Y0,
                               Squares[J, K].X0 - MapSize, Squares[J, K].Y0 + MapSize) or
               IsCrossedPieces(Cnt[J1].X, Cnt[J1].Y, Pnt.X, Pnt.Y,
                               Squares[J, K].X0 - MapSize, Squares[J, K].Y0 + MapSize,
                               Squares[J, K].X0, Squares[J, K].Y0 + MapSize) or
               IsCrossedPieces(Cnt[J1].X, Cnt[J1].Y, Pnt.X, Pnt.Y,
                               Squares[J, K].X0, Squares[J, K].Y0 + MapSize,
                               Squares[J, K].X0, Squares[J, K].Y0)
            then
              Inc(Squares[J, K].Crossings);
        end;
      end;
    end;
  end;

  KavUtils.CheckMapMatrix(Squares);

  // Заносим в result "наши" планшеты
  for I := 0 to High(Squares) do
  for J := 0 to High(Squares[I]) do
    if Squares[I, J].Crossings > 0 then Result.Add(Squares[I, J].Name);

  SetLength(Maps, 0);
  SetLength(Squares, 0);
end;

procedure TAllotmentForm.PrintFROtvodRoman1(const AReportName: String;
  AllOwners: Boolean);
var
  St: String;
begin
  with PrintModule do
  begin
    ReportFile := AReportName;
    with ibtReports do
    begin
      Open;
      try
        Append;
        FieldByName('STRING01').AsString := FMainQuery.FieldByName(SF_ADDRESS).AsString;
        FieldByName('STRING02').AsString := FMainQuery.FieldByName(SF_REGIONS_NAME_PREP).AsString;
        if ibqOwners.FieldByName(SF_PERCENT).AsFloat = 100 then
          St := FMainQuery.FieldByName(SF_AREA).AsString + S_M2
        else
          St := FMainQuery.FieldByName(SF_AREA).AsString + S_M2 + ' Площадь землепользования ' +
                Format(S_COORD_FORMAT, [ibqOwners.FieldByName(SF_PERCENT).AsFloat *
                                 FMainQuery.FieldByName(SF_AREA).AsFloat / 100]) +
                ' кв.м., что составляет ' +
                Format(S_COORD_FORMAT, [ibqOwners.FieldByName(SF_PERCENT).AsFloat]) +
                '% от общей площади земельного участка';
        FieldByName('STRING03').AsString := St;
        St := ibqOwners.FieldByName('PROP_FORMS_NAME_ACC').AsString;
        if ibqOwners.FieldByName(SF_RENT_PERIOD).AsInteger > 0 then
          St := St + ' на ' + ibqOwners.FieldByName(SF_RENT_PERIOD).AsString + ' лет';
        FieldByName('STRING04').AsString := St;
        FieldByName('STRING05').AsString := ibqOwners.FieldByName(SF_PURPOSE).AsString;
        FieldByName('STRING06').AsString := GetFullFirmName(False, AllOwners);
        FieldByName('STRING07').AsString := GetDocs;
      finally
        if AllotmentPrintEditShow then
          PrintReport;
        Close;
      end;
    end;
  end;
end;

function TAllotmentForm.GetFullFirmName(WithAddress, AllOwners: Boolean): String;
var
  Mark: String;
  q: TIBQuery;

  function GetName: String;
  begin
    if ibqOwners.FieldByName(SF_FIRMS_ID).IsNull then
      Result := ibqOwners.FieldByName(SF_NAME).AsString
    else
      with ibsFirms do
      begin
        Params.ByName(SF_ID).Value := ibqOwners.FieldByName(SF_FIRMS_ID).Value;
        try
          ExecQuery;
          Result := FieldByName(SF_NAME).AsString;
          if WithAddress then
            if not ibqOwnersFIRMS_ID.IsNull then
            begin
              q.Params[0].AsInteger := ibqOwnersFIRMS_ID.AsInteger;
              q.Open;
              if not q.IsEmpty then Result := Result + ' ' + q.Fields[0].AsString;
              q.Close;
            end;
        finally
          Close;
        end;
      end;
  end;

begin
  q := TIBQuery.Create(Self);
  q.Forget();
  q.BufferChunks := 1;
  q.Transaction := AllotmentsForm.Transaction;
  q.SQL.Add('SELECT ADDRESS FROM FIRMS WHERE ID=:ID');
  if AllOwners then with ibqOwners do
  begin
    Mark := BookMark;
    First;
    while not Eof do
    begin
      if Result <> '' then Result := Result + ', ';
      Result := Result + GetName;
      Next;
    end;
    BookMark := Mark;
  end
  else
    Result := GetName;
end;

function TAllotmentForm.GetPointsDebugInfo: String;
var
  L: TStrings;
  Cnt: TContour;
  Li: TListItem;
begin
  L := IStrings(TStringList.Create).Strings;
  L.Add('Контуры:');
  FContours.ToStrings(L);
  L.Add('Активный контур:');
  Li := lvContours.Selected;
  if Assigned(Li) then
    Cnt := Li.Data
  else
    Cnt := nil;
  if Assigned(Cnt) then
    try
      Cnt.ToStrings(L);
    except
      L.Add('Ошибка в активном контуре');
    end
  else
    L.Add('nil');
  Result := L.Text;
end;

function TAllotmentForm.GetShowCS: TCoordSystem;
begin
  //if dbchMSK36.Checked then
  //begin
   // if chbShowMSK36.Checked then
     // Result := csVrn
    //else
      //Result := csMCK36;
  //end
  //else
 // begin
    if chbShowMSK36.Checked then
      Result := csMCK36
    else
      Result := csVrn;
  //end;
end;

procedure TAllotmentForm.PrintFROther(const AReportName: String;
  AllOwners: Boolean);
begin
  with PrintModule do
  begin
    ReportFile := AReportName;
    //присваиваем базу данных запроса
    SetReportTransaction(AllotmentsForm.Transaction);
    //присваиваем переменные
    PrepareReportParams(PrintModule(False), AllOwners);
    //выводим отчет
    PrintReport;
  end;
end;

procedure TAllotmentForm.PrintFRTech(const AReportName: String;
  AllOwners: Boolean);
begin
  with PrintModule do
  begin
    ReportFile := AReportName;
    SetMasterDataSet(ibqDocs, 'mdDocs');
    PrepareReportParams(PrintModule(False), AllOwners);
    PrintReport;
  end;
end;

procedure TAllotmentForm.SetCaption(const ACaption: String);
begin
  if ACaption <> '' then
    Caption := 'Отвод - ' + ACaption;
end;

procedure TAllotmentForm.dbeAddressChange(Sender: TObject);
begin
  SetCaption(dbeAddress.Text);
end;

procedure TAllotmentForm.acPasteContourExecute(Sender: TObject);

//  procedure AddPoint(id: Integer; x, y: Double; const name: String);
//  var
//    NewPt: TKisPoint;
//  begin
//    NewPt := TKisPoint.Create(0, 0);
//    if GetShowCS = csVrn then
//    begin
//      NewPt.X := x;
//      NewPt.Y := y;
//    end
//    else
//    begin
//      NewPt.X36 := x;
//      NewPt.Y36 := y;
//    end;
//    NewPt.Id := id;
//    NewPt.Name := name;
//    if Assigned(lvContours.Selected) then
//      GetActiveContour.Add(NewPt);
//  end;
//
//  procedure AddPoints(first_num: Integer; s: String; Name_Flag: Boolean = false);
//  var
//    x, y: Double;
//    s1, name: AnsiString;
//    i, j, num,nname: Integer;
//    counter: Integer;
//    l: TStringList;
//    Pnt1: TKisPoint;
//  begin
//    l := IStringList(TStringList.Create).StringList;
//    try
//      // Загоняем точки в List
//      s := StringReplace(s, '.', ',', [rfReplaceAll]);
//      /// ed из планшетки точки приходят с пробелами перед координатой
//      /// (видимо для форматирования)
//      ///  заодно и пробелы уничтожаем
//      s := StringReplace(s, ' ', '', [rfReplaceAll]);
//      ///  ed
//      nname := 0;
//      for i := 0 to (lvPoints.Items.Count - 1) do
//        begin
//          Pnt1 := lvPoints.Items.Item[i].Data;
//          if TryStrToInt(Pnt1.Name, j) then
//          if nname < j then
//            nname := j;
//        end;
//      if nname = 0 then
//        nname := first_num;
//      ///
//      l.Text := s;
//      num := first_num;
//      for i := 0 to l.Count - 1 do
//      begin
//        s := l.Strings[i];
//        if s[1] <= #32 then
//          raise EAbort.Create('');
//        s1 := '';
//        j := 1;
//        counter := 0;
//        x := 0;
//        while j <= Length(s) do
//        begin
//          if (s[j] <= #32) or (j = Length(s)) then
//          begin
//            s1 := Copy(s, 1, Integer(IfThen((j = Length(s)), j, j - 1)));
//            Delete(s, 1, j);
//            j := 0;
//            inc(counter);
//            case counter of
//            1 : begin
//                  if Name_Flag then
//                    begin
//                    inc(nname);
//                    name := IntToStr(nname);
//                    end
//                  else
//                    name := s1;//имя точки
//                end;
//            2 : x := StrToFloat(s1);
//            3 : begin
//                  y := StrToFloat(s1);
//                  inc(num);
//                  //x := Round(x * 100) / 100;
//                  //y := Round(y * 100) / 100;
//                  //AddPoint(num, x, y, IntToStr(num));
//                  AddPoint(num, x, y, name);
//                end;
//            4 : Break;
//            end;
//          end;
//          inc(j);
//        end;
//      end;
//    except
//      on E: Exception do
//      begin
//        AppModule.LogException(Exception(ExceptObject), GetDebugInfo);
//        MessageBox(Handle, PChar(S_PARTIAL_BAD_FORMAT), PChar(S_WARN), MB_ICONWARNING);
//      end;
//    end;
//  end;

var
  S: String;
  TotalPoints, AddedPoints, AddedPoints2: Integer;
  Answ: Cardinal;
  Cnt, TmpCnt, TmpCnt2: TContour;
  Errors, Errors2: TContour.TContourLoadErrors;
  ReplacePoints, ChangeNumbers, Renamed: Boolean;
  Options: TPastePointsOptionsDialog.TPastePointsOptions;
begin
  try
    TmpCnt := TContour.Create;
    TmpCnt.Forget();
    TmpCnt2 := TContour.Create;
    TmpCnt2.Forget();
    Clipboard.Open;
    try
      Cnt := GetActiveContour(True);
      if ClipBoard.HasFormat(CF_TEXT) then
      begin
        S := ClipBoard.AsText;
        //
        TotalPoints := 0;
        AddedPoints := 0;
        AddedPoints2 := 0;
        Errors := [];
        Errors2 := [];
        TmpCnt.LoadFromText(S, GetShowCS, #9, TotalPoints, AddedPoints, Errors);
        if AddedPoints = 0 then
          TmpCnt.LoadFromText(S, GetShowCS, ';', TotalPoints, AddedPoints, Errors);
        if AddedPoints = 0 then
          TmpCnt.LoadFromText(S, GetShowCS, ' ', TotalPoints, AddedPoints, Errors);
        TmpCnt2.LoadFromTextConsultant(S, GetShowCS, AddedPoints2, Errors2);
        if AddedPoints2 > AddedPoints then
        begin
          AddedPoints := AddedPoints2;
          Errors := Errors2;
          TmpCnt := TmpCnt2;
        end;
        //
        TmpCnt2 := TContour.Create;
        TmpCnt2.Forget();
        TmpCnt2.LoadFromTextConsultant2(S, GetShowCS);
        AddedPoints2 := TmpCnt2.Count;
        if AddedPoints2 > AddedPoints then
        begin
          AddedPoints := AddedPoints2;
          //Errors := Errors2;
          TmpCnt := TmpCnt2;
        end;
        //
        TmpCnt2 := TContour.Create;
        TmpCnt2.Forget();
        TmpCnt2.LoadFromTextConsultant3(S, GetShowCS);
        AddedPoints2 := TmpCnt2.Count;
        if AddedPoints2 > AddedPoints then
        begin
          AddedPoints := AddedPoints2;
          //Errors := Errors2;
          TmpCnt := TmpCnt2;
        end;
        //
        Answ := ID_YES;
        if TotalPoints <> AddedPoints then
        if Errors <> [] then
        begin
          if AddedPoints <> 0 then
          begin
            S := 'При обработке буфера обмена некоторые строки не удалось преобразовать в координаты!'
            + #13#10 + 'Всего строк в буфере: ' + IntToStr(TotalPoints)
            + #13#10 + 'Преобразовано в точки: ' + IntToStr(AddedPoints);
            S := S + #13#10 + #13#10 + 'Продолжить?';
            Answ := MessageBox(Handle, PChar(S), PChar(S_WARN),
              MB_ICONINFORMATION + MB_YESNOCANCEL);
          end
          else
          begin
            S := 'Не удалось преобразовать текст из буфера обмена в координаты!'
            + #13#10 + 'Всего строк в буфере: ' + IntToStr(TotalPoints)
            + #13#10 + 'Преобразовано в точки: ' + IntToStr(AddedPoints);
            MessageBox(Handle, PChar(S), PChar(S_WARN),
              MB_ICONWARNING + MB_OK);
            Answ := ID_NO;
          end;
        end;
        //
        if Answ = ID_YES then
        begin
          ReplacePoints := AppModule.ReadAppParam('Allotments', 'PastePointsReplace', varBoolean);
          ChangeNumbers := AppModule.ReadAppParam('Allotments', 'PastePointsChangeNumbers', varBoolean);
          if ReplacePoints then
            Options := Options + [ppoReplacePoints];
          if ChangeNumbers then
            Options := Options + [ppoChangeNumbers];
          if TPastePointsOptionsDialog.Execute(Options) then
          begin
            ReplacePoints := ppoReplacePoints in Options;
            ChangeNumbers := ppoChangeNumbers in Options;
            AppModule.SaveAppParam('Allotments', 'PastePointsReplace', ReplacePoints);
            AppModule.SaveAppParam('Allotments', 'PastePointsChangeNumbers', ChangeNumbers);
            ///
            if ChangeNumbers then
            begin
              if Cnt.Last <> nil then
                S := Cnt.Last.Name
              else
                S := '0';
              TmpCnt.RenamePoints(S);
            end;
            if ReplacePoints then
              Cnt.Clear;
            Cnt.Append(TmpCnt, Renamed);
            if Renamed then
              MessageBox(Handle,
                'Названия некоторых точек совпали!' + #13#10 +
                'Точки были переименованы!', PChar(S_WARN), MB_ICONEXCLAMATION + MB_OK);
            Cnt.CalcPointIds;
            //
            ShowPoints(Cnt, 0);
            DBSaveContour(Cnt);
          end;
        end;
      end
      else
        MessageBox(0, PChar(S_Bad_Info_Format), PChar(S_Error), MB_ICONSTOP);
    finally
      ClipBoard.Close;
    end;
    ShowPoints(GetActiveContour(True), 0);
  except
    on E: Exception do
    begin
      raise EKisExtException.Create(E, GetPointsDebugInfo + #13#10 +
        'Clipboard: ' + #13#10 + ClipBoard.AsText);
    end;
  end;
end;

procedure TAllotmentForm.acPasteContourUpdate(Sender: TObject);
var
  b: Boolean;
begin
  b := not ReadOnly and (lvContours.Selected <> nil);
  if b then
    with Clipboard do
    try
      acPasteContour.Enabled := (AsText <> '');
    except
      acPasteContour.Enabled := False;
    end
  else
    acPasteContour.Enabled := False;
end;

procedure TAllotmentForm.acPointAddExecute(Sender: TObject);
begin
  PointInsert();
  PaintBox.Invalidate;
end;

procedure TAllotmentForm.acPointAddUpdate(Sender: TObject);
begin
  acPointAdd.Enabled := not ReadOnly and (lvContours.SelCount = 1);
end;

procedure TAllotmentForm.acPointCopyExecute(Sender: TObject);
begin
  PointCopy();
end;

procedure TAllotmentForm.acPointCopyUpdate(Sender: TObject);
begin
  acPointCopy.Enabled := not ReadOnly and Assigned(lvPoints.Selected);
end;

procedure TAllotmentForm.acPointDeleteExecute(Sender: TObject);
begin
  PointDel();
  PaintBox.Invalidate;
end;

procedure TAllotmentForm.acPointDeleteUpdate(Sender: TObject);
begin
  acPointDelete.Enabled := not ReadOnly and (lvPoints.SelCount > 0);
end;

procedure TAllotmentForm.acPointEditExecute(Sender: TObject);
begin
  PointEdit();
  PaintBox.Invalidate;
end;

procedure TAllotmentForm.acPointEditUpdate(Sender: TObject);
begin
  acPointEdit.Enabled := not ReadOnly and (lvPoints.SelCount = 1);
end;

procedure TAllotmentForm.acPointNamePlusExecute(Sender: TObject);
begin
  PointNamePlus();
end;

procedure TAllotmentForm.acPointNamePlusUpdate(Sender: TObject);
begin
  acPointNamePlus.Enabled := not ReadOnly and Assigned(lvPoints.Selected);
end;

procedure TAllotmentForm.acCopyPointsUpdate(Sender: TObject);
begin
  acCopyPoints.Enabled := (lvContours.Selected <> nil) and (lvPoints.SelCount > 0);
end;

procedure TAllotmentForm.acCopyAllPointsUpdate(Sender: TObject);
begin
  acCopyAllPoints.Enabled := (lvContours.Selected <> nil) and (lvPoints.Items.Count > 0);
end;

procedure TAllotmentForm.CopyPoints(all: Boolean);
var
  i, j: Integer;
  s: String;
begin
  s := '';
  for i := 0 to lvPoints.Items.Count - 1 do
    if all or lvPoints.Items[i].Selected then
    begin
      s := s + lvPoints.Items[i].Caption + #9;
      for j := 0 to lvPoints.Items[i].SubItems.Count - 1 do
        s := s + lvPoints.Items[i].SubItems[j] + #9;
      s := s + #13#10;
    end;
  if Length(s) > 0 then
  begin
    Clipboard.Open;
    try
      Clipboard.SetTextBuf(PChar(s));
    except
    if ExceptObject is Exception then
      AppModule.LogException(Exception(ExceptObject), getDebugInfo);
      MessageBox(Handle, PChar(S_Copy_Error), PChar(S_Error), MB_OK);
    end;
    Clipboard.Close;
  end
  else
    raise EAbort.Create(S_NOPOINTS_TO_COPY);
end;

procedure TAllotmentForm.acCopyPointsExecute(Sender: TObject);
begin
  CopyPoints(False);
end;

procedure TAllotmentForm.acCntAddExecute(Sender: TObject);
begin
  ContourNew();
end;

procedure TAllotmentForm.acCntAddUpdate(Sender: TObject);
begin
  acCntAdd.Enabled := not ReadOnly;
end;

procedure TAllotmentForm.acCntDelExecute(Sender: TObject);
begin
  ContourDel();
end;

procedure TAllotmentForm.acCntDelUpdate(Sender: TObject);
begin
  acCntDel.Enabled := not ReadOnly and (lvContours.Selected <> nil);
end;

procedure TAllotmentForm.acCntEditExecute(Sender: TObject);
begin
  ContourEdit();
end;

procedure TAllotmentForm.acCntEditUpdate(Sender: TObject);
begin
  acCntEdit.Enabled := not ReadOnly and (lvContours.Selected <> nil);
end;

procedure TAllotmentForm.acCopyAllPointsExecute(Sender: TObject);
begin
  CopyPoints(True);
end;

procedure TAllotmentForm.acExportToDXFExecute(Sender: TObject);
begin
  ExportToFile(efDXF);
end;

function TAllotmentForm.PointsToDXF(const FileName: String; const Points: TContour): Boolean;
var
  dxf: TextFile;

  procedure AddLine(const X1, Y1, X2, Y2: Double);
  begin
    Writeln(dxf, '0');
    Writeln(dxf, 'LINE');
    Writeln(dxf, '8');
    Writeln(dxf, '0');
    Writeln(dxf, '10');
    Writeln(dxf, FloatToStr(Y1));
    Writeln(dxf, '20');
    Writeln(dxf, FloatToStr(X1));
    Writeln(dxf, '11');
    Writeln(dxf, FloatToStr(Y2));
    Writeln(dxf, '21');
    Writeln(dxf, FloatToStr(X2));
  end;

var
  I: Integer;
  C: Char;
  X1, X2, Y1, Y2: Double;
begin
  C := DecimalSeparator;
  DecimalSeparator := '.';
  try
    AssignFile(dxf, filename);
    Rewrite(dxf);
    // create DXF-file header
    Writeln(dxf, '0');
    Writeln(dxf, 'SECTION');
    Writeln(dxf, '2');
    Writeln(dxf, 'ENTITIES');
    // write lines to DXF-file
    for I := 0 to Pred(Points.Count) - 2 do
    begin
      if GetShowCS = csVrn then
      begin
        X1 := Points[I].X;
        Y1 := Points[I].Y;
        X2 := Points[I + 1].X;
        Y2 := Points[I + 1].Y;
      end
      else
      begin
        X1 := Points[I].X36;
        Y1 := Points[I].Y36;
        X2 := Points[I + 1].X36;
        Y2 := Points[I + 1].Y36;
      end;
      AddLine(X1, Y1, X2, Y2);
    end;
    I := Pred(Points.Count);
    AddLine(Points[I].X, Points[I].Y, Points[0].X, Points[0].Y);
    // create DXF-file footer
    Writeln(dxf, '0');
    Writeln(dxf, 'ENDSEC');
    Writeln(dxf, '0');
    Writeln(dxf, 'EOF');
    CloseFile(dxf);
    Result := True;
  except
    if ExceptObject is Exception then
      AppModule.LogException(Exception(ExceptObject), GetDebugInfo);
    Result := False;
  end;
  DecimalSeparator := c;
end;

procedure TAllotmentForm.dbchCheckedClick(Sender: TObject);
begin
  if not Visible then
    Exit;
  if CheckError then
    Exit;
  try
    if (AppModule.User.RoleName = S_ROLE_GEOSERVICE) or AppModule.User.IsAdministrator then
    begin
      with TIBQuery.Create(nil) do
      begin
        Forget;
        BufferChunks := 1;
        Transaction := AllotmentsForm.Transaction;
        SQL.Text := Format(SQ_LOT_POINT_COUNT, [AllotmentsId]);
        Open;
        if Fields[0].AsInteger < 2 then
          raise Exception.Create(S_TOO_LESS_POINTS);
        Close;
      end;
    end
    else
      raise Exception.Create(S_NO_PERMISSION);
  except
    CheckError := True;
    dbchChecked.Checked := not dbchChecked.Checked;
    CheckError := False;
    raise;
  end;
end;

procedure TAllotmentForm.dbchMSK36Click(Sender: TObject);
begin
  if not (csLoading in ComponentState) then
    if dbchMSK36.Checked then
      chbShowMSK36.Checked := True
    else
      chbShowMSK36.Checked := False;
end;

procedure TAllotmentForm.DBDeletePoint(Pt: TKisPoint; Cnt: TContour);
begin
  with ibsPointsDel do
  begin
    Params.ByName(SF_ALLOTMENTS_ID).Value := AllotmentsId;
    Params.ByName(SF_CONTOURS_ID).Value := Cnt.Id;
    Params.ByName(SF_ID).Value := Pt.Id;
    ExecQuery;
  end;
end;

procedure TAllotmentForm.FormCreate(Sender: TObject);
begin
  FContours := TContours.Create;
end;

procedure TAllotmentForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FContours);
end;

procedure TAllotmentForm.FormShow(Sender: TObject);
begin
  if dbchMSK36.Checked then
  begin
    if (lvContours.Items.Count > 0) and not Assigned(lvContours.Selected) then
      lvContours.Selected := lvContours.Items[0];
    chbShowMSK36.Checked := True;
  end;
end;

procedure TAllotmentForm.ExportToFile;
var
  Cnt: TContour;
begin
  Cnt := GetActiveContour(True);
  if Assigned(Cnt) then
  begin
    SaveDialog.FileName := dbeAddress.Text;
    if SaveDialog.Execute then
    begin
      case Format of
      efDXF  : PointsToDXF(SaveDialog.FileName, Cnt);
      efText : PointsToTxt(SaveDialog.FileName, Cnt);
      end;
    end;
  end;
end;

procedure TAllotmentForm.N11Click(Sender: TObject);
var
  Cnt: TContour;
begin
  Cnt := GetActiveContour(True); //берем активный контур
  if Assigned(Cnt) then //если он есть
  begin
    SaveDialog1.FileName := dbeAddress.Text; //кидаем в диалоговое окно сохранения файла адрес отвода
    if SaveDialog1.Execute then //вызываем диалог
    begin
      //--
      PointsToTxt(SaveDialog1.FileName, Cnt);//запускаем процедуру сохранения в файл
    end;
  end;
end;

procedure TAllotmentForm.N8Click(Sender: TObject);
begin
  ExportToFile(efText);
end;

procedure TAllotmentForm.PrepareContourIcon(Cnt: TContour);
var
  Bmp1: TBitmap;
begin
  if Cnt.Color = 0 then
  begin
    if Cnt.Id <= 15 then
    begin
      Bmp1 := TBitmap.Create;
      Bmp1.Forget();
      ilContoursDefault.GetBitmap(Cnt.Id, Bmp1);
      //Bmp1.Transparent := True;
      // добавляем в ilContours дефолтную иконку
      Cnt.ImageIndex := ilContours.AddMasked(Bmp1, Bmp1.Canvas.Pixels[0, 0]);
      // назначаем дефолтный цвет
    end
    else
    begin
      Bmp1 := TBitmap.Create;
      Bmp1.Forget();
      ilContoursDefault.GetBitmap(15, Bmp1);
      Bmp1.Transparent := True;
      Cnt.ImageIndex := ilContours.AddMasked(Bmp1, Bmp1.TransparentColor);
      // добавляем в ilContours дефолтную иконку c 15
      // назначаем дефолтный цвет
    end;
  end
  else
  begin
    // создаём новую иконку
      Bmp1 := TBitmap.Create;
      Bmp1.Forget();
      ilContoursDefault.GetBitmap(0, Bmp1);
      Bmp1.ReplaceColor(clBlack, Cnt.Color);
      Bmp1.Transparent := True;
      // добавляем её в ilContours
      Cnt.ImageIndex := ilContours.AddMasked(Bmp1, Bmp1.TransparentColor);
  end;
end;

procedure TAllotmentForm.PrepareReportParams(Module: TKisPrintModule; AllOwners: Boolean);
begin
  with Module do
  begin
    if ParamExists(SF_ALLOTMENTS_ID) then
      SetParamValue(SF_ALLOTMENTS_ID, AllotmentsForm.QueryID.AsInteger);
    if ParamExists(SF_CONTOURS_ID) then
      SetParamValue(SF_CONTOURS_ID, lvContours.Selected.Caption);
    if ParamExists('SumOfPoints') then
      SetParamValue('SumOfPoints', lvPoints.Items.Count);
    if ParamExists('STEP') then
      SetParamValue('STEP', 0);
    if ParamExists('OWNER_ADDRESS') then
      SetParamValue('OWNER_ADDRESS', GetFullFirmName(True, AllOwners));
    if ParamExists('DOC_NAME1') then
      SetParamValue('DOC_NAME1', GetDocs);
    if ParamExists('EXECUTOR_NAME') then
      SetParamValue('EXECUTOR_NAME', dbeExecutor.Text);
    if ParamExists(SF_OWNER) then
      SetParamValue(SF_OWNER, GetFullFirmName(False, AllOwners));
    if ParamExists('EXECUTOR_POST') then
      SetParamValue('EXECUTOR_POST', AppModule.User.Post);
  end;
end;

function TAllotmentForm.PointsToTxt(const FileName: String; const Points: TContour): Boolean;
var
  txt: TextFile;
  //s : string;
  C: Char;
  I: Integer;
  Ex: EAllotmentException;

  function makeStr(const Idx: Integer): string;
  var
    aX, aY: Double;
  begin
    with Points[Idx] do
      if GetShowCS = csVrn then  // смотрим какие координаты брать
      begin //воронежские
        aX := X;
        aY := Y;
      end
      else //или
      begin  //ТридцатШестые
        aX := X36;
        aY := Y36;
      end;
    Result := FloatToStr(aX)  + ' ' + FloatToStr(aY); //собираем строку
  end;

begin
  // implemented of ed
  C := DecimalSeparator; //копируем десятичный разделитель
  DecimalSeparator := '.'; //указываем новый десятичный разделитель
  try //файловые операции потенциально опасны
    AssignFile(txt, FileName); //ассигнуем текстовик
    Rewrite(txt); //если он есть - перезапишем
    for I := 0 to Pred(Points.Count) do//перебор точек в контуре
      Writeln(txt, makeStr(I));//писем ейную в файло
    Writeln(txt, makeStr(0));//пишем первую в файло для закрытия контура
    CloseFile(txt);//закрываем файл
    Result := True;//вертаем взад УРА
  except //если что то пошло не так
    on E: Exception do
    begin
      Ex := EAllotmentException.Create(E, 'FileName: ' + FileName);
      Ex.Message :=
        'Невозможно записать данные в файл!' + #13#10
      + 'Файл открыт другим пользователем или у вас недостаточно прав для записи в выбранную папку.'
      + #13#10 + 'Имя файла: ' + FileName;
      raise Ex;
    end;
  end;
  DecimalSeparator := c;//возвращаем десятичный разделитель
end; //все

procedure TAllotmentForm.CalcNomenclature;
var
  I: Integer;
  MapCases: TStringList;
  S: String;
begin
  try
    MapCases := MapCasesByAllotment;
    if Assigned(MapCases) then
    try
      S := '';
      for I := 0 to Pred(MapCases.Count) do
      begin
        if S <> '' then S := S + ', ';
        S :=  S + MapCases.Strings[I];
      end;
      FMainQuery.SoftEdit();
      FMainQuery.FieldByName(SF_NOMENCLATURA).AsString := S;
    finally
      FreeAndNil(MapCases);
    end;
  except
    on E: Exception do
      with EAllotmentException.Create(E, GetPointsDebugInfo) do
      begin
        Id := FMainQuery.FieldByName(SF_ID).AsInteger;
        raise Me;
      end;
  end;
end;

procedure TAllotmentForm.chbShowMSK36Click(Sender: TObject);
var
  PtId: Integer;
begin
  PtId := 0;
  if Assigned(lvPoints.Selected) then
    PtId := TKisPoint(lvPoints.Selected.Data).Id;
  ShowArea;
  ShowPoints(GetActiveContour(True), PtId);
end;

procedure TAllotmentForm.btnClearCadastreClick(Sender: TObject);
begin
  dbeCadastr.Clear;
  FMainQuery.SoftEdit();
  FMainQuery.FieldByName(SF_CADASTRE).AsString := '';
end;

end.
