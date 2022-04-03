{*************************************************************}
{                                                             }
{       "ИС МП УГА"                                           }
{       Менеджер регистрации и учета архивных документов      }
{       постановлений                                         }
{                                                             }
{       Copyright (c) 2005, МП УГА                            }
{                                                             }
{       Автор: Сирота Е.А.                                    }
{                                                             }
{*************************************************************}

{ Описание: реализует операции над архивными документами
  Имя модуля: ArchivalDocuments
  Версия: 1.01
  Дата последнего изменения: 24.08.2005
  Цель: модуль содержит реализации классов менеджера архивных документов
  Используется: AppModule
  Использует: Kernel Classes
  Исключения: нет }

{
  1.01       24.08.2005
    - вся работа с БД переведена на TKisConnection

  1.00       24.06.2005
    - начальная версия}

unit uKisArchivalDocsMngr;

{$I KisFlags.pas}

interface

uses
  // system
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  DB, IBCustomDataSet, ImgList, ActnList, Grids, Dialogs, IBDatabase, DateUtils,
  // Common
  uGC, uIBXUtils, uDataSet,
  // Project
  uKisClasses, uKisSQLClasses, uKisEntityEditor, uKisUtils;

type

  TKisArchDocMove = class(TKisVisualEntity)
  private
    FArchivalDocId: Integer;
    FDateOfGive: String;
    FTerm: Integer;
    FDateOfBack: String;
    FOfficeName: String;
    FExecutor: String;
    FPeopleId: Integer;
    FOrderNumber: String;
    FOrderAccount: String;
    FOrderDocLink: Integer;
    FOfficeId: Integer;
    FOrdersId: Integer;
    FIsEndMove: Boolean;
    procedure SetArchivalDocId(const Value: Integer);
    procedure SetDateOfGive(const Value: String);
    procedure SetTerm(const Value: Integer);
    procedure SetDateOfBack(const Value: String);
    procedure SetOfficeName(const Value: String);
    procedure SetExecutor(const Value: String);
    procedure SetOrderNumber(const Value: String);
    procedure SetOrderAccount(const Value: String);
    procedure SetOrderDocLink(const Value: Integer);
    procedure SetOfficeId(const Value: Integer);
    procedure SetOrdersId(const Value: Integer);
    procedure LoadPeopleList(Sender: TObject);
    procedure SetPeopleId(const Value: Integer);
  protected
    function CreateEditor: TKisEntityEditor; override;
    procedure PrepareEditor(AEditor: TKisEntityEditor); override;
    procedure LoadDataIntoEditor(AEditor: TKisEntityEditor); override;
    procedure ReadDataFromEditor(AEditor: TKisEntityEditor); override;
    function CheckEditor(AEditor: TKisEntityEditor): Boolean; override;
  public
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    procedure Load(DataSet: TDataSet); override;
    procedure SetDocOrderLink;
    // Движение закончено, т.е. документ возвращен в архив
    function IsClosed: Boolean;
    // Прием документа в архив
    function EndMove: Boolean;

    property ArchivalDocId: Integer read FArchivalDocId write SetArchivalDocId;
    property DateOfGive: String read FDateOfGive write SetDateOfGive;
    property Term: Integer read FTerm write SetTerm;
    property DateOfBack: String read FDateOfBack write SetDateOfBack;
    property OfficeName: String read FOfficeName write SetOfficeName;
    property Executor: String read FExecutor write SetExecutor;
    property OrderNumber: String read FOrderNumber write SetOrderNumber;
    property OrderAccount: String read FOrderAccount write SetOrderAccount;
    property OrderDocLink: Integer read FOrderDocLink write SetOrderDocLink;
    property OfficeId: Integer read FOfficeId write SetOfficeId;
    property OrdersId: Integer read FOrdersId write SetOrdersId;
    property PeopleId: Integer read FPeopleId write SetPeopleId;
  end;

  TArchDocMovesCtrlr = class(TKisEntityController)
  private
    function GetLast: TKisArchDocMove;
  public
    procedure FillFieldDefs(FieldDefsRef: TFieldDefs); override;
    function GetDeleteQueryText: String; override;
    function GetFieldData(Index: Integer; Field: TField; out Data): Boolean; override;
    procedure SetFieldData(Index: Integer; Field: TField; var Data); override;
    property LastMove: TKisArchDocMove read GetLast;
  end;

  TKisArchivalDoc = class(TKisVisualEntity)
  private
    FDocMovesCtrlr: TArchDocMovesCtrlr;
    FDocMoves: TCustomDataSet;
    FNumber: String;
    FShelveDate: TDate;
    FObjectName: String;
    FAddress: String;
    FBasis: String;
    FStatus: Boolean;
    FComment: String;
    FFirm: String;
    FFirmId: Integer;
    FLicensedOrgId: Integer;
    FDocTypeId: Integer;
    FLicensedOrgName: String;
    procedure SetNumber(const Value: String);
    procedure SetShelveDate(const Value: TDate);
    procedure SetObjectName(const Value: String);
    procedure SetAddress(const Value: String);
    procedure SetBasis(const Value: String);
    procedure SetStatus(const Value: Boolean);
    procedure SetComment(const Value: String);
    procedure SetFirm(const Value: String);
    procedure SetFirmId(const Value: Integer);
    procedure SetLicensedOrgId(const Value: Integer);
    procedure SetDocTypeId(const Value: Integer);
    procedure SetLicensedOrgName(const Value: String);

    function GetMoves: TDataSet;
    function DataSetEquals(DS1, DS2: TCustomDataSet): Boolean;
    procedure SelectFirm(Sender: TObject);
    procedure ClearFirm(Sender: TObject);
    procedure UpdateFirm;
    procedure ChangeStatus;
    procedure SelectOrg(Sender: TObject);
    procedure ClearOrg(Sender: TObject);

    procedure MovesAfterInsert(DataSet: TDataSet);
    procedure MovesBeforeDelete(DataSet: TDataSet);
    procedure MovesAfterEdit(DataSet: TDataSet);
    procedure MovesAfterScroll(DataSet: TDataSet);

    function CanGiveOut: Boolean;
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
    procedure Copy(Source: TKisEntity); override;
    function Equals(Entity: TKisEntity): Boolean; override;
    class function EntityName: String; override;
    function IsEmpty: Boolean; override;
    procedure Load(DataSet: TDataSet); override;
    procedure GiveOutDocument;
    procedure GiveBackDocument;
    property Number: String read FNumber write SetNumber;
    property ShelveDate: TDate read FShelveDate write SetShelveDate;
    property ObjectName: String read FObjectName write SetObjectName;
    property Address: String read FAddress write SetAddress;
    property Basis: String read FBasis write SetBasis;
    property Status: Boolean read FStatus write SetStatus;
    property Comment: String read FComment write SetComment;
    property Firm: String read FFirm write SetFirm;
    property FirmId: Integer read FFirmId write SetFirmId;
    property LicensedOrgId: Integer read FLicensedOrgId write SetLicensedOrgId;
    property DocTypeId: Integer read FDocTypeId write SetDocTypeId;
    property LicensedOrgName: String read FLicensedOrgName write SetLicensedOrgName;
    property Moves: TDataSet read GetMoves;

  end;

  TKisArchivalDocsMngr = class(TKisSQLMngr)
    dsArchivalDocs: TIBDataSet;
    dsArchivalDocsID: TIntegerField;
    dsArchivalDocsARCH_NUMBER: TStringField;
    dsArchivalDocsOBJECT_NAME: TStringField;
    dsArchivalDocsADDRESS: TStringField;
    dsArchivalDocsBASIS: TStringField;
    dsArchivalDocsCOMMENT: TStringField;
    dsArchivalDocsFIRMS_ID: TIntegerField;
    dsArchivalDocsLICENSED_ORGS_ID: TIntegerField;
    dsArchivalDocsARCH_DOC_TYPES_ID: TIntegerField;
    dsArchivalDocsDOC_TYPE: TStringField;
    dsArchivalDocsFIRM_NAME: TStringField;
    dsArchivalDocsLICENSED_ORG: TStringField;
    dsArchivalDocsSHELVE_DATE: TDateField;
    acBackDocument: TAction;
    acGiveDocument: TAction;
    dsArchivalDocsSTATUS: TSmallintField;
    procedure acGiveDocumentExecute(Sender: TObject);
    procedure acBackDocumentExecute(Sender: TObject);
    procedure acGiveDocumentUpdate(Sender: TObject);
    procedure acBackDocumentUpdate(Sender: TObject);
  private
    procedure SaveArchivalDoc(ArchDoc: TKisArchivalDoc);
    procedure SaveArchivalDocMove(aMove: TKisArchDocMove);
    procedure SaveArchivalDocMoveList(ArchivalDoc: TKisArchivalDoc);
    procedure GetList(ArchDoc: TKisEntity);
    function FindOrder(DocList: TKisEntity; out OrderDate: TDateTime; out OrderId: Integer): Boolean;
    procedure GridCellColors(Sender: TObject; Field: TField;
      var Background, FontColor: TColor; State: TGridDrawState; var FontStyle:TFontStyles);
  protected
    procedure Activate; override;
    procedure CreateView; override;
    procedure Deactivate; override;
    function GenEntityID(EntityKind: TKisEntities = keDefault): Integer; override;
    function GetIdent: TKisMngrs; override;
    function GetRefreshSQLText: String; override;
    function GetMainDataSet: TDataSet; override;
    function GetMainSQLText: String; override;
    function IsSupported(Entity: TKisEntity): Boolean; override;
    procedure PrepareSQLHelper; override;
  public
    function CreateEntity(EntityKind: TKisEntities): TKisEntity; override;
    function CreateNewEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function CurrentEntity: TKisEntity; override;
    procedure DeleteEntity(Entity: TKisEntity); override;
    function GetEntity(EntityID: Integer; EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function IsEntityInUse(Entity: TKisEntity): Boolean; override;
    procedure SaveEntity(Entity: TKisEntity); override;
  end;

implementation

{$R *.dfm}

uses
  // Common
  uSQLParsers,
  // Project
  uKisAppModule, uKisConsts, uKisArchivalDocsEditor, uKisGivenDocListEditor,
  uKisLicensedOrgs, uKisIntf, uKisSearchClasses, uKisExceptions;

resourcestring
  // Generators
  SG_ARCHIVAL_DOCS = 'ARCHIVAL_DOCS';
  SG_GIVEN_DOC_LIST = 'GIVEN_ARCHIVAL_DOCS_LIST';

  // Queries
  SQ_MAIN = 'SELECT AD.ID, AD.ARCH_NUMBER, AD.SHELVE_DATE, AD.OBJECT_NAME, '
            + 'AD.ADDRESS, AD.BASIS, AD.STATUS, AD.COMMENT, AD.FIRM, AD.FIRMS_ID, AD.LICENSED_ORGS_ID, AD.ARCH_DOC_TYPES_ID, '
            + 'L.NAME AS LICENSED_ORG, '
            + 'DT.NAME AS DOC_TYPE '
            + 'FROM ARCHIVAL_DOCS AD '
            + 'LEFT JOIN FIRMS F ON AD.FIRMS_ID=F.ID '
            + 'LEFT JOIN LICENSED_ORGS L ON AD.LICENSED_ORGS_ID=L.ID '
            + 'LEFT JOIN ARCHIVAL_DOC_TYPES DT ON AD.ARCH_DOC_TYPES_ID=DT.ID';
  SQ_SELECT_ARCHIVAL_DOCS =  'SELECT AD.ID, AD.ARCH_NUMBER, AD.SHELVE_DATE, AD.OBJECT_NAME, '
                             + 'AD.ADDRESS, AD.BASIS, AD.STATUS, AD.COMMENT, AD.FIRM, AD.FIRMS_ID, AD.LICENSED_ORGS_ID, AD.ARCH_DOC_TYPES_ID, '
                             + 'L.NAME AS LICENSED_ORG '
                             + 'FROM ARCHIVAL_DOCS AD '
                             + 'LEFT JOIN LICENSED_ORGS L ON AD.LICENSED_ORGS_ID=L.ID '
                             + 'WHERE AD.ID=%d';
  SQ_SELECT_GIVEN_ARCH_DOC_LIST = 'SELECT * FROM GIVEN_ARCHIVAL_DOCS_LIST WHERE ID=%d';
  SQ_DELETE_ARCHIVAL_DOCS = 'DELETE FROM ARCHIVAL_DOCS WHERE ID=%d';
  SQ_GET_GIVEN_DOC_LIST_ID = 'SELECT ID FROM GIVEN_ARCHIVAL_DOCS_LIST WHERE ARCHIVAL_DOC_ID=%d ORDER BY ID';
  SQ_SAVE_ARCHIVAL_DOC = 'EXECUTE PROCEDURE SAVE_ARCHIVAL_DOCS(:ID, :ARCH_NUMBER, :SHELVE_DATE, :OBJECT_NAME, :ADDRESS, :BASIS, :STATUS, :COMMENT, :FIRM, :FIRMS_ID, :LICENSED_ORGS_ID, :ARCH_DOC_TYPES_ID)';
  SQ_SAVE_ARCHIVAL_DOCS_LIST = 'EXECUTE PROCEDURE SAVE_GIVEN_ARCHIVAL_DOCS_LIST(:ID, :ARCHIVAL_DOC_ID, :DATE_OF_BACK, :DATE_OF_GIVE, :PEOPLE_NAME, :OFFICE_NAME, :ORDER_ACCOUNT, :ORDER_GIVEN_DOC_LINK, :ORDER_NUMBER, :"TERM", :OFFICES_ID, :ORDERS_ID, :PEOPLE_ID)';
  SQ_CLEAR_ARCH_DOCS_LIST = 'DELETE FROM GIVEN_ARCHIVAL_DOCS_LIST WHERE ARCHIVAL_DOC_ID=%d';
  SQ_FIND_ORDER = 'SELECT ID, ORDER_DATE FROM ORDERS_ALL WHERE OFFICES_ID=%d AND ORDER_NUMBER=%s AND DOC_NUMBER=%s';

{ TkisArchivalDocs }

function TKisArchivalDoc.GetMoves: TDataSet;
begin
  Result := FDocMoves;
end;

function TKisArchivalDoc.CreateEditor: TKisEntityEditor;
begin
  Result := TKisArchivalDocsEditor.Create(Application);
end;

procedure TKisArchivalDoc.Copy(Source: TKisEntity);
begin
  inherited;
  with Source as TKisArchivalDoc do
  begin
    Self.FNumber := FNumber;
    Self.FShelveDate := FShelveDate;
    Self.FObjectName := FObjectName;
    Self.FAddress := FAddress;
    Self.FBasis := FBasis;
    Self.FStatus := FStatus;
    Self.FComment := FComment;
    Self.FFirmId := FFirmId;
    Self.FLicensedOrgId := FLicensedOrgId;
    Self.FDocTypeId := FDocTypeId;
    Self.FLicensedOrgName := FLicensedOrgName;
    //копируем список выдачи документа
    Self.FDocMovesCtrlr.DirectClear;
    CopyDataSet(Moves, Self.Moves);
  end;
end;

constructor TKisArchivalDoc.Create(Mngr: TKisMngr);
begin
  inherited;
  FDocMovesCtrlr := TArchDocMovesCtrlr.CreateController(Mngr, Mngr, keArchDocMove);
  FDocMovesCtrlr.HeadEntity := Self;
  FDocMoves := TCustomDataSet.Create(Mngr);
  FDocMoves.Controller := FDocMovesCtrlr;
  FDocMoves.Open;
  FDocMoves.First;
end;

function TKisArchivalDoc.DataSetEquals(DS1,
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

destructor TKisArchivalDoc.Destroy;
begin
  FDocMoves.Close;
  FDocMoves.Free;
  FDocMovesCtrlr.Free;
  inherited;
end;


function TKisArchivalDoc.Equals(Entity: TKisEntity): Boolean;
begin
  inherited Equals(Entity);
  with Entity as TKisArchivalDoc do
  begin
    Result :=
      (Self.FNumber = FNumber)
      and (Self.FShelveDate = FShelveDate)
      and (Self.FObjectName = FObjectName)
      and (Self.FAddress = FAddress)
      and (Self.FBasis = FBasis)
      and (Self.FStatus = FStatus)
      and (Self.FComment = FComment)
      and (Self.FFirmId = FFirmId)
      and (Self.FLicensedOrgId = FLicensedOrgId)
      and (Self.FDocTypeId = FDocTypeId);
    if Result then
      Result := Result and DataSetEquals(Self.FDocMoves, FDocMoves);
  end;
end;

function TKisArchivalDoc.IsEmpty: Boolean;
begin
  Result :=
    (FNumber = '')
    and (FShelveDate = N_ZERO)
    and (FObjectName = '')
    and (FAddress = '')
    and (FBasis = '')
    and (FComment = '')
    and (FFirmId = N_ZERO)
    and (FLicensedOrgId = N_ZERO)
    and (FDocTypeId = N_ZERO)
    and Moves.IsEmpty;
end;


procedure TKisArchivalDoc.Load(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    Self.ID := FieldByName(SF_ID).AsInteger;
    Self.FAddress := FieldByName(SF_ADDRESS).AsString;
    Self.FBasis := FieldByName(SF_BASIS).AsString;
    Self.FComment := FieldByName(SF_COMMENT).AsString;
    Self.FDocTypeId := FieldByName(SF_ARCH_DOC_TYPE_ID).AsInteger;
    Self.FFirm := FieldByName(SF_FIRM).AsString;
    Self.FFirmId := FieldByName(SF_FIRMS_ID).AsInteger;
    Self.FLicensedOrgId := FieldByName(SF_LICENSED_ORGS_ID).AsInteger;
    Self.FNumber := FieldByName(SF_ARCH_NUMBER).AsString;
    Self.FObjectName := FieldByName(SF_OBJECT_NAME).AsString;
    Self.FShelveDate := FieldByName(SF_SHELVE_DATE).AsDateTime;
    Self.FStatus := Boolean(FieldByName(SF_STATUS).AsInteger);
    Self.FLicensedOrgName := FieldByName(SF_LICENSED_ORG).AsString;
  end;
  //грузим список выдачи документа
  TKisArchivalDocsMngr(Manager).GetList(Self);
end;

procedure TKisArchivalDoc.SetAddress(const Value: String);
begin
  if FAddress <> Value then
  begin
    FAddress := Value;
    Modified := True;
  end;
end;

procedure TKisArchivalDoc.SetBasis(const Value: String);
begin
  if FBasis <> Value then
  begin
    FBasis := Value;
    Modified := True;
  end;
end;

procedure TKisArchivalDoc.SetComment(const Value: String);
begin
  if FComment <> Value then
  begin
    FComment := Value;
    Modified := True;
  end;
end;

procedure TKisArchivalDoc.SetDocTypeId(const Value: Integer);
begin
  if FDocTypeId <> Value then
  begin
    FDocTypeId := Value;
    Modified := True;
  end;
end;

procedure TKisArchivalDoc.SetFirmId(const Value: Integer);
begin
  if FFirmId <> Value then
  begin
    FFirmId := Value;
    Modified := True;
  end;
end;

procedure TKisArchivalDoc.SetLicensedOrgId(const Value: Integer);
begin
  if FLicensedOrgId <> Value then
  begin
    FLicensedOrgId := Value;
    Modified := True;
  end;
end;

procedure TKisArchivalDoc.SetNumber(const Value: String);
begin
  if FNumber <> Value then
  begin
    FNumber := Value;
    Modified := True;
  end;
end;

procedure TKisArchivalDoc.SetObjectName(const Value: String);
begin
  if FObjectName <> Value then
  begin
    FObjectName := Value;
    Modified := True;
  end;
end;

procedure TKisArchivalDoc.SetShelveDate(const Value: TDate);
begin
  if FShelveDate <> Value then
  begin
    FShelveDate := Value;
    Modified := True;
  end;
end;

procedure TKisArchivalDoc.SetStatus(const Value: Boolean);
begin
  if FStatus <> Value then
  begin
    FStatus := Value;
    Modified := True;
  end;
end;

function TKisArchivalDoc.CheckEditor(Editor: TKisEntityEditor): Boolean;
var
  D: TDateTime;
  P1, P2: Integer;
begin
  Result := False;
  if Editor is TKisArchivalDocsEditor then
    with Editor as TKisArchivalDocsEditor do
    begin
      if (Length(Trim(edArchNumber.Text)) = 0) then
      begin
        AppModule.Alert(S_CHECK_ARCH_NUMBER);
        edArchNumber.SetFocus;
        Exit;
      end;
      if (edShelveDate.Text = '') or not TryStrToDate(edShelveDate.Text, D) or
            ((D > Date) or (D < MIN_DOC_DATE)) then
          begin
            AppModule.Alert(S_CHECK_SHELVE_DATE);
            edShelveDate.SetFocus;
            Exit;
          end;
      if cbDocType.ItemIndex < 0 then
      begin
        AppModule.Alert(S_CHECK_DOCTYPE);
        cbDocType.SetFocus;
        Exit;
      end;
      if BadFirmName(Trim(edFirm.Text), P1, P2) then
      begin
        AppModule.Alert(S_CHECK_CUSTOMER);
        edFirm.SetFocus;
        edFirm.SelStart := P1;
        edFirm.SelLength := Succ(P2 - P1);
        Exit;
      end;
      if Trim(edLicensedOrg.Text) = '' then
      begin
        AppModule.Alert(S_CHECK_LICENSED_ORG);
        edLicensedOrg.SetFocus;
        Exit;
      end;
  end;
  Result := True;

end;

procedure TKisArchivalDoc.LoadDataIntoEditor(Editor: TKisEntityEditor);
begin
  with Editor as TKisArchivalDocsEditor do
  begin
    cbDocType.ItemIndex := DocTypeId;
    ComboLocate(cbDocType, DocTypeId);
    edArchNumber.Text := Number;
    if ShelveDate > N_ZERO then
      edShelveDate.Text := DateToStr(ShelveDate);
    edObjectName.Text := ObjectName;
    edAddress.Text := Address;
    edBasis.Text := Basis;
    edFirm.Text := Firm;
    edComment.Text := Comment;
    edLicensedOrg.Text := LicensedOrgName;
  end;
end;

procedure TKisArchivalDoc.PrepareEditor(Editor: TKisEntityEditor);
begin
  inherited;
  with Editor as TKisArchivalDocsEditor do
  begin
    cbDocType.Items := IStringList(AppModule.Lists[klArchDocType]).StringList;

    dsDocList.DataSet := FDocMoves;
    FDocMoves.AfterInsert := MovesAfterInsert;
    FDocMoves.AfterEdit := MovesAfterEdit;
    FDocMoves.AfterScroll := MovesAfterScroll;
    FDocMoves.BeforeDelete := MovesBeforeDelete;
    FDocMoves.First;

    btnSelectFirm.OnClick := SelectFirm;
    btnClearFirm.OnClick := ClearFirm;

    btnSelectOrg.OnClick := SelectOrg;
    btnClearOrg.OnClick := ClearOrg;

    edLicensedOrg.ReadOnly := True;
  end;
end;

procedure TKisArchivalDoc.ReadDataFromEditor(Editor: TKisEntityEditor);
begin
  inherited;
  with Editor as TKisArchivalDocsEditor do
  begin
    Address := Trim(edAddress.Text);
    Basis := Trim(edBasis.Text);
    Comment := Trim(edComment.Text);
    Firm := Trim(edFirm.Text);
    if cbDocType.ItemIndex < N_ZERO then
      DocTypeId := N_ZERO
    else
      DocTypeId := Integer(cbDocType.Items.Objects[cbDocType.ItemIndex]);
    Number := Trim(edArchNumber.Text);
    ObjectName := Trim(edObjectName.Text);
    ShelveDate := StrToDate(Trim(edShelveDate.Text));
  end;
end;

procedure TKisArchivalDoc.UnprepareEditor(Editor: TKisEntityEditor);
begin
  with Editor as TKisArchivalDocsEditor do
  begin
    dsDocList.DataSet := nil;
    FDocMoves.AfterInsert := nil;
    FDocMoves.BeforeDelete := nil;
  end;
  inherited;
end;

procedure TKisArchivalDoc.SetFirm(const Value: String);
begin
  if FFirm <> Value then
  begin
    FFirm := Value;
    Modified := True;
  end;
end;

procedure TKisArchivalDoc.ClearFirm(Sender: TObject);
begin
  FirmId := -1;
  Firm := '';
  UpdateFirm;
end;

procedure TKisArchivalDoc.SelectFirm(Sender: TObject);
var
  Id: Integer;
begin
  if Self.FFirmId > 0 then
    Id := FFirmId
  else
    Id := -1;
  with KisObject(AppModule.SQLMngrs[kmFirms].SelectEntity(False, nil, True, Id)) do
    if Assigned(AEntity) then
    begin
      FirmId := AEntity.ID;
      Firm := AEntity[SF_NAME].AsString;
    end;
  UpdateFirm;
end;

procedure TKisArchivalDoc.UpdateFirm;
begin
  if Assigned(EntityEditor) then
  with EntityEditor as TKisArchivalDocsEditor do
  begin
    edFirm.Text := Self.Firm;
  end;
end;

procedure TKisArchivalDoc.ChangeStatus;
begin
  Status := not CanGiveOut;
end;


class function TKisArchivalDoc.EntityName: String;
begin
  Result := SEN_ARCHIVAL_DOCS;
end;

procedure TKisArchivalDoc.MovesAfterInsert(DataSet: TDataSet);
begin
  // Здесь показываем редактор списка выдачи документов
  with TKisVisualEntity(FDocMovesCtrlr.TempElement) as TKisArchDocMove do
  begin
    DateOfGive := FormatDateTime(S_DATESTR_FORMAT, Date);
    Term := 1;
  end;
  if not TKisVisualEntity(FDocMovesCtrlr.TempElement).Edit then
    DataSet.Cancel
  else
  begin
    DataSet.Post;
  end;
end;

procedure TKisArchivalDoc.MovesBeforeDelete(
  DataSet: TDataSet);
begin
  if DataSet.IsEmpty then
    Abort;
  if MessageBox(EntityEditor.Handle, PChar(S_CONFIRM_DELETE_GIVEN_DOC_LIST), PChar(S_CONFIRM),
    MB_YESNO + MB_ICONQUESTION) <> ID_YES then
    Abort;
end;

procedure TKisArchivalDoc.MovesAfterEdit(DataSet: TDataSet);
begin
  if not TKisArchDocMove(FDocMovesCtrlr.TempElement).EndMove then
     Moves.Cancel
  else
     Moves.Post;
end;

procedure TKisArchDocMove.SetDocOrderLink;
var
  OrdDate: TDateTime;
  GiveDate: String;
  OrdId: Integer;
begin
    //такого заказа нет
    if not TKisArchivalDocsMngr(Manager).FindOrder(Self, OrdDate, OrdId) then
       OrderDocLink := 0
    else
      //заказ есть
      begin
        GiveDate := DateOfGive;
        //заказ есть, но его срок истек
        if MonthsBetween(StrToDate(GiveDate), OrdDate) >= 2 then
        begin
          OrderDocLink := 1;
          OrdersId := OrdId;
        end
        //заказ есть, и он не просрочен
        else
        begin
          OrderDocLink := 2;
          OrdersId := OrdId;
        end;
      end;
end;

procedure TKisArchivalDoc.ClearOrg(Sender: TObject);
begin
  LicensedOrgId := -1;
  if Assigned(EntityEditor) then
    with EntityEditor as TKisArchivalDocsEditor do
       edLicensedOrg.Text := '';
end;

procedure TKisArchivalDoc.SelectOrg(Sender: TObject);
var
  Id: Integer;
  Org: TKisLicensedOrg;
begin
  if Self.FLicensedOrgId > 0 then
    Id := FLicensedOrgId
  else
    Id := -1;
  Org := KisObject(AppModule.SQLMngrs[kmLicensedOrgs].SelectEntity(False, nil, True, Id)).AEntity as TKisLicensedOrg;
  if Assigned(Org) then
  begin
    LicensedOrgId := Org.ID;
    if Assigned(EntityEditor) then
      with EntityEditor as TKisArchivalDocsEditor do
         edLicensedOrg.Text := Org.Name;
  end;
end;

procedure TKisArchivalDoc.SetLicensedOrgName(const Value: String);
begin
  if FLicensedOrgName <> Value then
  begin
    FLicensedOrgName := Value;
    Modified := True;
  end;
end;

procedure TKisArchivalDoc.MovesAfterScroll(DataSet: TDataSet);
begin
  if Assigned(EntityEditor) then
  with EntityEditor as TKisArchivalDocsEditor do
  begin
    btnBackDoc.Enabled := not DataSet.IsEmpty and
      (DataSet.RecNo = DataSet.RecordCount) and
      DataSet.FieldByName(SF_DATE_OF_BACK).IsNull;
    btnDeleteMove.Enabled := not DataSet.IsEmpty and
      (DataSet.RecNo = DataSet.RecordCount) and
      DataSet.FieldByName(SF_DATE_OF_BACK).IsNull;
    btnAddMove.Enabled := CanGiveOut;
  end;
end;

{ TkisArchivalDocsMngr }

procedure TKisArchivalDocsMngr.Activate;
begin
  inherited;
  dsArchivalDocs.Transaction := AppModule.Pool.Get;
  dsArchivalDocs.Transaction.Init();
  dsArchivalDocs.Transaction.AutoStopAction := saNone;
  Reopen;
end;

procedure TKisArchivalDocsMngr.Deactivate;
begin
  inherited;
  dsArchivalDocs.Close;
  if not dsArchivalDocs.Transaction.Active then
    dsArchivalDocs.Transaction.Commit;
  AppModule.Pool.Back(dsArchivalDocs.Transaction);
end;

function TkisArchivalDocsMngr.GenEntityID(
EntityKind: TKisEntities): Integer;
begin
  case EntityKind of
    keDefault, keArchivalDoc :
      Result := AppModule.GetID(SG_ARCHIVAL_DOCS, Self.DefaultTransaction);
    keArchDocMove :
      Result := AppModule.GetID(SG_GIVEN_DOC_LIST, Self.DefaultTransaction);
  else
    Result := -1;
  end;
end;

function TkisArchivalDocsMngr.GetIdent: TKisMngrs;
begin
  Result := kmArchivalDocs;
end;

function TkisArchivalDocsMngr.GetMainSQLText: String;
begin
  Result := SQ_MAIN;
end;

function TkisArchivalDocsMngr.IsSupported(Entity: TKisEntity): Boolean;
begin
  Result := Assigned(Entity)
    and ((Entity is TKisArchivalDoc)
         or (Entity is TKisArchDocMove));
  if not Result then
    inherited IsSupported(Entity);
end;

function TkisArchivalDocsMngr.CreateEntity(
EntityKind: TKisEntities): TKisEntity;
begin
  case EntityKind of
  keDefault, keArchivalDoc :
    begin
      Result := TKisArchivalDoc.Create(Self);
    end;
  keArchDocMove :
    begin
      Result := TKisArchDocMove.Create(Self);
    end
  else
    Result := nil;
  end;
end;

procedure TKisArchivalDocsMngr.CreateView;
begin
  inherited;
  FView.Caption := 'Архивные документы';
  FView.Grid.OnCellColors := GridCellColors;
end;

function TKisArchivalDocsMngr.IsEntityInUse(Entity: TKisEntity): Boolean;
begin
  Result := false;
end;

procedure TKisArchivalDocsMngr.PrepareSQLHelper;
begin
  inherited;
  with FSQLHelper do
  begin
    with AddTable do
    begin
      TableName := ST_ARCHIVAL_DOCS;
      TableLabel := 'Основная (Архивные документы)';
      AddStringField(SF_ARCH_NUMBER, 'Архивный номер', 10, [fpSearch, fpSort, fpQuickSearch]);
      AddSimpleField(SF_SHELVE_DATE, 'Дата сдачи в архив', ftDate, [fpSearch, fpSort]);
      AddStringField(SF_OBJECT_NAME, 'Наименование объекта', 100, [fpSearch, fpSort, fpQuickSearch]);
      AddStringField(SF_ADDRESS, 'Адрес', 400, [fpSearch, fpSort, fpQuickSearch]);
      AddStringField(SF_BASIS, 'Основание', 255, [fpSearch, fpSort, fpQuickSearch]);
      AddStringField(SF_COMMENT, 'Примечания', 255, [fpSearch, fpSort, fpQuickSearch]);
      AddStringField(SF_FIRM, 'Заказчик', 300, [fpSearch, fpSort, fpQuickSearch]);
      AddSimpleField(SF_ID, SFL_INSERT_ORDER, ftInteger, [fpSort]);
    end;
    with AddTable do
    begin
      TableName := ST_LICENSED_ORGS;
      TableLabel := 'Организации, выполнявшие работы';
      AddStringField(SF_NAME, 'Организация', 300, [fpSearch, fpSort, fpQuickSearch]);
    end;
    with AddTable do
    begin
      TableName := ST_ARCHIVAL_DOC_TYPES;
      TableLabel := 'Тип документа';
      AddStringField(SF_NAME, 'Тип документа', 50, [fpSearch, fpSort, fpQuickSearch]);
    end;
  end;
end;

procedure TKisArchivalDocsMngr.SaveArchivalDoc(ArchDoc: TKisArchivalDoc);
var
  Conn: IKisConnection;
  DataSet: TDataSet;
begin
  Conn := GetConnection(True, True);
  try
    // Сохраняем архивный документ
    DataSet := Conn.GetDataSet(SQ_SAVE_ARCHIVAL_DOC);
    ArchDoc.ChangeStatus;
    if ArchDoc.ID < 1 then
      ArchDoc.ID := Self.GenEntityID(keArchivalDoc);
    Conn.SetParam(DataSet, SF_ID, ArchDoc.ID);
    Conn.SetParam(DataSet, SF_ADDRESS, ArchDoc.Address);
    Conn.SetParam(DataSet, 'BASIS', ArchDoc.Basis);
    Conn.SetParam(DataSet, SF_COMMENT, ArchDoc.Comment);
    Conn.SetParam(DataSet, 'ARCH_DOC_TYPES_ID', ArchDoc.DocTypeId);
    Conn.SetParam(DataSet, SF_FIRM, ArchDoc.Firm);
    Conn.SetParam(DataSet, SF_FIRMS_ID, ArchDoc.FirmId);
    Conn.SetParam(DataSet, SF_LICENSED_ORGS_ID, ArchDoc.LicensedOrgId);
    Conn.SetParam(DataSet, 'ARCH_NUMBER', ArchDoc.Number);
    Conn.SetParam(DataSet, 'OBJECT_NAME', ArchDoc.ObjectName);
    Conn.SetParam(DataSet, 'SHELVE_DATE', ArchDoc.ShelveDate);
    Conn.SetParam(DataSet, SF_STATUS, Integer(ArchDoc.Status));
    DataSet.Open;

    // Сохраняем список выдачи документа
    SaveArchivalDocMoveList(ArchDoc);
{    SQL.Text := Format(SQ_CLEAR_ARCH_DOCS_LIST, [ArchDoc.ID]);
    ExecSQL;
    with FDocMovesCtrlr do
      for I := 1 to GetRecordCount do
        Self.SaveEntity(Elements[I]); }
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise
  end;
end;

procedure TKisArchivalDocsMngr.SaveEntity(Entity: TKisEntity);
begin
  inherited;
  try
    if Assigned(Entity) then
    if IsSupported(Entity) then
    if (Entity is TKisArchivalDoc) then
         SaveArchivalDoc(Entity as TKisArchivalDoc)
    else
       if (Entity is TKisArchDocMove) then
        SaveArchivalDocMove(Entity as TKisArchDocMove);
  except
    raise;
  end;
end;

procedure TKisArchivalDocsMngr.SaveArchivalDocMove(aMove: TKisArchDocMove);
var
  Conn: IKisConnection;
  DataSet: TDataSet;
begin
  Conn := GetConnection(True, True);
  try
    aMove.SetDocOrderLink;
    if aMove.ID < 1 then
      aMove.ID := Self.GenEntityID(keArchDocMove);
    DataSet := Conn.GetDataSet(SQ_SAVE_ARCHIVAL_DOCS_LIST);
    // :ID, :ARCHIVAL_DOC_ID, :DATE_OF_BACK, :DATE_OF_GIVE, :PEOPLE_NAME,
    // :OFFICE_NAME, :ORDER_ACCOUNT, :ORDER_GIVEN_DOC_LINK, :ORDER_NUMBER,
    // :"TERM", :OFFICES_ID, :ORDERS_ID, :PEOPLE_ID
    Conn.SetParam(DataSet, SF_ID, aMove.ID);
    Conn.SetParam(DataSet, SF_ARCHIVAL_DOC_ID, aMove.HeadId);
    Conn.SetParam(DataSet, SF_DATE_OF_BACK, aMove.DateOfBack);
    Conn.SetParam(DataSet, SF_DATE_OF_GIVE, aMove.DateOfGive);
    Conn.SetParam(DataSet, SF_PEOPLE_NAME, aMove.Executor);
    Conn.SetParam(DataSet, SF_OFFICE_NAME, aMove.OfficeName);
    Conn.SetParam(DataSet, SF_ORDER_ACCOUNT, aMove.OrderAccount);
    Conn.SetParam(DataSet, 'ORDER_GIVEN_DOC_LINK', aMove.OrderDocLink);
    Conn.SetParam(DataSet, SF_ORDER_NUMBER, aMove.OrderNumber);
    Conn.SetParam(DataSet, SF_TERM, aMove.Term);
    Conn.SetParam(DataSet, SF_OFFICES_ID, aMove.OfficeId);
    if aMove.OrdersId > 0 then
      Conn.SetParam(DataSet, SF_ORDERS_ID, aMove.OrdersId)
    else
      Conn.SetParam(DataSet, SF_ORDERS_ID, NULL);
    Conn.SetParam(DataSet, SF_PEOPLE_ID, aMove.PeopleId);
    DataSet.Open;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, false);
    raise;
  end;
end;

function TKisArchivalDocsMngr.GetMainDataSet: TDataSet;
begin
  Result := dsArchivalDocs;
end;

function TKisArchivalDocsMngr.GetRefreshSQLText: String;
begin
   Result := GetMainSQLText + ' WHERE AD.ID=:ID';
end;

procedure TKisArchivalDocsMngr.GetList(ArchDoc: TKisEntity);
var
  Conn: IKisConnection;
  Tmp: TKisEntity;
begin
  Conn := GetConnection(True, True);
  with ArchDoc as TKisArchivalDoc do
  with Conn.GetDataSet(Format(SQ_GET_GIVEN_DOC_LIST_ID, [ID])) do
  try
    Open;
    while not Eof do
    begin
      Tmp := Self.GetEntity(FieldByName(SF_ID).AsInteger, keArchDocMove);
      if Assigned(Tmp) then
         FDocMovesCtrlr.DirectAppend(Tmp);
      Next;
    end;
    Close;
  finally
    FreeConnection(Conn, True);
  end;
end;

function TKisArchivalDocsMngr.FindOrder(DocList: TKisEntity; out OrderDate: TDateTime; out OrderId: Integer): Boolean;
var
  Conn: IKisConnection;
  OffId: Integer;
  OrderNum, OrderAcc, GiveDate: String;
begin
  Conn := GetConnection(True, True);
  with DocList as TKisArchDocMove do
  begin
    OrderNum := OrderNumber;
    OrderAcc := OrderAccount;
    OffId := OfficeId;
    GiveDate := DateOfGive;
    with Conn.GetDataSet(Format(SQ_FIND_ORDER, [OffId, OrderNum, OrderAcc])) do
    try
      Open;
      OrderDate := FieldByName(SF_ORDER_DATE).AsDateTime;
      OrderId := FieldByName(SF_ID).AsInteger;
      Result := RecordCount > 0;
      Close;
    finally
      FreeConnection(Conn, True);
    end;
  end;
end;

{ TkisGivenArchDocsList }

function TKisArchDocMove.CheckEditor(
  AEditor: TKisEntityEditor): Boolean;
var
  GiveDate, BackDate: TDateTime;
  V: Integer;

  procedure ErrorInBackDate;
  begin
    MessageBox(AEditor.Handle, PChar(S_CHECK_DATE_OF_BACK), PChar(S_WARN), MB_OK + MB_ICONWARNING);
    with AEditor as TKisArchDocMoveEditor do
      edDateOfBack.SetFocus;
  end;

begin
  with AEditor as TKisArchDocMoveEditor do
  begin
    if (edDateOfGive.Text = '') or (not TryStrToDate(edDateOfGive.Text, GiveDate) or
      ((GiveDate > Date) or (GiveDate < MIN_DOC_DATE))) then
    begin
      MessageBox(Handle, PChar(S_CHECK_DATE_OF_GIVE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edDateOfGive.SetFocus;
      Result := False;
      Exit;
    end;

    if (edDateOfBack.Text = '') then
    begin
      ErrorInBackDate;
      Result := False;
      Exit;
    end;
    if not TryStrToDate(edDateOfBack.Text, BackDate) then
    begin
      ErrorInBackDate;
      Result := False;
      Exit;
    end;
    if (BackDate < MIN_DOC_DATE) then
    begin
      ErrorInBackDate;
      Result := False;
      Exit;
    end;
    if (BackDate > Date) then
    begin
      MessageBox(AEditor.Handle, PChar('Дата возврата больше сегодняшней!'), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edDateOfBack.SetFocus;
      Result := False;
      Exit;
    end;
    if (BackDate < GiveDate) then
    begin
      MessageBox(AEditor.Handle, PChar('Дата возврата меньше даты выдачи!'), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edDateOfBack.SetFocus;
      Result := False;
      Exit;
    end;

{    if (edDateOfBack.Text <> '') and ((not TryStrToDate(edDateOfBack.Text, BackDate) or
      ((BackDate > Date) or (BackDate < MIN_DOC_DATE)) or (BackDate < GiveDate))) then
    begin
      ErrorInBackDate;
      Result := False;
      Exit;
    end;  }
    if (edTerm.Text = '') or (not TryStrToInt(edTerm.Text, V))  then
    begin
      MessageBox(Handle, PChar(S_CHECK_TERM), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edTerm.SetFocus;
      Result := False;
      Exit;
    end;
    if (cbOffice.Text = '') then
    begin
      MessageBox(Handle, PChar(S_CHECK_OFFICE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      cbOffice.SetFocus;
      Result := False;
      Exit;
    end;
    if (cbPeople.Text = '') or BadName(cbPeople.Text)  then
    begin
      MessageBox(Handle, PChar(S_CHECK_EXECUTOR), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      cbPeople.SetFocus;
      Result := False;
      Exit;
    end;
    if (edOrderNumber.Text = '') then
    begin
      MessageBox(Handle, PChar(S_CHECK_ORDER_NUMBER), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edOrderNumber.SetFocus;
      Result := False;
      Exit;
    end;
    if (edOrderAccount.Text = '') then
    begin
      MessageBox(Handle, PChar(S_CHECK_ACCOUNT), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edOrderAccount.SetFocus;
      Result := False;
      Exit;
    end;
  end;
  Result := True;
end;

procedure TKisArchDocMove.Copy(Source: TKisEntity);
begin
  inherited;
  with Source as TKisArchDocMove do
  begin
    Self.FArchivalDocId := FArchivalDocId;
    Self.FDateOfBack := FDateOfBack;
    Self.FDateOfGive := FDateOfGive;
    Self.FExecutor := FExecutor;
    Self.FOfficeName := FOfficeName;
    Self.FOrderAccount := FOrderAccount;
    Self.FOrderDocLink := FOrderDoclink;
    Self.FOrderNumber := FOrderNumber;
    Self.FTerm := FTerm;
    Self.FOfficeId := FOfficeId;
    Self.FOrdersId := FOrdersId;
    Self.FPeopleId := FPeopleId;
  end;
end;

function TKisArchDocMove.CreateEditor: TKisEntityEditor;
begin
  Result := TKisArchDocMoveEditor.Create(Application);
end;

class function TKisArchDocMove.EntityName: String;
begin

end;

procedure TKisArchDocMove.Load(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    ID := FieldByName(SF_ID).AsInteger;
    ArchivalDocId := FieldByName(SF_ARCHIVAL_DOC_ID).AsInteger;
    DateOfGive := FieldByName(SF_DATE_OF_GIVE).AsString;
    DateOfBack := FieldByName(SF_DATE_OF_BACK).AsString;
    Executor := FieldByName(SF_PEOPLE_NAME).AsString;
    OfficeName := FieldByName(SF_OFFICE_NAME).AsString;
    OrderAccount := FieldByName(SF_ORDER_ACCOUNT).AsString;
    OrderDocLink := FieldByName(SF_ORDER_DOC_LINK).AsInteger;
    OrderNumber := FieldByName(SF_ORDER_NUMBER).AsString;
    Term := FieldByName(SF_TERM).AsInteger;
    OfficeId := FieldByName(SF_OFFICES_ID).AsInteger;
    OrdersId := FieldByName(SF_ORDERS_ID).AsInteger;
    PeopleId := FieldByName(SF_PEOPLE_ID).AsInteger;
    Self.Modified := True;
  end;
end;

procedure TKisArchDocMove.LoadDataIntoEditor(
  AEditor: TKisEntityEditor);
begin
  inherited;
  with AEditor as TKisArchDocMoveEditor do
  begin
    edDateOfGive.Text := DateOfGive;
    if Term = 0 then
      edTerm.Text := ''
    else
      edTerm.Text := IntToStr(Term);
    edDateOfBack.Text := DateOfBack;
    ComboLocate(cbOffice, OfficeId);
    LoadPeopleList(nil);
    ComboLocate(cbPeople, PeopleId);
    edOrderNumber.Text := OrderNumber;
    edOrderAccount.Text := OrderAccount;
  end;
end;

procedure TKisArchDocMove.LoadPeopleList(Sender: TObject);
var
  P: Integer;
begin
  with EntityEditor as TKisArchDocMoveEditor do
  begin
    if cbOffice.ItemIndex < 0 then
      cbPeople.Items.Clear
    else
    begin
      cbPeople.Text := '';
      P := Integer(cbOffice.Items.Objects[cbOffice.ItemIndex]);
      cbPeople.Items := IStringList(AppModule.PeolpeList(P)).StringList;
    end;
  end;
end;

procedure TKisArchDocMove.PrepareEditor(AEditor: TKisEntityEditor);
begin
  inherited;
  with AEditor as TKisArchDocMoveEditor do
  begin
    cbOffice.Items := IStringList(AppModule.Lists[klOffices]).StringList;
    cbOffice.OnChange := LoadPeopleList;

    edDateOfGive.Enabled := not FIsEndMove;
    edOrderNumber.Enabled := not FIsEndMove;
    edOrderAccount.Enabled := not FIsEndMove;
    cbOffice.Enabled := not FIsEndMove;
    cbPeople.Enabled := not FIsEndMove;

    if FIsEndMove then
      edDateOfBack.Color := clInfoBk
    else
      edDateOfBack.Color := clWindow;
  end;
end;

procedure TKisArchDocMove.ReadDataFromEditor(
  AEditor: TKisEntityEditor);
begin
  inherited;
  with AEditor as TKisArchDocMoveEditor do
  begin
    DateOfGive := Trim(edDateOfGive.Text);
    Term := StrToInt(Trim(edTerm.Text));
    DateOfBack := Trim(edDateOfBack.Text);
    OfficeName := cbOffice.Text;
    if cbOffice.ItemIndex < N_ZERO then
      OfficeId := N_ZERO
    else
      OfficeId := Integer(cbOffice.Items.Objects[cbOffice.ItemIndex]);
    Executor := cbPeople.Text;
    PeopleId := Integer(cbPeople.Items.Objects[cbPeople.ItemIndex]);
    OrderNumber := Trim(edOrderNumber.Text);
    OrderAccount := Trim(edOrderAccount.Text);
  end;
end;

procedure TKisArchDocMove.SetArchivalDocId(const Value: Integer);
begin
  if FArchivalDocId <> Value then
  begin
    FArchivalDocId := Value;
    Modified := True;
  end;
end;

procedure TKisArchDocMove.SetDateOfBack(const Value: String);
begin
  if FDateOfBack <> Value then
  begin
    FDateOfBack := Value;
    Modified := True;
  end;
end;

procedure TKisArchDocMove.SetDateOfGive(const Value: String);
begin
  if FDateOfGive <> Value then
  begin
    FDateOfGive := Value;
    Modified := True;
  end;
end;

procedure TKisArchDocMove.SetExecutor(const Value: String);
begin
  if FExecutor <> Value then
  begin
    FExecutor := Value;
    Modified := True;
  end;
end;

procedure TKisArchDocMove.SetOfficeId(const Value: Integer);
begin
  if FOfficeId <> Value then
  begin
    FOfficeId := Value;
    Modified := True;
  end;
end;

procedure TKisArchDocMove.SetOfficeName(const Value: String);
begin
  if FOfficeName <> Value then
  begin
    FOfficeName := Value;
    Modified := True;
  end;
end;

procedure TKisArchDocMove.SetOrderAccount(const Value: String);
begin
  if FOrderAccount <> Value then
  begin
    FOrderAccount := Value;
    Modified := True;
  end;
end;

procedure TKisArchDocMove.SetOrderDocLink(const Value: Integer);
begin
  if FOrderDocLink <> Value then
  begin
    FOrderDocLink := Value;
    Modified := True;
  end;
end;

procedure TKisArchDocMove.SetOrderNumber(const Value: String);
begin
  if FOrderNumber <> Value then
  begin
    FOrderNumber := Value;
    Modified := True;
  end;
end;

procedure TKisArchDocMove.SetOrdersId(const Value: Integer);
begin
  if FOrdersId <> Value then
  begin
    FOrdersId := Value;
    Modified := True;
  end;
end;

procedure TKisArchDocMove.SetTerm(const Value: Integer);
begin
  if FTerm <> Value then
  begin
    FTerm := Value;
    Modified := True;
  end;
end;

{ TGivenArchDocsListCtrlr }

procedure TArchDocMovesCtrlr.FillFieldDefs(FieldDefsRef: TFieldDefs);
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
    Name := SF_ARCHIVAL_DOC_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 3;
    Size := 10;
    Name := SF_DATE_OF_BACK;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 4;
    Size := 10;
    Name := SF_DATE_OF_GIVE;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 5;
    Size := 78;
    Name := SF_PEOPLE_NAME;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 6;
    Size := 80;
    Name := SF_OFFICE_NAME;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 7;
    Size := 10;
    Name := SF_ORDER_ACCOUNT;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 8;
    Name := SF_ORDER_DOC_LINK;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftString;
    FieldNo := 9;
    Size := 10;
    Name := SF_ORDER_NUMBER;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 10;
    Name := SF_TERM;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 11;
    Name := SF_OFFICES_ID;
  end;
  with FieldDefsRef.AddFieldDef do
  begin
    DataType := ftInteger;
    FieldNo := 12;
    Name := SF_ORDERS_ID;
  end;
end;

function TArchDocMovesCtrlr.GetDeleteQueryText: String;
var
  IDList: String;
  I: Integer;
begin
  Result := 'DELETE FROM GIVEN_ARCHIVAL_DOCS_LIST WHERE ID IN (%s)';
  IDList := '';
  for I := 0 to Pred(DeletedCount) do
  begin
    if I > 0 then
      IDList := IDList + ',';
    IDList := IDList + IntToStr(DeletedElements[I].ID);
  end;
  Result := Format(Result, [IDList]);
end;

function TArchDocMovesCtrlr.GetFieldData(Index: Integer;
  Field: TField; out Data): Boolean;
var
  Ent: TKisArchDocMove;
begin
  try
    Result := True;
    Ent := TKisArchDocMove(Elements[Index]);
    case Field.FieldNo of
    1 : GetInteger(Ent.ID, Data);
    2 : GetInteger(Ent.HeadId, Data);
    3 : if Ent.DateOfBack <> '' then
          GetString(Ent.DateOfBack, Data)
        else
          Result := False;
    4 : GetString(Ent.DateOfGive, Data);
    5 : GetString(Ent.Executor, Data);
    6 : GetString(Ent.OfficeName, Data);
    7 : GetString(Ent.OrderAccount, Data);
    8 : GetInteger(Ent.OrderDocLink, Data);
    9 : GetString(Ent.OrderNumber, Data);
    10 : GetInteger(Ent.Term, Data);
    11 : GetInteger(Ent.OfficeId, Data);
    12 : GetInteger(Ent.OrdersId, Data);
    else
      raise EDatabaseError.CreateFmt(S_FIELD_NOT_FOUND, [Field.FieldName]);
    end;
  except
    Result := False;
  end;
end;

function TArchDocMovesCtrlr.GetLast: TKisArchDocMove;
begin
  if GetRecordCount > 0 then
    Result := TKisArchDocMove(Elements[GetRecordCount])
  else
    Result := nil;
end;

procedure TArchDocMovesCtrlr.SetFieldData(Index: Integer;
  Field: TField; var Data);
var
  Ent: TKisArchDocMove;
begin
  try
    Ent := TKisArchDocMove(Elements[Index]);
    case Field.FieldNo of
    1 : Ent.ID := SetInteger(Data);
    3 : Ent.DateOfBack := SetString(Data);
    4 : Ent.DateOfGive := SetString(Data);
    5 : Ent.Executor := SetString(Data);
    6 : Ent.OfficeName := SetString(Data);
    7 : Ent.OrderAccount := SetString(Data);
    8 : Ent.OrderDocLink := SetInteger(Data);
    9 : Ent.OrderNumber := SetString(Data);
    10 : Ent.Term := SetInteger(Data);
    11 : Ent.OfficeId := SetInteger(Data);
    12 : Ent.OrdersId := SetInteger(Data);
    end;
  except
  end;
end;

function TkisArchivalDocsMngr.CreateNewEntity(
EntityKind: TKisEntities): TKisEntity;
begin
  case EntityKind of
  keDefault, keArchivalDoc :
    Result := TKisArchivalDoc.Create(Self);
  keArchDocMove :
    Result := TKisArchDocMove.Create(Self);
  else
    raise Exception.Create(S_CANT_CREATE_NEW_ENTITY);
  end;
  Result.ID := Self.GenEntityID(EntityKind);
end;

function TkisArchivalDocsMngr.CurrentEntity: TKisEntity;
begin
  Result := GetEntity(dsArchivalDocsID.AsInteger, keArchivalDoc);
end;

procedure TkisArchivalDocsMngr.DeleteEntity(Entity: TKisEntity);
var
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, True);
  try
    if IsEntityInUse(Entity) then
      inherited
    else
      Conn.GetDataSet(Format(SQ_DELETE_ARCHIVAL_DOCS, [Entity.ID])).Open;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

function TkisArchivalDocsMngr.GetEntity(EntityID: Integer;
  EntityKind: TKisEntities): TKisEntity;
var
  DataSet: TDataSet;
  Conn: IKisConnection;
begin
  Result := nil;
  Conn := GetConnection(True, False);
  try
    case EntityKind of
    keDefault, keArchivalDoc :
      DataSet := Conn.GetDataSet(Format(SQ_SELECT_ARCHIVAL_DOCS, [EntityID]));
    keArchDocMove :
      DataSet := Conn.GetDataSet(Format(SQ_SELECT_GIVEN_ARCH_DOC_LIST, [EntityID]));
    else
      raise ELoadEntity.Create(EntityID, EntityKind);
    end;
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

function TKisArchDocMove.EndMove: Boolean;
begin
  FIsEndMove := True;
  try
    Result := Edit;
  finally
    FIsEndMove := False;
  end;
end;

procedure TKisArchivalDocsMngr.acGiveDocumentExecute(Sender: TObject);
var
  Conn: IKisConnection;
  Doc: TKisArchivalDoc;
begin
  Conn := GetConnection(True, True);
  try
    Doc := KisObject(CurrentEntity).AEntity as TKisArchivalDoc;
    Doc.Modified := False;
    Doc.GiveOutDocument;
    if Doc.Modified then
      SaveEntity(Doc);
    FreeConnection(Conn, True);
    dsArchivalDocs.Refresh;
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisArchivalDocsMngr.acBackDocumentExecute(Sender: TObject);
var
  Conn: IKisConnection;
  Doc: TKisArchivalDoc;
begin
  Conn := GetConnection(True, True);
  try
    Doc := KisObject(CurrentEntity).AEntity as TKisArchivalDoc;
    Doc.Modified := False;
    Doc.GiveBackDocument;
    if Doc.Modified then
      SaveEntity(Doc);
    FreeConnection(Conn, True);
    dsArchivalDocs.Refresh;
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisArchivalDoc.GiveOutDocument;
var
  Mngr: TKisArchivalDocsMngr;
begin
  Moves.Last;
  if CanGiveOut then
  begin
    Mngr := TKisArchivalDocsMngr(Manager);
    with Mngr.CreateNewEntity(keArchDocMove) as TKisArchDocMove do
    begin
      DateOfGive := FormatDateTime(S_DATESTR_FORMAT, Date);
      Term := 1;
      Modified := False;
      if Edit then
      begin
        FDocMovesCtrlr.DirectAppend(Me);
        Self.Modified := True;
      end;
    end;
  end
  else
    raise Exception.Create(S_CANT_GIVE_OUT);
end;

function TKisArchivalDoc.CanGiveOut: Boolean;
begin
  // Движений нет или последнее движение закрыто
  Result := Moves.IsEmpty or FDocMovesCtrlr.LastMove.IsClosed;
end;

function TKisArchDocMove.IsClosed: Boolean;
begin
  Result := FDateOfBack <> '';
end;

procedure TKisArchivalDocsMngr.GridCellColors(Sender: TObject;
  Field: TField; var Background, FontColor: TColor; State: TGridDrawState; var FontStyle:TFontStyles);
var
  DataSet: TDataSet;
begin
  DataSet := Field.DataSet;
  if gdSelected in State then
  begin
    BackGround := clHighlight;
    FontColor := clWhite;
  end
  else
    if Boolean(DataSet.FieldByName(SF_STATUS).AsInteger) then
      Background := 8421600 // на руках
    else
      BackGround := clHighlightText; // в архиве
end;

procedure TKisArchivalDocsMngr.acGiveDocumentUpdate(Sender: TObject);
begin
  acGiveDocument.Enabled := dsArchivalDocsSTATUS.AsInteger = 0;
end;

procedure TKisArchivalDocsMngr.acBackDocumentUpdate(Sender: TObject);
begin
  acBackDocument.Enabled := dsArchivalDocsSTATUS.AsInteger = 1;
end;

procedure TKisArchivalDoc.GiveBackDocument;
begin
  Moves.Last;
  if not CanGiveOut then
  begin
    with FDocMovesCtrlr.LastMove do
    begin
      DateOfBack := FormatDateTime(S_DATESTR_FORMAT, Date);
      Modified := False;
      Self.Modified := Edit;
    end;
  end
  else
    raise Exception.Create(S_CANT_GIVE_BACK);
end;

procedure TKisArchDocMove.SetPeopleId(const Value: Integer);
begin
  if FPeopleId <> Value then
  begin
    FPeopleId := Value;
    Modified := True;
  end;
end;

procedure TKisArchivalDocsMngr.SaveArchivalDocMoveList(
  ArchivalDoc: TKisArchivalDoc);
var
  Conn: IKisConnection;
  DataSet: TDataSet;
  aMove: TKisArchDocMove;
begin
  Conn := GetConnection(True, True);
  try
    if ArchivalDoc.FDocMovesCtrlr.DeletedCount > 0 then
    begin
      Conn.GetDataSet(ArchivalDoc.FDocMovesCtrlr.GetDeleteQueryText).Open;
      ArchivalDoc.FDocMovesCtrlr.ClearDeleted;
    end;
    DataSet := Conn.GetDataSet(SQ_SAVE_ARCHIVAL_DOCS_LIST);
    ArchivalDoc.Moves.First;
    while not ArchivalDoc.Moves.Eof do
    begin
      aMove := TKisArchDocMove(ArchivalDoc.FDocMovesCtrlr.Elements[ArchivalDoc.Moves.RecNo]);
      if aMove.ID < 1 then
        aMove.ID := Self.GenEntityID(keArchDocMove);
      if aMove.Modified then
      begin
        aMove.SetDocOrderLink;
        // :ID, :ARCHIVAL_DOC_ID, :DATE_OF_BACK, :DATE_OF_GIVE, :PEOPLE_NAME,
        // :OFFICE_NAME, :ORDER_ACCOUNT, :ORDER_GIVEN_DOC_LINK, :ORDER_NUMBER,
        // :"TERM", :OFFICES_ID, :ORDERS_ID, :PEOPLE_ID
        Conn.SetParam(DataSet, SF_ID, aMove.ID);
        Conn.SetParam(DataSet, SF_ARCHIVAL_DOC_ID, aMove.HeadId);
        Conn.SetParam(DataSet, SF_DATE_OF_BACK, aMove.DateOfBack);
        Conn.SetParam(DataSet, SF_DATE_OF_GIVE, aMove.DateOfGive);
        Conn.SetParam(DataSet, SF_PEOPLE_NAME, aMove.Executor);
        Conn.SetParam(DataSet, SF_OFFICE_NAME, aMove.OfficeName);
        Conn.SetParam(DataSet, SF_ORDER_ACCOUNT, aMove.OrderAccount);
        Conn.SetParam(DataSet, 'ORDER_GIVEN_DOC_LINK', aMove.OrderDocLink);
        Conn.SetParam(DataSet, SF_ORDER_NUMBER, aMove.OrderNumber);
        Conn.SetParam(DataSet, SF_TERM, aMove.Term);
        Conn.SetParam(DataSet, SF_OFFICES_ID, aMove.OfficeId);
        if aMove.OrdersId > 0 then
          Conn.SetParam(DataSet, SF_ORDERS_ID, aMove.OrdersId)
        else
          Conn.SetParam(DataSet, SF_ORDERS_ID, NULL);
        Conn.SetParam(DataSet, SF_PEOPLE_ID, aMove.PeopleId);
        DataSet.Open;
      end;
      ArchivalDoc.Moves.Next;
    end;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, false);
    raise;
  end;
end;

end.

