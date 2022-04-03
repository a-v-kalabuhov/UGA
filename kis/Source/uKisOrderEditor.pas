{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Редактор заказа                                 }
{                                                       }
{       Copyright (c) 2004, МП УГА                      }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание:
  Имя модуля: Letter Editor
  Версия: 1.02
  Дата последнего изменения: 07.09.2005
  Цель:
  Используется:
  Использует:
  Исключения: нет }
{
  1.02  07.09.2005
      - добавлена кнопка обмена заказчика и плетльщика

  1.01  05.09.2005
      - добавлена кнопка суммирования работ

  1.00  21.07.2004
      - начальная версия
}

unit uKisOrderEditor;

{$I KisFlags.pas}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ExtCtrls, DBCtrls, Grids, DBGrids, Buttons, StdCtrls, ComCtrls, DB, ActnList,
  DBActns, Mask, Dialogs,
  //
  JvDesktopAlert, JvBaseDlg,
  uGC, uVCLUtils, uCommonUtils, uGeoUtils,
  // Project
  uKisEntityEditor, uKisClasses, uDBGrid, uKisFilters, uKisConsts, uKisAppModule, uKisIntf, uKisSQLClasses,
  uKisLetters, uKisUtils;


type
  TKisOrderEditor = class(TKisEntityEditor)
    PageControl: TPageControl;
    tshCommon: TTabSheet;
    tshWorks: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label10: TLabel;
    edDocNumber: TEdit;
    edDocDate: TEdit;
    edOrderNumber: TEdit;
    edOrderDate: TEdit;
    cbOffices: TComboBox;
    gbContragent: TGroupBox;
    btnContragentClear: TButton;
    btnContragentDetail: TButton;
    btnContragentSelect: TButton;
    edContragentName: TEdit;
    btnAddPosition: TSpeedButton;
    btnDeletePosition: TSpeedButton;
    btnEditPosition: TSpeedButton;
    edNDS: TEdit;
    Label5: TLabel;
    cbChecked: TCheckBox;
    Label17: TLabel;
    Label16: TLabel;
    edTicket: TCombobox;
    Label18: TLabel;
    dbmWorkTypesName: TDBMemo;
    Label6: TLabel;
    edContragentAddress: TEdit;
    Label9: TLabel;
    mContragentProperties: TMemo;
    Label7: TLabel;
    edPhones: TEdit;
    Label8: TLabel;
    edINN: TEdit;
    Label19: TLabel;
    edActDate: TEdit;
    Label20: TLabel;
    edContractNumber: TEdit;
    pnlSum: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    dbtSumNds: TLabel;
    dbtSumma: TLabel;
    dbtSumAllNds: TLabel;
    Label21: TLabel;
    edObjectAddress: TEdit;
    Label22: TLabel;
    edCustomer: TEdit;
    Label24: TLabel;
    edValPeriod: TEdit;
    Label25: TLabel;
    Label26: TLabel;
    dbeArgument: TDBEdit;
    Label27: TLabel;
    edInformation: TEdit;
    cbMark: TCheckBox;
    dbeSumBase: TLabel;
    Label28: TLabel;
    cbExecutor: TComboBox;
    dbtSumNsp: TLabel;
    edSumBase: TEdit;
    edPayDate: TEdit;
    cbCancelled: TCheckBox;
    mContragentBank: TMemo;
    Label15: TLabel;
    edBankAccount: TEdit;
    LabelAccount: TLabel;
    lNDS: TLabel;
    lAllNDS: TLabel;
    lAll: TLabel;
    tshPayer: TTabSheet;
    dsPositions: TDataSource;
    gbPayer: TGroupBox;
    Label13: TLabel;
    Label23: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    btnPayerClear: TButton;
    btnPayerDetail: TButton;
    btnPayerSelect: TButton;
    edPayerName: TEdit;
    edPayerAddress: TEdit;
    mPayerProperties: TMemo;
    edPayerPhones: TEdit;
    edPayerINN: TEdit;
    edPayerCustomer: TEdit;
    dbgPositions: TkaDBGrid;
    Label32: TLabel;
    edCustomerBase: TEdit;
    cbPrintWorksValue: TCheckBox;
    btnSum: TButton;
    btnExChange: TBitBtn;
    bgBankAccount: TGroupBox;
    mPayerBank: TMemo;
    edPayerBankAccount: TEdit;
    Label34: TLabel;
    Label33: TLabel;
    edAccountType: TEdit;
    Label35: TLabel;
    btnSelectAccount: TBitBtn;
    Label36: TLabel;
    labelNumDoc: TLabel;
    cbClosed: TCheckBox;
    tshLetter: TTabSheet;
    cbLetterDocType: TComboBox;
    cbLetterOffice: TComboBox;
    GroupBox2: TGroupBox;
    Label45: TLabel;
    Label46: TLabel;
    edLetterMPNumber: TEdit;
    InGroup: TGroupBox;
    Label47: TLabel;
    Label48: TLabel;
    edLetterKGANumber: TEdit;
    Label51: TLabel;
    Label52: TLabel;
    Label54: TLabel;
    mLetterContent: TMemo;
    Label43: TLabel;
    edLetterFirmName: TEdit;
    Label50: TLabel;
    edLetterExecutedInfo: TEdit;
    cbLetterObjectType: TComboBox;
    Label49: TLabel;
    btnLetterSelect: TSpeedButton;
    btnLetterClear: TSpeedButton;
    btnFindLetterKGA: TBitBtn;
    dtpLetterKGADate: TDateTimePicker;
    btnFindLetterMP: TBitBtn;
    dtpLetterMPDate: TDateTimePicker;
    tshMaps: TTabSheet;
    GroupBox1: TGroupBox;
    Label37: TLabel;
    dbgMaps: TkaDBGrid;
    edNomenclature: TEdit;
    btnAddMap: TButton;
    btnDeleteMap: TButton;
    dsMaps: TDataSource;
    procedure edNDSKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnAddPositionClick(Sender: TObject);
    procedure btnDeletePositionClick(Sender: TObject);
    procedure edValPeriodKeyPress(Sender: TObject; var Key: Char);
    procedure edPayDateKeyPress(Sender: TObject; var Key: Char);
    procedure edOrderDateKeyPress(Sender: TObject; var Key: Char);
    procedure edDocDateKeyPress(Sender: TObject; var Key: Char);
    procedure edActDateKeyPress(Sender: TObject; var Key: Char);
    procedure dbgPositionsColEnter(Sender: TObject);
    procedure dbgPositionsExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOkClick(Sender: TObject);
    procedure btnFindLetterKGAClick(Sender: TObject);
    procedure btnLetterClearClick(Sender: TObject);
    procedure btnLetterSelectClick(Sender: TObject);
    procedure btnFindLetterMPClick(Sender: TObject);
    procedure edNDSExit(Sender: TObject);
    procedure edNomenclatureChange(Sender: TObject);
    procedure edNomenclatureKeyPress(Sender: TObject; var Key: Char);
    procedure btnAddMapClick(Sender: TObject);
    procedure btnDeleteMapClick(Sender: TObject);
  private
    procedure AddMap;
    function CanAdd: Boolean;
    function CanEdit: Boolean;
    function FindMap(const Nomenclature: String): Boolean;
    procedure UpdateMapControls;
  public
    procedure ClearLetterInfo;
    procedure UpdateLetterInfo(aLetter: TKisEntity);
  end;

