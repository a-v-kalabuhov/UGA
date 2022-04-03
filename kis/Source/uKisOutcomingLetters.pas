{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Менеджер исходящей корреспонденции              }
{                                                       }
{       Copyright (c) 2004-2005, МП УГА                 }
{                                                       }
{       Автор: Сирота Е.А.                              }
{                                                       }
{*******************************************************}

{ Описание: реализует операции над исходящей корреспонденцией
  Имя модуля: OutcomingLetters
  Версия: 1.03
  Дата последнего изменения: 28.04.2005
  Цель: модуль содержит реализации классов менеджера исходящей документации
  Используется: AppModule
  Использует: Kernel Classes
  Исключения: нет }
{
  1.03          28.04.2005
     - добавлена печать отчета

  1.02          19.04.2005
     - исправлена ошибка при поиске по содержанию
  1.01          13.05.2005
     - поле FIRM увеличина до 300 знаков
  0.2
     - метод Reopen удален из-за реализации унаследованного
}

unit uKisOutcomingLetters;

interface

uses
   // System
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  DB, IBCustomDataSet, ImgList, ActnList,
  Dialogs, IBSQL, IBDatabase, IBQuery,
  // Common
   uGC, uIBXUtils, uDataSet, uSQLParsers,
  // Project
  uKisClasses, uKisSQLClasses, uKisEntityEditor, uKisUtils, uKisFilters;