implementation

{$R *.dfm}

uses
   uKisOrders;

procedure TKisOrderEditor.edNDSExit(Sender: TObject);
begin
  inherited;
  TKisOrder(Entity).NDS := StrToFloatDef(edNDS.Text, 0);
  TKisOrder(Entity).UpdateSums();
end;

procedure TKisOrderEditor.edNDSKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not (Key in FloatEditKeys) then
    Key := N_ZERO;
end;

procedure TKisOrderEditor.edNomenclatureChange(Sender: TObject);
begin
  inherited;
  UpdateMapControls;
end;

procedure TKisOrderEditor.edNomenclatureKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if Key = #13 then
    AddMap;
end;

procedure TKisOrderEditor.AddMap;
var
//  V: Variant;
  N: TNomenclature;
begin
  if btnAddMap.Enabled and CanAdd then
  begin
    N.Init(edNomenclature.Text, False);
    if not N.Valid then
    begin
      ControlAlert(edNomenclature, 'Неверная номенклатура!');
      edNomenclature.SetFocus;
    end
    else
//    if not AppModule.GetFieldValue(nil, ST_MAP_SCANS, SF_NOMENCLATURE, SF_ID, AnsiUpperCase(Nomen), V) then
//    begin
//      ControlAlert(edNomenclature, 'Планшет не отсканирован!');
//      edNomenclature.SetFocus;
//    end
//    else
//    if MapIsInUse(Nomen, OrderNum, OrderDate) then
//    begin
//      ControlAlert(edNomenclature,
//        Format('Планшет используется в заявке %s от %s!', [OrderNum, OrderDate]));
//      edNomenclature.SetFocus;
//    end
//    else
    begin
      with dsMaps.DataSet do
      try
        DisableControls;
        if RecNo = RecordCount then
          Append
        else
        begin
          Next;
          Insert;
        end;
        FieldByName(SF_NOMENCLATURE).AsString := N.Nomenclature();
        Post;
      finally
        EnableControls;
      end;
      UpdateMapControls;
    end;
  end;
end;

procedure TKisOrderEditor.btnAddMapClick(Sender: TObject);
begin
  inherited;
  AddMap;
end;

procedure TKisOrderEditor.btnAddPositionClick(Sender: TObject);
begin
  if Assigned(dbgPositions.DataSource.DataSet) then
    dbgPositions.DataSource.DataSet.Append;
end;

procedure TKisOrderEditor.btnLetterClearClick(Sender: TObject);
begin
  inherited;
  TKisOrder(Entity).LetterId := 0;
  TKisOrder(Entity).LetterAutoGenerated := False;
  ClearLetterInfo;
end;

procedure TKisOrderEditor.btnLetterSelectClick(Sender: TObject);
var
  Ent: TKisEntity;
  OfficeId: Integer;
  Filters: IKisFilters;
begin
  if cbOffices.ItemIndex >= 0 then
    OfficeId := Integer(cbOffices.Items.Objects[cbOffices.ItemIndex])
  else
    OfficeId := AppModule.User.OfficeID;
  with TFilterFactory do
  begin
    Filters := CreateList();
    Filters.Add(CreateFilter(SF_DOC_TYPES_ID, 1, frEqual));
    Filters.Add(CreateFilter(SF_ORGS_ID, AppModule.User.OrgId, frEqual));
    Filters.Add(CreateFilter(FF_OFFICE_PASSING, OfficeId, frNone));
  end;
  Ent := AppModule.SQLMngrs[kmLetters].SelectEntity(True, Filters, True);
  if Assigned(Ent) then
  begin
    ENt.Forget();
    TKisOrder(Entity).LetterId := Ent.ID;
    UpdateLetterInfo(Ent);
  end;
end;

procedure TKisOrderEditor.btnDeleteMapClick(Sender: TObject);
begin
  inherited;
  if btnDeleteMap.Enabled and CanEdit  then
  begin
    dsMaps.DataSet.Delete;
    UpdateMapControls;
  end;
end;

procedure TKisOrderEditor.btnDeletePositionClick(Sender: TObject);
begin
  if Assigned(dbgPositions.DataSource.DataSet) then
    if not dbgPositions.DataSource.DataSet.IsEmpty then
      dbgPositions.DataSource.DataSet.Delete;
end;

procedure TKisOrderEditor.btnFindLetterKGAClick(Sender: TObject);
var
  LetterMngr: TKisLetterMngr;
  Letter: TKisLetter;
  Number: String;
begin
  inherited;
  if not AppModule.User.CheckLetterNumber(ID_ORGS_KGA, 1, edLetterKGANumber.Text, Number) then
  begin
    LetterMngr := TKisLetterMngr(AppModule.Mngrs[kmLetters]);
    Letter := LetterMngr.FindLetter(ID_ORGS_KGA, 1, Number, dtpLetterKGADate.Date, False);
    if Assigned(Letter) then
    begin
      TKisOrder(Entity).LetterId := Letter.Id;
      TKisOrder(Entity).LetterAutoGenerated := False;
      UpdateLetterInfo(Letter);
    end
    else
    begin
      MessageBox(Handle, 'Письмо с таким номером не найдено!', 'Ой...', MB_OK + MB_ICONWARNING);
      edLetterKGANumber.SetFocus;
    end;
  end
  else
  begin
    MessageBox(Handle, 'Введите номер письма!', 'Шо це такэ?', MB_OK + MB_ICONWARNING);
    edLetterKGANumber.SetFocus;
  end;