type
  TkisLetterSupplement = class(TKisEntity)
  private
    FKind: String;
    FDocProducerName: String;
    FNumber: String;
    FDocDate: String;
    FContent: String;
    procedure SetKind(const Value: String);
    procedure SetDocProducerName(const Value: String);
    procedure SetNumber(const Value: String);
    procedure SetDocDate(const Value: String);
    procedure SetContent(const Value: String);
  protected
  public
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    procedure Load(DataSet: TDataSet); override;
    property Kind: String read FKind write SetKind;
    property DocProducerName: String read FDocProducerName write SetDocProducerName;
    property Number: String read FNumber write SetNumber;
    property DocDate: String read FDocDate write SetDocDate;
    property Content: String read FContent write SetContent;
  end;

  TLetterSupplementCtrlr = class(TKisEntityController)
  public
    procedure FillFieldDefs(FieldDefsRef: TFieldDefs); override;
    function GetFieldData(Index: Integer; Field: TField; out Data): Boolean; override;
    procedure SetFieldData(Index: Integer; Field: TField; var Data); override;
  end;


  //связь входящего и исходящего писем
  TkisLettersLink = class(TKisEntity)
  private
    FDocDate: String;
    FDocNumber: String;
    FIncomLetterId: Integer;
    FDateMP: String;
    FNumberMP: String;
    procedure SetIncomLetterId(const Value: Integer);
    procedure SetDocNumber(const Value: String);
    procedure SetDocDate(const Value: String);
    procedure SetDateMP(const Value: String);
    procedure SetNumberMP(const Value: String);
  protected
  public
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    procedure Load(DataSet: TDataSet); override;
    property IncomLetterId: Integer read FIncomLetterId write SetIncomLetterId;
    property DocNumber: String read FDocNumber write SetDocNumber;
    property DocDate: String read FDocDate write SetDocDate;
    property DateMP: String read FDateMP write SetDateMP;
    property NumberMP: String read FNumberMP write SetNumberMP;
  end;

  TLettersLinkCtrlr = class(TKisEntityController)
  public
    procedure FillFieldDefs(FieldDefsRef: TFieldDefs); override;
    function GetFieldData(Index: Integer; Field: TField; out Data): Boolean; override;
    procedure SetFieldData(Index: Integer; Field: TField; var Data); override;
    function FindId(Id: Integer): Boolean;
  end;


  TkisOutcomingLetter = class(TKisSQLEntity)
  private
    FLetterSupplementCtrlr: TLetterSupplementCtrlr;
    FLetterSupplement: TCustomDataSet;
    FLettersLinkCtrlr: TLettersLinkCtrlr;
    FLettersLink: TCustomDataSet;
    FDelivered: Boolean;
    FNotification: Boolean;
    FFirmId: Integer;
    FPeopleId: Integer;
    FOfficeID: Integer;
    FKind: Integer;
    FContent: String;
    FNumber: String;
    FSeqNumber: String;
    FFirm: String;
    FDateReg: TDate;
    FDeliveredDate: TDate;
    FOrgsId: Integer;
    FAddress: String;
    FIsIncomLetter: Boolean;
    procedure SetContent(const Value: String);
    procedure SetDateReg(const Value: TDate);
    procedure SetDelivered(const Value: Boolean);
    procedure SetDeliveredDate(const Value: TDate);
    procedure SetFirm(const Value: String);
    procedure SetFirmId(const Value: Integer);
    procedure SetKind(const Value: Integer);
    procedure SetNotification(const Value: Boolean);
    procedure SetNumber(const Value: String);
    procedure SetSeqNumber(const Value: String);
    procedure SetOfficeID(const Value: Integer);
    procedure SetPeopleId(const Value: Integer);
    procedure SetOrgsId(const Value: Integer);
    procedure SetAddress(const Value: String);
    procedure LoadPeopleList(Sender: TObject);
    procedure SelectFirm(Sender: TObject);
    procedure SelectIncomLetter(Sender: TObject);
    procedure ShowIncomLetter(Sender: TObject);
    procedure ClearFirm(Sender: TObject);
    procedure UpdateFirm;
    // Access methods for datasets
    function GetLetterSupplement: TDataSet;
    function GetLettersLink: TDataSet;
    // Event handlers for editor
    // LetterSupplement
    procedure LetterSupplementInsert(DataSet: TDataSet);
    procedure LetterSupplementBeforeDelete(DataSet: TDataSet);
    procedure LettersLinkBeforeDelete(DataSet: TDataSet);

    //LettersLink

    function DataSetEquals(DS1, DS2: TCustomDataSet): Boolean;
  protected
    function CreateEditor: TKisEntityEditor; override;
    procedure PrepareEditor(Editor: TKisEntityEditor); override;
    procedure UnprepareEditor(Editor: TKisEntityEditor); override;
    procedure LoadDataIntoEditor(Editor: TKisEntityEditor); override;
    procedure ReadDataFromEditor(Editor: TKisEntityEditor); override;
    function CheckEditor(Editor: TKisEntityEditor): Boolean; override;
  public
    constructor Create(Mngr: TKisMngr); override;
    destructor Destroy; override;
    function IsEmpty: Boolean; override;
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    procedure Load(DataSet: TDataSet); override;
    function Equals(Entity: TKisEntity): Boolean; override;
    property Kind: Integer read FKind write SetKind;
    property Number: String read FNumber write SetNumber;
    property SeqNumber: String read FSeqNumber write SetSeqNumber;
    property DateReg: TDate read FDateReg write SetDateReg;
    property OfficeID: Integer read FOfficeID write SetOfficeID;
    property PeopleId: Integer read FPeopleId write SetPeopleId;
    property Address: String read FAddress write SetAddress;
    property FirmId: Integer read FFirmId write SetFirmId;
    property Firm: String read FFirm write SetFirm;
    property Content: String read FContent write SetContent;
    property Notification: Boolean read FNotification write SetNotification;
    property Delivered: Boolean read FDelivered write SetDelivered;
    property DeliveredDate: TDate read FDeliveredDate write SetDeliveredDate;
    property OrgsId: Integer read FOrgsId write SetOrgsId;
    property LetterSupplement: TDataSet read GetLetterSupplement;
    property LettersLink: TDataSet read GetLettersLink;
    property LettersLinkCtrlr: TLettersLinkCtrlr read FLettersLinkCtrlr;
    property IsIncomLetter: Boolean read FIsIncomLetter write FIsIncomLetter;
  end;

  TkisOutcomingLetterMngr = class(TKisSQLMngr)
    dsOutcomingLetter: TIBDataSet;
    dsOutcomingLetterID: TIntegerField;
    dsOutcomingLetterDELIVERED: TSmallintField;
    dsOutcomingLetterNOTIFICATION: TSmallintField;
    dsOutcomingLetterKIND: TIntegerField;
    dsOutcomingLetterNUMBER: TIBStringField;
    dsOutcomingLetterDATE_REG: TDateField;
    dsOutcomingLetterFIRM: TIBStringField;
    dsOutcomingLetterDELIVERED_DATE: TDateField;
    dsOutcomingLetterFIRM_ID: TIntegerField;
    dsOutcomingLetterPEOPLE_ID: TIntegerField;
    dsOutcomingLetterOFFICE_ID: TIntegerField;
    dsOutcomingLetterORGS_ID: TIntegerField;
    dsOutcomingLetterDOC_TYPES_NAME: TStringField;
    dsOutcomingLetterOFFICE_NAME: TStringField;
    dsOutcomingLetterPEOPLE_NAME: TStringField;
    dsOutcomingLetterCONTENT: TStringField;
    dsOutcomingLetterSEQ_NUMBER: TStringField;
    dsOutcomingLetterADDRESS: TStringField;
    Action4: TAction;
    procedure acEditExecute(Sender: TObject); override;
    procedure acInsertUpdate(Sender: TObject);
    procedure acEditUpdate(Sender: TObject);
    procedure dsOutcomingLetterNOTIFICATIONGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure acInsertExecute(Sender: TObject);
    procedure Action4Execute(Sender: TObject);
  private
    procedure SaveOutcomingLetter(OutcomLetter: TKisEntity);
    procedure SaveLetterSupplement(LetterSuppl: TKisEntity);
    procedure SaveLettersLink(LetLink: TKisEntity);
  protected
    procedure ApplyFilters(aFilters: IKisFilters; ClearExisting: Boolean); override;
    procedure CreateView; override;
    function GenEntityID(EntityKind: TKisEntities = keDefault): Integer; override;
    procedure Activate; override;
    procedure Deactivate; override;
    function IsSupported(Entity: TKisEntity): Boolean; override;
    function GetIdent: TKisMngrs; override;
    function GetMainSQLText: String; override;
    function GetRefreshSQLText: String; override;
    function GetMainDataSet: TDataSet; override;
    procedure PrepareSQLHelper; override;
    procedure Locate(AId: Integer; LocateFail: Boolean = False); override;
    procedure CloseView(Sender: TObject; var Action: TCloseAction); override;
    procedure ReadViewState; override;
    procedure WriteViewState; override;
    function ProcessSQLFilter(aFilter: IKisFilter;
      TheOperation: TKisFilterOperation; Clause: TWhereClause): Boolean; override;
  public
    function GetEntity(EntityID: Integer; EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function CreateNewEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    procedure SaveEntity(Entity: TKisEntity); override;
    procedure DeleteEntity(Entity: TKisEntity); override;
    function IsEntityInUse(Entity: TKisEntity): Boolean; override;
    function CreateEntity(EntityKind: TKisEntities): TKisEntity; override;
    function CurrentEntity: TKisEntity; override;
    procedure EditCurrent; override;
    function EditEntity(Entity: TKisEntity): TKisEntity; override;
  end;

implementation

{$R *.dfm}

uses
  // Common
  // Project
  uKisAppModule, uKisConsts, uKisOutcomingLetterEditor, uKisLetters, uKisIntf,
  uKisLetterEditor, uKisPrintModule, uKisSearchClasses, uKisExceptions;

resourcestring
  // Fields
 //SF_FIRM = 'FIRM';
  // Generators
  SG_OUTCOMING_LETTER = 'OUTCOMING_LETTERS';
  SG_LETTER_SUPPLEMENT = 'LETTER_SUPPLEMENT';
  SG_LETTERS_LINK = 'LETTERS_LINK';
  // Queries
  SQ_MAIN = 'SELECT L.ID, L.DELIVERED, L.NOTIFICATION, L.KIND, L.CONTENT, '
            + 'L.NUMBER, L.SEQ_NUMBER, L.DATE_REG, L.FIRM, L.DELIVERED_DATE, '
            + 'L.FIRMS_ID, L.OFFICES_ID, L.PEOPLE_ID, L.ORGS_ID, L.ADDRESS, '
            + 'DT.NAME AS DOC_TYPES_NAME, '
            + 'O.NAME AS OFFICE_NAME, P.INITIAL_NAME AS PEOPLE_NAME '
            + 'FROM OUTCOMING_LETTERS L '
            + 'LEFT JOIN DOC_TYPES DT ON (L.ORGS_ID=DT.ORGS_ID AND L.KIND=DT.ID) '
            + 'LEFT JOIN OFFICES O ON L.OFFICES_ID=O.ID '
            + 'LEFT JOIN PEOPLE P ON L.PEOPLE_ID=P.ID';
  SQ_SELECT_OUTCOMING_LETTER = 'SELECT * FROM OUTCOMING_LETTERS WHERE ID=%d';
  SQ_DELETE_OUTCOMING_LETTER = 'DELETE FROM OUTCOMING_LETTERS WHERE ID=%d';
  SQ_OUTCOMING_LETTER_IN_USE = 'SELECT COUNT(INCOMLETTER_ID) FROM LETTERS_LINK WHERE OUTCOMLETTER_ID=%d';
  SQ_SAVE_OUTCOMING_LETTER = 'EXECUTE PROCEDURE SAVE_OUTCOMING_LETTERS(:ID, :KIND, :NUMBER, :SEQ_NUMBER, :FIRM, :CONTENT, :NOTIFICATION, :DELIVERED, :DELIVERED_DATE, :DATE_REG, :ORGS_ID, :OFFICES_ID, :FIRMS_ID, :PEOPLE_ID, :ADDRESS)';
  SQ_SAVE_LETTERS_LINK = 'EXECUTE PROCEDURE SAVE_LETTERS_LINK(:ID, :INCOMLETTER_ID, :OUTCOMLETTER_ID)';
  //SQ_OUTCOMING_LETTER_WHERE = 'WHERE OUTCOMING_LETTER_ID=%d ORDER BY ID';
  SQ_GET_LETTER_SUPPLEMENT_ID = 'SELECT ID FROM LETTER_SUPPLEMENT WHERE OUTCOMING_LETTER_ID=%d ORDER BY ID'; //+ SQ_OUTCOMING_LETTER_WHERE;
  SQ_GET_LETTERS_LINK_ID = 'SELECT ID FROM LETTERS_LINK WHERE OUTCOMLETTER_ID=%d ORDER BY ID';
  SQ_SELECT_LETTER_SUPPLEMENT = 'SELECT * FROM LETTER_SUPPLEMENT WHERE ID=%d';
  SQ_SELECT_LETTERS_LINK = //'SELECT * FROM LETTERS_LINK WHERE ID=%d';
    'SELECT LL.ID, LL.INCOMLETTER_ID, L.DOC_NUMBER, L.DOC_DATE, L.MP_NUMBER, L.MP_DATE FROM LETTERS_LINK LL, LETTERS L WHERE LL.ID = %d AND LL.INCOMLETTER_ID = L.ID';
  SQ_SAVE_LETTER_SUPPLEMENT = 'EXECUTE PROCEDURE SAVE_LETTER_SUPPLEMENT(:ID, :OUTCOMING_LETTER_ID, :KIND, :DOC_PRODUCER_NAME, :NUMBER, :DOC_DATE, :CONTENT)';
  SQ_CLEAR_LETTER_SUPPLEMENT = 'DELETE FROM LETTER_SUPPLEMENT WHERE OUTCOMING_LETTER_ID=%d';
  SQ_CLEAR_LETTERS_LINK = 'DELETE FROM LETTERS_LINK WHERE OUTCOMLETTER_ID=%d';

{ TKisContragentAdressMngr }


{ TkisOutcomingLetter }

function TkisOutcomingLetter.CheckEditor(
  Editor: TKisEntityEditor): Boolean;

  procedure SetFocusTo(Control: TWinControl);
  begin
      with Editor as TKisOutcomingLetterEditor do
      begin
        PageControl1.ActivePageIndex := 0;
        Control.SetFocus;
      end;
  end;

var
  D: TDateTime;
  P1, P2: Integer;
begin
  Result := False;
  if Editor is TKisOutcomingLetterEditor then
    with Editor as TKisOutcomingLetterEditor do
    begin
      if (edDateReg.Text = '') or not TryStrToDate(edDateReg.Text, D) or
            ((D > Date) or (D < MIN_DOC_DATE)) then
          begin
            AppModule.Alert(S_CHECK_DATE_REG);
            SetFocusTo(edDateReg);
            Exit;
          end;
      if (Length(Trim(edNumber.Text)) = 0) then
      begin
        AppModule.Alert(S_CHECK_MP_LETTER_NUMBER);
        SetFocusTo(edNumber);
        Exit;
      end;
      if cbOffice.ItemIndex < 0 then
      begin
        AppModule.Alert(S_CHECK_LETTER_OFFICE_NAME);
        SetFocusTo(cbOffice);
        Exit;
      end;
      if cbPeople.ItemIndex < 0 then
      begin
        AppModule.Alert(S_CHECK_PEOPLE_NAME);
        SetFocusTo(cbPeople);
        Exit;
      end;
      if (Length(Trim(edFirm.Text)) = 0)
         or BadFirmName(Trim(edFirm.Text), P1, P2) then
      begin
        AppModule.Alert(S_CHECK_FIRM);
        SetFocusTo(edFirm);
        edFirm.SelStart := P1;
        edFirm.SelLength := Succ(P2 - P1);
        Exit;
      end;
      if edDeliveredDate.Text <> '' then
      begin
        if not TryStrToDate(edDeliveredDate.Text, D) or
              ((D > Date) or (D < MIN_DOC_DATE)) then
            begin
              AppModule.Alert(S_CHECK_DELIVERED_DATE);
              SetFocusTo(edDeliveredDate);
              Exit;
            end;
      end;
  end;
  Result := True;
end;

procedure TkisOutcomingLetter.ClearFirm(Sender: TObject);
begin
  FirmId := -1;
  Firm := '';
  UpdateFirm;
end;

procedure TkisOutcomingLetter.Copy(Source: TKisEntity);
var
  I: Integer;
begin
  inherited;
  with Source as TkisOutcomingLetter do
  begin
      Self.FDelivered := FDelivered;
      Self.FNotification := FNotification;
      Self.FFirmId := FFirmId;
      Self.FPeopleId := FPeopleId;
      Self.FOfficeID := FOfficeID;
      Self.FKind := FKind;
      Self.FContent := FContent;
      Self.FNumber := FNumber;
      Self.SeqNumber := FSeqNumber;
      Self.FFirm := FFirm;
      Self.FDateReg := FDateReg;
      Self.FDeliveredDate := FDeliveredDate;
      Self.FOrgsId := FOrgsId;
      Self.FAddress := FAddress;
      //копируем документы-приложения
      Self.FLetterSupplementCtrlr.DirectClear;
      LetterSupplement.First;
      while not LetterSupplement.Eof do
      begin
        Self.LetterSupplement.Append;
        for I := 0 to Pred(Self.LetterSupplement.FieldCount) do
          Self.LetterSupplement.Fields[I].Value := LetterSupplement.Fields[I].Value;
        Self.LetterSupplement.Post;
        LetterSupplement.Next;
      end;
      //копируем входящие письма
      Self.FLettersLinkCtrlr.DirectClear;
      LettersLink.First;
      while not LettersLink.Eof do
      begin
        Self.LettersLink.Append;
        for I := 0 to Pred(Self.LettersLink.FieldCount) do
          Self.LettersLink.Fields[I].Value := LettersLink.Fields[I].Value;
        Self.LettersLink.Post;
        LettersLink.Next;
      end;
  end;
end;

constructor TkisOutcomingLetter.Create(Mngr: TKisMngr);
begin
  inherited;
  FLetterSupplementCtrlr := TLetterSupplementCtrlr.CreateController(Mngr, Mngr, keLetterSupplement);
  FLetterSupplementCtrlr.HeadEntity := Self;
  FLetterSupplement := TCustomDataSet.Create(Mngr);
  FLetterSupplement.Controller := FLetterSupplementCtrlr;
  FLetterSupplement.Open;
  FLetterSupplement.First;

  FLettersLinkCtrlr := TLettersLinkCtrlr.CreateController(Mngr, Mngr, keLettersLink);
  FLettersLinkCtrlr.HeadEntity := Self;
  FLettersLink := TCustomDataSet.Create(Mngr);
  FLettersLink.Controller := FLettersLinkCtrlr;
  FLettersLink.Open;
  FLettersLink.First;
end;

function TkisOutcomingLetter.CreateEditor: TKisEntityEditor;
begin
  Result := TKisOutcomingLetterEditor.Create(Application);
end;

function TkisOutcomingLetter.DataSetEquals(DS1,
  DS2: TCustomDataSet): Boolean;
var
  I: Integer;
begin
  Result := DS1.RecordCount = DS2.RecordCount;
  if Result then
  begin
    for I := 1 to DS1.RecordCount do
    begin
      Result := TKisEntityController(DS1.Controller).Elements[I].Equals(TKisEntityController(DS2.Controller).Elements[I]);
      if not Result then
        Exit;
    end;
  end;
end;

destructor TkisOutcomingLetter.Destroy;
begin
  FLetterSupplement.Close;
  FLetterSupplement.Free;
  FLetterSupplementCtrlr.Free;

  FLettersLink.Close;
  FLettersLink.Free;
  FLettersLinkCtrlr.Free;
  inherited;
end;

class function TkisOutcomingLetter.EntityName: String;
begin
  Result := SEN_OUTCOMING_LETTER;
end;

function TkisOutcomingLetter.Equals(Entity: TKisEntity): Boolean;
begin
  inherited Equals(Entity);
  with Entity as TkisOutcomingLetter do
  begin
    Result := (Self.FDelivered = FDelivered) and (Self.FNotification = FNotification)
      and (Self.FFirmId = FFirmId) and (Self.FPeopleId = FPeopleId)
      and (Self.FOfficeID = FOfficeID) and (Self.FKind = FKind)
      and (Self.FContent = FContent) and (Self.FNumber = FNumber)
      and (Self.FSeqNumber = FSeqNumber) and (Self.FFirm = FFirm)
      and (Self.FDateReg = FDateReg) and (Self.FDeliveredDate = FDeliveredDate)
      and (Self.FOrgsId = FOrgsId) and (Self.FAddress = FAddress);
    if Result then
      Result := Result and DataSetEquals(Self.FLetterSupplement, FLetterSupplement);
    if Result then
      Result := Result and DataSetEquals(Self.FLettersLink, FLettersLink);
  end;
end;

function TkisOutcomingLetter.GetLettersLink: TDataSet;
begin
  Result := FLettersLink;
end;

function TkisOutcomingLetter.GetLetterSupplement: TDataSet;
begin
  Result := FLetterSupplement;
end;

function TkisOutcomingLetter.IsEmpty: Boolean;
begin
  Result := (FFirmId = N_ZERO) and (FPeopleId = N_ZERO)
    and (FOfficeID = N_ZERO) and (FContent = '')
    and (FNumber = '') and (FFirm = '')
    and (FSeqNumber = '') and (FDateReg = 0)
    and (FDeliveredDate = 0) and (FAddress = '')
    and LetterSupplement.IsEmpty
    and LettersLink.IsEmpty
end;

procedure TkisOutcomingLetter.LettersLinkBeforeDelete(DataSet: TDataSet);
begin
  if DataSet.IsEmpty then
    Abort;
  if MessageBox(EntityEditor.Handle, PChar(S_CONFIRM_DELETE_INCOMLETTER), PChar(S_CONFIRM),
    MB_YESNO + MB_ICONQUESTION) <> ID_YES then
    Abort;
end;

procedure TkisOutcomingLetter.LetterSupplementBeforeDelete(
  DataSet: TDataSet);
begin
  if DataSet.IsEmpty then
    Abort;
  if MessageBox(EntityEditor.Handle, PChar(S_CONFIRM_DELETE_SUPPLEMENT), PChar(S_CONFIRM),
    MB_YESNO + MB_ICONQUESTION) <> ID_YES then
    Abort;
end;

procedure TkisOutcomingLetter.LetterSupplementInsert(DataSet: TDataSet);
begin
  TKisLetterSupplement(FLetterSupplementCtrlr.Elements[0]).DocDate := FormatDateTime(S_DATESTR_FORMAT, Date);
end;

procedure TKisOutcomingLetter.Load(DataSet: TDataSet);
var
  Tmp: TKisEntity;
  NeedTransaction: Boolean;
  aQuery: TIBQuery;
begin
  inherited;
  with DataSet do
  begin
    Self.ID := FieldByName(SF_ID).AsInteger;
    Self.FDelivered := Boolean(FieldByName(SF_DELIVERED).AsInteger);
    Self.FNotification := Boolean(FieldByName(SF_NOTIFICATION).AsInteger);
    Self.FFirmId := FieldByName(SF_FIRMS_ID).AsInteger;
    Self.FFirm := FieldByName(SF_FIRM).AsString;
    Self.FPeopleId := FieldByName(SF_PEOPLE_ID).AsInteger;
    Self.FOfficeID := FieldByName(SF_OFFICES_ID).AsInteger;
    Self.FKind := FieldByName(SF_KIND).AsInteger;
    Self.FContent := FieldByName(SF_CONTENT).AsString;
    Self.FNumber := FieldByName(SF_NUMBER).AsString;
    Self.FSeqNumber := FieldByName(SF_SEQ_NUMBER).AsString;
    Self.FDateReg := FieldByName(SF_DATE_REG).AsDateTime;
    Self.FDeliveredDate := FieldByName(SF_DELIVERED_DATE).AsDateTime;
    Self.FOrgsId := FieldByName(SF_ORGS_ID).AsInteger;
    Self.FAddress := FieldByName(SF_ADDRESS).AsString;
  end;
  Assert(True, 'Переделать код загрузки письма!!!');
  NeedTransaction := not Assigned(SQLMngr.DefaultTransaction);
  aQuery := TIBQuery.Create(nil);
  aQuery.Forget;
  with aQuery do
  try
    if NeedTransaction then
    begin
      Transaction := AppModule.Pool.Get;
      Transaction.Init(ilReadCommited, amReadOnly);
      Transaction.StartTransaction;
      SQLMngr.DefaultTransaction := Transaction;
    end
    else
      Transaction := SQLMngr.DefaultTransaction;
    //грузим документы-приложения
    BufferChunks := 10;
    SQL.Text := Format(SQ_GET_LETTER_SUPPLEMENT_ID, [Self.ID]);
    Open;
    FetchAll;
    while not Eof do
    begin
      Tmp := Manager.GetEntity(FieldByName(SF_ID).AsInteger, keLetterSupplement);
      if Assigned(Tmp) then
        Self.FLetterSupplementCtrlr.DirectAppend(Tmp);
      Next;
    end;
    Close;
   //грузим входящие документы
    SQL.Text := Format(SQ_GET_LETTERS_LINK_ID, [Self.ID]);
    Open;
    FetchAll;
    while not Eof do
    begin
      Tmp := Manager.GetEntity(FieldByName(SF_ID).AsInteger, keLettersLink);
      if Assigned(Tmp) then
        Self.FLettersLinkCtrlr.DirectAppend(Tmp);
      Next;
    end;
    Close;
  finally
    if NeedTransaction then
    begin
      SQLMngr.DefaultTransaction := nil;
      Transaction.Commit;
      AppModule.Pool.Back(Transaction);
    end;
  end;
end;

procedure TkisOutcomingLetter.LoadDataIntoEditor(Editor: TKisEntityEditor);
begin
  with Editor as TKisOutcomingLetterEditor do
  begin
    cbKind.ItemIndex := Kind;
    ComboLocate(cbKind, Kind);
//    cbOffice.ItemIndex := OfficeId;
    ComboLocate(cbOffice, OfficeId);
    LoadPeopleList(nil);
//    cbPeople.ItemIndex := PeopleId;
    ComboLocate(cbPeople, PeopleId);
    if Length(Number) > N_ZERO then
      edNumber.Text := Number;
    if Length(SeqNumber) > N_ZERO then
      edSeqNumber.Text := SeqNumber;
    if DateReg > N_ZERO then
      edDateReg.Text := DateToStr(DateReg);
    mContent.Text := Content;
    cbNotification.Checked := Boolean(Notification);
    cbDelivered.Checked := Boolean(Delivered);
    if DeliveredDate > N_ZERO then
      edDeliveredDate.Text := DateToStr(DeliveredDate);
    edFirm.Text := Firm;
    edAddress.Text := Address;
  end;
end;

procedure TkisOutcomingLetter.LoadPeopleList(Sender: TObject);
var
  P: Integer;
begin
  with EntityEditor as TKisOutcomingLetterEditor do
  begin
    if cbOffice.ItemIndex < 0 then
      cbPeople.Items.Clear
    else
    begin
      P := Integer(cbOffice.Items.Objects[cbOffice.ItemIndex]);
      cbPeople.Items.Assign(IObject(AppModule.PeolpeList(P)).AObject as TStrings);
    end;
  end;
end;

procedure TkisOutcomingLetter.PrepareEditor(Editor: TKisEntityEditor);
begin
  inherited;
  with Editor as TKisOutcomingLetterEditor do
  begin
    cbKind.Items.Assign(IObject(AppModule.DocTypeList(Self.FOrgsId, 0)).AObject as TStrings);
    cbOffice.Items.Assign(IObject(AppModule.OfficesList(Self.FOrgsId)).AObject as TStrings);
    cbPeople.Items.Assign(IObject(AppModule.PeolpeList(Self.FOfficeId)).AObject as TStrings);
    cbOffice.OnChange := LoadPeopleList;
    btnSelectFirm.OnClick := SelectFirm;
    btnLinkSelect.OnClick := SelectIncomLetter;
    btnLinkDetail.OnClick := ShowIncomLetter;
    btnFirmClear.OnClick := ClearFirm;

    dsLetterSupplement.DataSet := FLetterSupplement;
    FLetterSupplement.AfterInsert := LetterSupplementInsert;
    FLetterSupplement.BeforeDelete := LetterSupplementBeforeDelete;
    FLetterSupplement.Refresh;
    //dbgLetterSupplement.DataSource.DataSet := FLetterSupplement;

    dsLettersLink.DataSet := FLettersLink;
    //FLettersLink.AfterInsert := LettersLinkInsert;
    FLettersLink.BeforeDelete := LettersLinkBeforeDelete;
    FLettersLink.Refresh;
    if FIsIncomLetter then
    begin
      btnLinkSelect.Enabled := False;
      btnLinkDetail.Enabled := False;
      btnLinkDelete.Enabled := False;
    end;
  end;
end;

procedure TkisOutcomingLetter.ReadDataFromEditor(Editor: TKisEntityEditor);
begin
  inherited;
  with Editor as TKisOutcomingLetterEditor do
  begin
    Kind := Integer(cbKind.Items.Objects[cbKind.ItemIndex]);
    Number := Trim(edNumber.Text);
    SeqNumber := Trim(edSeqNumber.Text);
    if Trim(edDateReg.Text) <> '' then
       DateReg := StrToDate(Trim(edDateReg.Text))
    else
       DateReg := 0;
    Content := Trim(mContent.Text);
    Address := Trim(edAddress.Text);
    Notification := cbNotification.Checked;
    Delivered := cbDelivered.Checked;
    if Trim(edDeliveredDate.Text) <> '' then
       DeliveredDate := StrToDate(Trim(edDeliveredDate.Text))
    else
       DeliveredDate := 0;
    if cbOffice.ItemIndex < 0 then
      OfficeId := N_ZERO
    else
      OfficeId := Integer(cbOffice.Items.Objects[cbOffice.ItemIndex]);
    if cbPeople.ItemIndex < 0 then
      PeopleId := 0
    else
      PeopleId := Integer(cbPeople.Items.Objects[cbPeople.ItemIndex]);
    Firm := Trim(edFirm.Text);
  end;
end;

procedure TkisOutcomingLetter.SelectFirm(Sender: TObject);
var
  Id: Integer;
begin
  if FFirmId > 0 then
    Id := FFirmId
  else
    Id := -1;
  with AppModule.SQLMngrs[kmFirms] do
    with KisObject(SelectEntity(False, nil, False, Id)) do
      if Assigned(AEntity) then
      begin
        FirmId := AEntity.ID;
        Firm := AEntity[SF_NAME].AsString;
      end;
  UpdateFirm;
end;

procedure TkisOutcomingLetter.SelectIncomLetter(Sender: TObject);
var
  Ent: TKisLetter;
begin
  LettersLink.Append;
  with AppModule.SQLMngrs[kmLetters] do
    Ent := TKisLetter(KisObject(SelectEntity(False, nil, False)).AEntity);
  if Assigned(Ent) then
    begin
      if not FLettersLinkCtrlr.FindId(Ent.ID) then
      begin
        LettersLink.FieldByName(SF_INCOMLETTER_ID).AsInteger := Ent.ID;
        LettersLink.FieldByName(SF_DOC_NUMBER).AsString := Ent.DocNumber;
        LettersLink.FieldByName(SF_DOC_DATE).AsString := Ent.DocDate;
        LettersLink.FieldByName(SF_MP_NUMBER).AsString := Ent.MPNumber;
        LettersLink.FieldByName(SF_MP_DATE).AsString := Ent.MPDate;
        LettersLink.Post;
      end
      else
      begin
        MessageBox(Self.EntityEditor.Handle, PChar(S_LETTER_INCOM_ADD_AGAIN), PChar(S_WARN), MB_OK + MB_ICONWARNING);
        LettersLink.Cancel;
      end
    end
  else
    LettersLink.Cancel;
end;

procedure TkisOutcomingLetter.SetAddress(const Value: String);
begin
  if FAddress <> Value then
  begin
    FAddress := Value;
    Modified := True;
  end;
end;

procedure TkisOutcomingLetter.SetContent(const Value: String);
begin
  if FContent <> Value then
  begin
    FContent := Value;
    Modified := True;
  end;
end;

procedure TkisOutcomingLetter.SetDateReg(const Value: TDate);
begin
  if FDateReg <> Value then
  begin
    FDateReg := Value;
    Modified := True;
  end;
end;

procedure TkisOutcomingLetter.SetDelivered(const Value: Boolean);
begin
  if FDelivered <> Value then
  begin
    FDelivered := Value;
    Modified := True;
  end;
end;

procedure TkisOutcomingLetter.SetDeliveredDate(const Value: TDate);
begin
  if FDeliveredDate <> Value then
  begin
    FDeliveredDate := Value;
    Modified := True;
  end;
end;

procedure TkisOutcomingLetter.SetFirm(const Value: String);
begin
  if FFirm <> Value then
  begin
    FFirm := Value;
    Modified := True;
  end;
end;

procedure TkisOutcomingLetter.SetFirmId(const Value: Integer);
begin
  if FFirmId <> Value then
  begin
    FFirmId := Value;
    Modified := True;
  end;
end;

procedure TkisOutcomingLetter.SetKind(const Value: Integer);
begin
  if FKind <> Value then
  begin
    FKind := Value;
    Modified := True;
  end;
end;

procedure TkisOutcomingLetter.SetNotification(const Value: Boolean);
begin
  if FNotification <> Value then
  begin
    FNotification := Value;
    Modified := True;
  end;
end;

procedure TkisOutcomingLetter.SetNumber(const Value: String);
begin
  if FNumber <> Value then
  begin
    FNumber := Value;
    Modified := True;
  end;
end;

procedure TkisOutcomingLetter.SetOfficeID(const Value: Integer);
begin
  if FOfficeID <> Value then
  begin
    FOfficeID := Value;
    Modified := True;
  end;
end;

procedure TkisOutcomingLetter.SetOrgsId(const Value: Integer);
begin
  if FOrgsId <> Value then
  begin
    FOrgsId := Value;
    Modified := True;
  end;
end;

procedure TkisOutcomingLetter.SetPeopleId(const Value: Integer);
begin
  if FPeopleId <> Value then
  begin
    FPeopleId := Value;
    Modified := True;
  end;
end;

procedure TkisOutcomingLetter.SetSeqNumber(const Value: String);
begin
  if FSeqNumber <> Value then
  begin
    FSeqNumber := Value;
    Modified := True;
  end;
end;

procedure TkisOutcomingLetter.ShowIncomLetter(Sender: TObject);
Var
  LetId: Integer;
begin
  LetId := LettersLink.FieldByName(SF_INCOMLETTER_ID).AsInteger;
  if LetId > 0 then
  begin
    if Assigned(SQLMngr.DefaultTransaction) then
      AppModule.SQLMngrs[kmLetters].DefaultTransaction := SQLMngr.DefaultTransaction;
    with KisObject(AppModule.Mngrs[kmLetters].GetEntity(LetId)) do
    if Assigned(AEntity) then
      with AEntity as TKisVisualEntity do
      begin
        ReadOnly := True;
        Edit;
      end;
    if Assigned(SQLMngr.DefaultTransaction) then
      AppModule.SQLMngrs[kmLetters].DefaultTransaction := nil;
  end;
end;

procedure TkisOutcomingLetter.UnprepareEditor(Editor: TKisEntityEditor);
begin
  with Editor as TKisOutcomingLetterEditor do
  begin
    dsLetterSupplement.DataSet := nil;
    FLetterSupplement.AfterInsert := nil;
    FLetterSupplement.BeforeDelete := nil;

    dsLettersLink.DataSet := nil;
    //FLettersLink.AfterInsert := nil;
    FLettersLink.BeforeDelete := nil;
  end;
  inherited;
end;

procedure TkisOutcomingLetter.UpdateFirm;
begin
  if Assigned(EntityEditor) then
  with EntityEditor as TKisOutcomingLetterEditor do
  begin
    edFirm.Text := Self.Firm;
  end;
end;

{ TkisOutcomingLetterMngr }

procedure TKisOutcomingLetterMngr.Activate;
begin
  inherited;
  dsOutcomingLetter.Transaction := AppModule.Pool.Get;
  dsOutcomingLetter.Transaction.Init();
  dsOutcomingLetter.Transaction.AutoStopAction := saNone;
  Reopen;
end;

procedure TKisOutcomingLetterMngr.Deactivate;
begin
  inherited;
  dsOutcomingLetter.Close;
  if not dsOutcomingLetter.Transaction.Active then
     dsOutcomingLetter.Transaction.Commit;
  AppModule.Pool.Back(dsOutcomingLetter.Transaction);
end;

function TkisOutcomingLetterMngr.CreateEntity(
  EntityKind: TKisEntities): TKisEntity;
begin
  case EntityKind of
  keDefault, keOutcomingLetter :
    begin
      Result := TKisOutcomingLetter.Create(Self);
    end;
  keLetterSupplement :
    begin
      Result := TKisLetterSupplement.Create(Self);
    end;
  keLettersLink :
    begin
      Result := TKisLettersLink.Create(Self);
    end;
  else
    Result := nil;
  end;
end;

function TkisOutcomingLetterMngr.CreateNewEntity(
  EntityKind: TKisEntities): TKisEntity;
begin
  case EntityKind of
  keDefault, keOutcomingLetter :
    Result := TKisOutcomingLetter.Create(Self);
  keLetterSupplement :
    Result := TKisLetterSupplement.Create(Self);
  keLettersLink :
    Result := TKisLettersLink.Create(Self);
  else
    raise Exception.Create(S_CANT_CREATE_NEW_ENTITY);
  end;
  Result.ID := Self.GenEntityID(EntityKind);
end;

procedure TkisOutcomingLetterMngr.DeleteEntity(Entity: TKisEntity);
var
  Conn: IKisConnection;
begin
  Conn := nil;
  if IsEntityInUse(Entity) then
    inherited
  else
  try
    Conn := GetConnection(True, True);
    Conn.GetDataSet(Format(SQ_DELETE_OUTCOMING_LETTER, [Entity.ID])).Open;
    FreeCOnnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

function TkisOutcomingLetterMngr.GenEntityID(
  EntityKind: TKisEntities): Integer;
begin
  case EntityKind of
    keDefault, keOutcomingLetter :
      Result := AppModule.GetID(SG_OUTCOMING_LETTER, Self.DefaultTransaction);
    keLetterSupplement :
      Result := AppModule.GetID(SG_LETTER_SUPPLEMENT, Self.DefaultTransaction);
    keLettersLink :
      Result := AppModule.GetID(SG_LETTERS_LINK, Self.DefaultTransaction);
  else
    Result := -1;
  end;
end;

function TkisOutcomingLetterMngr.GetEntity(EntityID: Integer;
  EntityKind: TKisEntities): TKisEntity;
var
  dataSet: TDataSet;
  QueryText: String;
  Conn: IKisConnection;
begin
  Result := nil;
  Conn := GetConnection(True, False);
  try
    case EntityKind of
    keDefault, keOutcomingLetter :
      QueryText := Format(SQ_SELECT_OUTCOMING_LETTER, [EntityID]);
    keLetterSupplement :
      QueryText := Format(SQ_SELECT_LETTER_SUPPLEMENT, [EntityID]);
    keLettersLink :
      QueryText := Format(SQ_SELECT_LETTERS_LINK, [EntityID]);
    else
      raise ELoadEntity.Create(EntityID, EntityKind);
    end;
    DataSet := Conn.GetDataSet(QueryText);
    DataSet.Open;
      if not DataSet.IsEmpty then
      begin
        Result := CreateEntity(EntityKind);
        Result.Load(DataSet);
      end;
    DataSet.Close;
  finally
    FreeConnection(Conn, True);
  end;
end;

function TkisOutcomingLetterMngr.GetIdent: TKisMngrs;
begin
  Result := kmOutcomingLetters;
end;

function TkisOutcomingLetterMngr.GetMainSQLText: String;
begin
  Result := SQ_MAIN;
end;

function TkisOutcomingLetterMngr.IsEntityInUse(
  Entity: TKisEntity): Boolean;
var
  T: TIBTransaction;
  OldState, Needback: Boolean;
begin
  Needback := not Assigned(Self.DefaultTransaction);
  if Needback then
  begin
    T := AppModule.Pool.Get;
    T.Init();
  end
  else
    T := Self.DefaultTransaction;
  OldState := T.Active;
  if not OldState then
    T.StartTransaction;
  try
    with IObject(TIBSQL.Create(Self)).AObject as TIBSQL do
    begin
      Transaction := T;
      SQL.Text := Format(SQ_OUTCOMING_LETTER_IN_USE, [Entity.ID]);
      ExecQuery;
      Result := Fields[N_ZERO].Asinteger > N_ZERO;
      Close;
    end;
  finally
    if not OldState then
      T.Commit;
    if Needback then
    begin
      AppModule.Pool.Back(T);
    end;
  end;
end;

function TkisOutcomingLetterMngr.IsSupported(Entity: TKisEntity): Boolean;
begin
  Result := Assigned(Entity)
    and ((Entity is TKisOutcomingLetter)
         or (Entity is TKisLetterSupplement)
         or (Entity is TKisLettersLink)
         );
  if not Result then
    inherited IsSupported(Entity);
  //Result := Assigned(Entity) and (Entity is TKisOutcomingLetter);
  //if not Result then
    //Result := inherited IsSupported(Entity);
end;

procedure TkisOutcomingLetterMngr.SaveEntity(Entity: TKisEntity);
begin
  inherited;
  try
    if Assigned(Entity) then
    if IsSupported(Entity) then
    if (Entity is TKisOutcomingLetter) then
         SaveOutcomingLetter(Entity)
    else
       if (Entity is TKisLetterSupplement) then
        SaveLetterSupplement(Entity)
      else
         if (Entity is TKisLettersLink) then
           SaveLettersLink(Entity)
  except
    //on E: EKisOutcomingLetterError do
      //HandleKisOutcomingLetterError(E, Entity);
    raise;
  end;
end;

procedure TkisOutcomingLetterMngr.PrepareSQLHelper;
begin
  inherited;
  with FSQLHelper do
  begin
    with AddTable do
    begin
      TableName := ST_OUTCOMING_LETTERS;
      TableLabel := 'Основная (Исходящая корреспонденция)';
      AddStringField(SF_SEQ_NUMBER, 'Порядковый номер',20, [fpSearch, fpSort, fpQuickSearch]);
      AddStringField(SF_NUMBER, 'Номер МП', 20, [fpSearch, fpSort, fpQuickSearch]);
      AddSimpleField(SF_DATE_REG, 'Дата регистрации', ftDate, [fpSearch, fpSort]);
      AddStringField(SF_FIRM, 'Получатель письма', 300, [fpSearch, fpSort, fpQuickSearch]);
      AddStringField(SF_ADDRESS, 'Адрес, по которому отправлено письмо',420, [fpSearch, fpSort, fpQuickSearch]);
      AddStringField(SF_CONTENT, 'Содержание', 1000, [fpSearch, fpSort, fpQuickSearch]);
      AddSimpleField(SF_KIND, 'Тип письма', ftInteger, [fpSearch, fpSort]);
      AddSimpleField(SF_NOTIFICATION, 'C уведомлением', ftBoolean, [fpSearch, fpSort]);
      AddSimpleField(SF_DELIVERED, 'Уведомление получено', ftBoolean, [fpSearch, fpSort]);
      AddSimpleField(SF_DELIVERED_DATE, 'Дата уведомления', ftDate, [fpSearch, fpSort]);
      AddSimpleField(SF_ID, 'Порядок ввода', ftInteger, [fpSort]);
    end;
    with AddTable do
    begin
      TableName := ST_OFFICES;
      TableLabel := 'Отделы';
      AddStringField(SF_NAME, 'Отдел', 80, [fpSearch, fpSort, fpQuickSearch]);
    end;
    with AddTable do
    begin
      TableName := ST_PEOPLE;
      TableLabel := 'Отправители';
      AddStringField(SF_INITIAL_NAME, 'Исполнитель', 50, [fpSearch, fpSort, fpQuickSearch]);
    end;
  end;
end;

function TkisOutcomingLetterMngr.ProcessSQLFilter(aFilter: IKisFilter;
  TheOperation: TKisFilterOperation; Clause: TWhereClause): Boolean;
var
  FltrName: string;
  Condition: TSQLCondition;
begin
  Result := False;
  FltrName := (aFilter as IKisNamedObject).Name;
  if TheOperation = foAddSQL then
  begin
    if (FltrName = SF_ORGS_ID) then
    begin
      if (aFilter.Value > 0) then
      begin
        Condition := TSQLCondition.Create;
        Condition.Text := 'L.ORGS_ID=' + VarToStr(aFilter.Value);
        if Clause.PartCount = 0 then
          Condition.TheOperator := coNone
        else
          Condition.TheOperator := coAnd;
        Condition.Comment := FltrName;
        Clause.AddCondition(Condition);
      end;
      Result := True;
    end;
  end;
  if not Result then
    Result := inherited ProcessSQLFilter(aFilter, TheOperation, Clause);
end;

procedure TkisOutcomingLetterMngr.Locate(AId: Integer; LocateFail: Boolean = False);
begin
  inherited;
  if dsOutcomingLetter.Active then
    dsOutcomingLetter.Locate(SF_ID, AId, []);
end;

procedure TkisOutcomingLetterMngr.CreateView;
begin
  inherited;
  FView.Caption := 'Исходящие документы';
end;

function TkisOutcomingLetterMngr.CurrentEntity: TKisEntity;
begin
  Result := GetEntity(dsOutcomingLetterID.AsInteger, keOutcomingLetter);
end;

procedure TkisOutcomingLetterMngr.acEditExecute(Sender: TObject);
begin
  Self.DefaultTransaction := dsOutcomingLetter.Transaction;
  try
    EditCurrent;
//    dsOutcomingLetter.Close;
//    dsOutcomingLetter.Open;
  except
    Self.DefaultTransaction.RollbackRetaining;
  end;
  Self.DefaultTransaction := nil
end;

procedure TkisOutcomingLetterMngr.EditCurrent;
var
  NeedRemove, NeedCommit: Boolean;
begin
  NeedCommit := False;
  if Assigned(dsOutcomingLetter.Transaction) then
  begin
    NeedRemove := not Assigned(Self.DefaultTransaction);
    if NeedRemove then
      Self.DefaultTransaction := dsOutcomingLetter.Transaction;
  end
  else
    raise Exception.CreateFmt(S_DEFAULT_TRANSACTION_MISSED, [Self.ClassName]);
  with KisObject(CurrentEntity) do
    if Assigned(AEntity) then
    with AEntity as TKisOutcomingLetter do
    begin
      Modified := False;
      if AppModule.User.IsAdministrator then
        ReadOnly := False
      else
        ReadOnly := (AppModule.User.OrgId <> OrgsId);// or (AppModule.User.OfficeId <> OfficeId));
      if TKisVisualEntity(AEntity).Edit and AEntity.Modified then
      begin
        SaveEntity(AEntity);
        NeedCommit := True;
      end;
    end;
  if Assigned(dsOutcomingLetter.Transaction) then
  begin
    if NeedCommit then
    begin
      Self.DefaultTransaction.CommitRetaining;
      dsOutcomingLetter.Refresh;
    end;
    if NeedRemove then
      Self.DefaultTransaction := nil;
  end;
end;

procedure TkisOutcomingLetterMngr.acInsertUpdate(Sender: TObject);
begin
//  inherited;
//  acInsert.Enabled := AppModule.User.CanDoAction(maInsert, keOutcomingLetter);
    acInsert.Enabled := Assigned(DataSource.DataSet) and DataSource.DataSet.Active
      and AppModule.User.CanDoAction(maInsert, keOutcomingLetter);
end;

procedure TkisOutcomingLetterMngr.acEditUpdate(Sender: TObject);
begin
  //inherited;
  if acEdit.Enabled then
    acEdit.Enabled := AppModule.User.CanDoAction(maEdit, keOutcomingLetter);
end;

procedure TkisOutcomingLetterMngr.dsOutcomingLetterNOTIFICATIONGetText(
  Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := GetBoolText(Sender);
end;

procedure TkisOutcomingLetterMngr.acInsertExecute(Sender: TObject);
begin
//  inherited;
  with KisObject(CreateNewEntity(keOutcomingLetter)) do
  begin
    with AEntity as TKisOutcomingLetter do
    begin
      OrgsId := AppModule.User.OrgId;
      DateReg := Date;
      SeqNumber := AppModule.User.GenerateOutcomingLetterSeqNumber;
      Modified := False;
      if Edit and Modified then
      begin
        SaveEntity(AEntity);
        Reopen;
        Locate(AEntity.ID);
      end;
    end;
  end;
end;

procedure TkisOutcomingLetterMngr.SaveLetterSupplement(
  LetterSuppl: TKisEntity);
var
  Conn: IKisConnection;
  aQuery: TIBQuery;
begin
  Conn := GetConnection(True, True);
  aQuery := TIBQuery.Create(nil);
  aQuery.Forget;
  with LetterSuppl as TKisLetterSupplement do
    with aQuery do
    try
      BufferChunks := 10;
      Transaction := Conn.Transaction;
      SQL.Text := SQ_SAVE_LETTER_SUPPLEMENT;
      if LetterSuppl.ID < 1 then
        LetterSuppl.ID := Self.GenEntityID(keLetterSupplement);
      Params[0].AsInteger := ID;
      Params[1].AsInteger := HeadId;
      Params[2].AsString := Kind;
      Params[3].AsString := DocProducerName;
      Params[4].AsString := Number;
      Params[5].AsString := DocDate;
      Params[6].AsString := Content;
      ExecSQL;
      FreeConnection(Conn, True);
    except
      FreeConnection(Conn, False);
    end;
end;

procedure TkisOutcomingLetterMngr.SaveOutcomingLetter(
  OutcomLetter: TKisEntity);
var
  I: Integer;
  Conn: IKisConnection;
  aQuery: TIBQuery;
begin
  Conn := GetConnection(True, True);
  aQuery := TIBQuery.Create(nil);
  aQuery.Forget;
  with OutcomLetter as TKisOutcomingLetter do
  with aQuery do
  try
    BufferChunks := 10;
    Transaction := Conn.Transaction;
    // Сохраняем письмо
    SQL.Text := SQ_SAVE_OUTCOMING_LETTER;
    if OutcomLetter.ID < 1 then
      OutcomLetter.ID := Self.GenEntityID(keOutcomingLetter);
    ParamByName(SF_ID).AsInteger := ID;
    ParamByName('OFFICES_ID').AsInteger := OfficeId;
    ParamByName('PEOPLE_ID').AsInteger := PeopleId;
    if FirmId <= 0 then
      ParamByName('FIRMS_ID').Clear
    else
      ParamByName('FIRMS_ID').AsInteger := FirmId;
    ParamByName('ORGS_ID').AsInteger := OrgsId;
    ParamByName('DELIVERED').AsInteger := Integer(Delivered);
    ParamByName('NOTIFICATION').AsInteger := Integer(TKisOutcomingLetter(OutcomLetter).Notification);
    ParamByName('KIND').AsInteger := Kind;
    ParamByName('CONTENT').AsString := Content;
    ParamByName('NUMBER').AsString := Number;
    ParamByName('SEQ_NUMBER').AsString := SeqNumber;
    ParamByName('ADDRESS').AsString := Address;
    ParamByName('FIRM').AsString := Firm;
    if DeliveredDate <> 0 then
      ParamByName('DELIVERED_DATE').AsDate := DeliveredDate;
    if DateReg <> 0 then
      ParamByName('DATE_REG').AsDate := DateReg;
    ExecSQL;

    // Сохраняем входящие письма
    with FLettersLinkCtrlr do
    begin
      for I := 1 to Count do
        if Elements[I].Modified then
          Self.SaveEntity(Elements[I]);
      for I := 0 to Pred(DeletedCount) do
        Self.DeleteEntity(DeletedElements[I]);
    end;
    // Сохраняем документы-приложения
    with FLetterSupplementCtrlr do
    begin
      for I := 1 to Count do
        if Elements[I].Modified then
          Self.SaveEntity(Elements[I]);
      for I := 0 to Pred(DeletedCount) do
        Self.DeleteEntity(DeletedElements[I]);
    end;
    // Подтверждаем изменения
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

function TkisOutcomingLetterMngr.EditEntity(
  Entity: TKisEntity): TKisEntity;
begin
  Result := nil;
  if IsSupported(Entity) and (Entity is TKisOutcomingLetter) then
  begin
    Result := TKisOutcomingLetter.Create(Self);
    Result.Assign(Entity);
    Result.Modified := TKisOutcomingLetter(Result).Edit;
  end;
end;

procedure TkisOutcomingLetterMngr.CloseView(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;

end;

procedure TkisOutcomingLetterMngr.ReadViewState;
begin
  inherited;

end;

procedure TkisOutcomingLetterMngr.WriteViewState;
begin
  inherited;

end;

procedure TkisOutcomingLetterMngr.SaveLettersLink(LetLink: TKisEntity);
var
  Conn: IKisConnection;
  aQuery: TIBQuery;
begin
  Conn := GetConnection(True, True);
  aQuery := TIBQuery.Create(nil);
  aQuery.Forget;
  with LetLink as TKisLettersLink do
  with aQuery do
  try
    BufferChunks := 10;
    Transaction := Conn.Transaction;
    SQL.Text := SQ_SAVE_LETTERS_LINK;
    if LetLink.ID < 1 then
      LetLink.ID := Self.GenEntityID(keLettersLink);
    Params[0].AsInteger := ID;
    Params[1].AsInteger := IncomLetterId;
    Params[2].AsInteger := HeadId;
    //Params[3].AsString := DocNumber;
    //Params[4].AsString := DocDate;
    ExecSQL;
    FreeCOnnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TkisOutcomingLetterMngr.ApplyFilters;
var
  OrgId: Integer;
  S: String;
  Tmp: TKisEntity;
  Fltr: IKisFilter;
begin
  inherited;
  //
  if Assigned(FView) then
  begin
    S := '';
    Fltr := FFilters.Find(SF_ORGS_ID);
    if Assigned(Fltr) then
    begin
      OrgId := Fltr.Value;
      if OrgId <> 0 then
      begin
        Tmp := AppModule.Mngrs[kmOrgs].GetEntity(OrgId);
        if Assigned(Tmp) then
          S := Tmp.DataParams[SF_SHORT_NAME].AsString;
      end;
    end;
    if S <> '' then
      S := S + ' - Исходящие документы';
    FView.Caption := S;
  end;
end;

function TkisOutcomingLetterMngr.GetMainDataSet: TDataSet;
begin
  Result := dsOutcomingLetter;
end;

function TkisOutcomingLetterMngr.GetRefreshSQLText: String;
begin
  Result := GetMainSQLtext + ' WHERE L.ID=:ID';
end;

{ TkisLettersLink }

procedure TkisLettersLink.Copy(Source: TKisEntity);
begin
  inherited;
  with Source as TKisLettersLink do
  begin
    Self.IncomLetterId := FIncomLetterId;
    Self.DocNumber := FDocNumber;
    Self.DocDate := FDocDate;
    Self.DateMP := FDateMP;
    Self.NumberMP := FNumberMP;
  end;
end;

class function TkisLettersLink.EntityName: String;
begin

end;

procedure TkisLettersLink.Load(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    ID := FieldByName(SF_ID).AsInteger;
    IncomLetterId := FieldByName(SF_INCOMLETTER_ID).AsInteger;
    DocNumber := FieldByName(SF_DOC_NUMBER).AsString;
    DocDate := FieldByName(SF_DOC_DATE).AsString;
    NumberMP := FieldByName(SF_MP_NUMBER).AsString;
    DateMP := FieldByName(SF_MP_DATE).AsString;
    Self.Modified := True;
  end;
end;

procedure TkisLettersLink.SetDateMP(const Value: String);
begin
  if FDateMP <> Value then
  begin
    FDateMP := Value;
    Modified := True;
  end;
end;

procedure TkisLettersLink.SetDocDate(const Value: String);
begin
  if FDocDate <> Value then
  begin
    FDocDate := Value;
    Modified := True;
  end;
end;

procedure TkisLettersLink.SetDocNumber(const Value: String);
begin
  if FDocNumber <> Value then
  begin
    FDocNumber := Value;
    Modified := True;
  end;
end;

procedure TkisLettersLink.SetIncomLetterId(const Value: Integer);
begin
  if FIncomLetterId <> Value then
  begin
    FIncomLetterId := Value;
    Modified := True;
  end;
end;

procedure TkisLettersLink.SetNumberMP(const Value: String);
begin
  if FNumberMP <> Value then
  begin
    FNumberMP := Value;
    Modified := True;
  end;
end;

{ TkisLetterSupplement }



procedure TkisLetterSupplement.Copy(Source: TKisEntity);
begin
  inherited;
  with Source as TKisLetterSupplement do
  begin
      Self.FKind := FKind;
      Self.FDocProducerName := FDocProducerName;
      Self.FNumber := FNumber;
      Self.FDocDate := FDocDate;
      Self.FContent := FContent;
  end;
end;

class function TkisLetterSupplement.EntityName: String;
begin
  Result := ''; 
end;

procedure TkisLetterSupplement.Load(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    ID := FieldByName(SF_ID).AsInteger;
    Kind := FieldByName(SF_KIND).AsString;
    DocProducerName := FieldByName(SF_DOC_PRODUCER_NAME).AsString;
    Number := FieldByName(SF_NUMBER).AsString;
    DocDate := FieldByName(SF_DOC_DATE).AsString;
    Content := FieldByName(SF_CONTENT).AsString;
    Self.Modified := True;
  end;
end;

procedure TkisLetterSupplement.SetContent(const Value: String);
begin
  if FContent <> Value then
  begin
    FContent := Value;
    Modified := True;
  end;
end;

procedure TkisLetterSupplement.SetDocDate(const Value: String);
begin
  if FDocDate <> Value then
  begin
    FDocDate := Value;
    Modified := True;
  end;
end;

procedure TkisLetterSupplement.SetDocProducerName(const Value: String);
begin
  if FDocProducerName <> Value then
  begin
    FDocProducerName := Value;
    Modified := True;
  end;
end;

procedure TkisLetterSupplement.SetKind(const Value: String);
begin
  if FKind <> Value then
  begin
    FKind := Value;
    Modified := True;
  end;
end;

procedure TkisLetterSupplement.SetNumber(const Value: String);
begin
  if FNumber <> Value then
  begin
    FNumber := Value;
    Modified := True;
  end;
end;

{ TLetterSupplementCtrlr }

procedure TLetterSupplementCtrlr.FillFieldDefs(FieldDefsRef: TFieldDefs);
begin
  FieldDefsRef.Clear;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 1;
    Name := SF_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 2;
    Name := SF_OUTCOMING_LETTER_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 3;
    Size := 30;
    Name := SF_KIND;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 4;
    Size := 100;
    Name := SF_DOC_PRODUCER_NAME;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 5;
    Size := 10;
    Name := SF_NUMBER;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 6;
    Size := 10;
    Name := SF_DOC_DATE;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 7;
    Name := SF_CONTENT;
    Size := 150;
  end;
end;

function TLetterSupplementCtrlr.GetFieldData(Index: Integer; Field: TField;
  out Data): Boolean;
var
  Ent: TKisLetterSupplement;
begin
  try
    Ent := TKisLetterSupplement(Elements[Index]);
    case Field.FieldNo of
    1 : GetInteger(Ent.ID, Data);
    2 : GetInteger(Ent.HeadId, Data);
    3 : GetString(Ent.Kind, Data);
    4 : GetString(Ent.DocProducerName, Data);
    5 : GetString(Ent.Number, Data);
    6 : GetString(Ent.DocDate, Data);
    7 : GetString(Ent.Content, Data);
    else
      raise EDatabaseError.CreateFmt(S_FIELD_NOT_FOUND, [Field.FieldName]);
    end;
    Result := True;
  except
    Result := False;
  end;
end;

procedure TLetterSupplementCtrlr.SetFieldData(Index: Integer;
  Field: TField; var Data);
var
  Ent: TKisLetterSupplement;
begin
  try
    Ent := TKisLetterSupplement(Elements[Index]);
    case Field.FieldNo of
    1 : Ent.ID := SetInteger(Data);
    3 : Ent.Kind := SetString(Data);
    4 : Ent.DocProducerName := SetString(Data);
    5 : Ent.Number := SetString(Data);
    6 : Ent.DocDate := SetString(Data);
    7 : Ent.Content := SetString(Data);
    end;
  except
  end;
end;

{ TLettersLinkCtrlr }

procedure TLettersLinkCtrlr.FillFieldDefs(FieldDefsRef: TFieldDefs);
begin
  FieldDefsRef.Clear;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 1;
    Name := SF_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 2;
    Name := SF_INCOMLETTER_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 3;
    Name := SF_OUTCOMLETTER_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 4;
    Size := 10;
    Name := SF_DOC_NUMBER;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 5;
    Size := 10;
    Name := SF_DOC_DATE;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 6;
    Size := 10;
    Name := SF_MP_NUMBER;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 7;
    Size := 10;
    Name := SF_MP_DATE;
  end;
end;

function TLettersLinkCtrlr.FindId(Id: Integer): Boolean;
var
  I: Integer;
begin
   Result := false;
   I := 1;
   while not Result and (I <= GetRecordCount) do
   begin
     Result := TKisLettersLink(Self.Elements[I]).IncomLetterId = Id;
     I := I + 1;
   end;
end;

function TLettersLinkCtrlr.GetFieldData(Index: Integer; Field: TField;
  out Data): Boolean;
var
  Ent: TKisLettersLink;
begin
  try
    Ent := TKisLettersLink(Elements[Index]);
    case Field.FieldNo of
    1 : GetInteger(Ent.ID, Data);
    2 : GetInteger(Ent.IncomLetterId, Data);
    3 : GetInteger(Ent.HeadId, Data);
    4 : GetString(Ent.DocNumber, Data);
    5 : GetString(Ent.DocDate, Data);
    6 : GetString(Ent.NumberMP, Data);
    7 : GetString(Ent.DateMP, Data)
    else
      raise EDatabaseError.CreateFmt(S_FIELD_NOT_FOUND, [Field.FieldName]);
    end;
    Result := True;
  except
    Result := False;
  end;
end;

procedure TLettersLinkCtrlr.SetFieldData(Index: Integer; Field: TField;
  var Data);
var
  Ent: TKisLettersLink;
begin
  try
    Ent := TKisLettersLink(Elements[Index]);
    case Field.FieldNo of
    1 : Ent.ID := SetInteger(Data);
    2 : Ent.IncomLetterId := SetInteger(Data);
    4 : Ent.DocNumber := SetString(Data);
    5 : Ent.DocDate := SetString(Data);
    6 : Ent.NumberMP := SetString(Data);
    7 : Ent.DateMP := SetString(Data);
    end;
  except
  end;
end;

procedure TkisOutcomingLetterMngr.Action4Execute(Sender: TObject);
var
  RepName: String;
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, False);
  try
    with Conn.GetDataSet(Format(SQ_GET_REPORTS_FILES, [RT_OUTCOMING_LETTERS])) do
    begin
      Open;
      if not IsEmpty then
        RepName := AppModule.ReportsPath + Fields[0].AsString
      else
        Exit;
      Close;
    end;
    with PrintModule(True) do
    begin
      ReportFile := RepName;
      SetMasterDataSet(dsOutcomingLetter, 'MasterData');
      PrintReport;
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

end.