end;

procedure TKisOrderEditor.btnFindLetterMPClick(Sender: TObject);
var
  LetterMngr: TKisLetterMngr;
  Letter: TKisLetter;
  Number: String;
begin
  inherited;
  if AppModule.User.CheckLetterNumber(ID_ORGS_UGA, 1, edLetterMPNumber.Text, Number) then
  begin
    LetterMngr := TKisLetterMngr(AppModule.Mngrs[kmLetters]);
    Letter := LetterMngr.FindLetter(ID_ORGS_UGA, 1, Number, dtpLetterMPDate.Date, False);
    if Assigned(Letter) then
    begin
      TKisOrder(Entity).LetterId := Letter.Id;
      TKisOrder(Entity).LetterAutoGenerated := False;
      UpdateLetterInfo(Letter);
    end
    else
    begin
      MessageBox(Handle, 'Письмо с таким номером не найдено!', 'Ой...', MB_OK + MB_ICONWARNING);
      edLetterMPNumber.SetFocus;
    end;
  end
  else
  begin
    MessageBox(Handle, 'Введите номер письма!', 'Шо це такэ?', MB_OK + MB_ICONWARNING);
    edLetterMPNumber.SetFocus;
  end;
end;

procedure TKisOrderEditor.btnOkClick(Sender: TObject);
//var
//  Answer: Integer;
begin
  {$IFNDEF ORDER_WITHOUT_LETTER}
  if TKisOrder(Entity).Letterid = 0 then
  begin
//    Answer := MessageBox(Handle,
    MessageBox(Handle,
      'Заказ не связан с входящим письмом!' + #13#10,
//      'Сохранить как есть?' + #13#10 +
//      '(Нет - перейти к выбору входящего письма)',
      'Внимание',
//      MB_YESNO + MB_ICONQUESTION
      MB_OK + MB_ICONWARNING
    );
//    if Answer = ID_NO then
    begin
      PageControl.ActivePage := tshLetter;
      edLetterMPNumber.SetFocus;
      Exit;
    end;
  end;
  {$ENDIF}
  inherited;     //клик на ОК в форме редактирования заказа
end;

function TKisOrderEditor.CanAdd: Boolean;
var
  Order: TKisOrder;
begin
  Order := TKisOrder(Entity);
  Result := (not Order.ReadOnly) and (not Order.Closed);
end;

function TKisOrderEditor.CanEdit: Boolean;
var
  Order: TKisOrder;
begin
  Order := TKisOrder(Entity);
  Result := (not Order.ReadOnly) and (not Order.Closed);
end;

procedure TKisOrderEditor.ClearLetterInfo;
begin
  cbLetterOffice.ItemIndex := -1;
  cbLetterDocType.ItemIndex := -1;
  edLetterFirmName.Clear;
  mLetterContent.Clear;
  edLetterExecutedInfo.Clear;
  cbLetterObjectType.ItemIndex := -1;
  //
  btnFindLetterKGA.Enabled := True;
  btnFindLetterMP.Enabled := True;
  btnLetterSelect.Enabled := True;
  btnLetterClear.Enabled := True;
end;

procedure TKisOrderEditor.edValPeriodKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if not (Key in (NumberChars + [#8])) then
    Key := #0;
end;

procedure TKisOrderEditor.edPayDateKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if not (Key in (NumberChars + [#8, '.'])) then
    Key := #0;
end;

procedure TKisOrderEditor.edOrderDateKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if not (Key in (NumberChars + [#8, '.'])) then
    Key := #0;
end;

procedure TKisOrderEditor.edDocDateKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if not (Key in (NumberChars + [#8, '.'])) then
    Key := #0;
end;

procedure TKisOrderEditor.edActDateKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if not (Key in (NumberChars + [#8, '.'])) then
    Key := #0;
end;

procedure TKisOrderEditor.dbgPositionsColEnter(Sender: TObject);
begin
  inherited;
  dbgPositions.ReadOnly := dbgPositions.SelectedField.FieldName = SF_PRINTED;
  if dbgPositions.ReadOnly then
     dbgPositions.Options := dbgPositions.Options - [dgEditing]
  else
     dbgPositions.Options := dbgPositions.Options + [dgEditing]
end;

procedure TKisOrderEditor.dbgPositionsExit(Sender: TObject);
begin
  inherited;
  if dbgPositions.DataSource.DataSet.State in [dsEdit, dsInsert] then
    dbgPositions.DataSource.DataSet.Post;
end;

procedure TKisOrderEditor.FormShow(Sender: TObject);
begin
  inherited;
  AppModule.ReadGridProperties(Self, dbgPositions);
  PageControl.ActivePageIndex := 0;
  //
  btnDeleteMap.Enabled := (dsMaps.DataSet.RecordCount > 0) and CanEdit;
  dsMaps.DataSet.Last;
  dsMaps.DataSet.First;
end;

procedure TKisOrderEditor.UpdateLetterInfo(aLetter: TKisEntity);
var
  TheLetter: TKisLetter;
  aDate: TDateTime;
begin
  if not Assigned(aLetter) then
    ClearLetterInfo
  else
  begin
    TheLetter := TKisLetter(aLetter);
    //
    if cbLetterOffice.Items.Count = 0 then
      cbLetterOffice.Items.Assign(AppModule.Lists[klOffices].Forget().Persistent());
    ComboLocate(cbLetterOffice, TheLetter.OfficesId);
    //
    if cbLetterDocType.Items.Count = 0 then
      cbLetterDocType.Items.Assign(AppModule.DocTypeList(AppModule.User.OrgId, 1).Forget().Persistent());
    ComboLocate(cbLetterDocType, TheLetter.DocTypesId);
    //
    edLetterFirmName.Text := TheLetter.FirmName;
    mLetterContent.Text := TheLetter.Content;
    edLetterExecutedInfo.Text := TheLetter.ExecuteInfo;
    cbLetterObjectType.ItemIndex := TheLetter.ObjectTypeId;
    edLetterMPNumber.Text := TheLetter.MPNumber;
    edLetterKGANumber.Text := TheLetter.DocNumber;
    if TryStrToDate(TheLetter.MPDate, aDate) then
      dtpLetterMPDate.Date := aDate;
    if TryStrToDate(TheLetter.DocDate, aDate) then
      dtpLetterKGADate.Date := aDate;
    //
    btnFindLetterKGA.Enabled := not TKisOrder(Entity).LetterAutoGenerated;
    btnFindLetterMP.Enabled := not TKisOrder(Entity).LetterAutoGenerated;
    btnLetterSelect.Enabled := not TKisOrder(Entity).LetterAutoGenerated;
    btnLetterClear.Enabled := not TKisOrder(Entity).LetterAutoGenerated;
  end;
end;

procedure TKisOrderEditor.UpdateMapControls;
var
//  S: String;
//  V: Variant;
  B: Boolean;
  N: TNomenclature;
begin
  inherited;
  CloseControlAlert;
  B := CanAdd;
  if B then
  begin
    N.Init(edNomenclature.Text, False);
    B := N.Valid;
    if B then
    begin
//      if not AppModule.GetFieldValue(nil, ST_MAP_SCANS, SF_NOMENCLATURE, SF_ID, AnsiUpperCase(S), V) then
//      begin
//        ControlAlert(edNomenclature, 'Планшет не отсканирован!');
//        B := False;
//      end
//      else
      begin
        CloseControlAlert;
        B := not FindMap(N.Nomenclature());
      end;
    end;
  end;
  btnAddMap.Enabled := B;
  //
  btnDeleteMap.Enabled := CanEdit and (dsMaps.DataSet.RecordCount > 0);
end;

//действи я при закрытии формы
function TKisOrderEditor.FindMap(const Nomenclature: String): Boolean;
var
  R: Integer;
begin
  with dsMaps.DataSet do
  begin
    DisableControls;
    try
      R := RecNo;
      First;
      Result := Locate(SF_NOMENCLATURE, Nomenclature, []);
      if not Result then
        RecNo := R;
    finally
      EnableControls;
    end;
  end;
end;

procedure TKisOrderEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  AppModule.WriteGridProperties(Self, dbgPositions);
end;

end.
