{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Менеджер конрагентов                            }
{                                                       }
{       Copyright (c) 2003-2005, МП УГА                 }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание: операции над контрагентами
  Имя модуля: Contragents
  Цель: содержит классы - менеждер контрагентов, конрагент, контрагент-юрлицо,
        конрагент-физлицо, контрагент-ЧП, головная огранизация.
  Используется:
  Использует:   GarbageCollector, Kernel Classes, Entity Editor,
                Contragent Certificates
  Исключения:   }
{
   1.16          21.07.2020
     - контрагенты теперь не требуют ввода обязательных данных кроме названия

   1.15          29.06.2005
     - добавлен метод TKisContragent.CustomerRepresentativeName
     - добавлен метод TKisCOntragetnOrganisation.ChiefDoc

   1.14          05.05.2005
     - исправлена ошибка - контрагент сохранялся даже если не был изменен

   1.13          25.04.2005
     - использован новый интерфейс из uGC
     - использованы новые методы работы с главным датасетом

   1.12          27.07.2004
     - оптимизирована работа с фильтрами  
   1.11
     - исправлена работа с транзакциями
     - ускорена работа метода EditCurrent
}

unit uKisContragents;

interface

{$I KisFlags.pas}

uses
  // System
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  DB, ImgList, ActnList, IBCustomDataSet, DBGrids, Grids, 
  // Common
  uGC,
  // Project
  uKisClasses, uKisEntityEditor, uKisContragentCertificates, uKisSQLClasses,
  uKisContragentsComparison, uKisBanks, uKisAccounts, uKisFilters;

type
  TKisContragentType = (ctOrganization, ctPerson, ctPrivateBusinessmen);

  TKisContragentMngr = class;

  TKisContragent = class(TKisSQLEntity)
  private type
    TContragentEditorOption = (cntrAddress, cntrINN);
    TContragentEditorOptions = set of TContragentEditorOption;
  private
    FContrType: Byte;
    FName: String;
    FShortName: String;
    FPhones: String;
    FINN: String;
    FTypeAccount: Integer;
    FBankAccount: String;
    FComment: TStrings;
    FAddress1: TKisEntity;
    FAddress2: TKisEntity;
    FBank: TKisEntity;
    FParentId: Integer;
    FDefaultAccount: TKisContragentAccount;
    FAccounts: TDataSet;
    FAccountsCtrlr: TKisContrAccountCtrlr;
    FEditorOptions: TContragentEditorOptions;
    procedure SetName(const Value: String);
    procedure SetShortName(const Value: String);
    procedure SetAddress1Id(const Value: Integer);
    procedure SetAddress2Id(const Value: Integer);
    procedure SetPhones(const Value: String);
    procedure SetINN(const Value: String);
    procedure SetBankId(const Value: Integer);
    procedure SetTypeAccount(const Value: Integer);
    procedure SetBankAccount(const Value: String);
    procedure SetComment(const Value: TStrings);
    function GetComment: TStrings;
    procedure SetAddress1(const Value: TKisEntity);
    procedure SetAddress2(const Value: TKisEntity);
    procedure SetBank(const Value: TKisEntity);
    procedure SelectAddress1(Sender: TObject);
    procedure SelectAddress2(Sender: TObject);
    procedure SelectBank(Sender: TObject);
    function GetBankId: Integer;
    function GetAddress1Id: Integer;
    function GetAddress2Id: Integer;
    procedure CopyJurAddress(Sender: TObject);
    procedure CopyJurToFactAddress;
    function GetTypeAccount: Integer;
    function GetBankAccount: String;
    function GetBankName: String;
    procedure CopyAccount(Source: TKisEntity);
    procedure CopyAccountCtrlr(Source: TKisEntity);
    function GetBankAccountEntity: TKisContragentAccount;
  protected
    function CheckEditor(AEditor: TKisEntityEditor): Boolean; override;
    procedure PrepareEditor(AEditor: TKisEntityEditor); override;
    procedure LoadDataIntoEditor(AEditor: TKisEntityEditor); override;
    procedure ReadDataFromEditor(AEditor: TKisEntityEditor); override;
    function CreateEditor: TKisEntityEditor; override;
    procedure UpdateAddress1;
    procedure UpdateAddress2;
    procedure UpdateBank;
    function GetText: String; override;
    function GetProperties: String; virtual;
    function TransferContragentIntoStrings: TStringList; virtual;
  public
    constructor Create(Mngr: TKisMngr); override;
    destructor Destroy; override;
    class function EntityName: String; override;
    function IsEmpty: Boolean; override;
    function Equals(Entity: TKisEntity): Boolean; override;
    procedure Copy(Source: TKisEntity); override;
    // Имя представителя заказчика
    function CustomerRepresentativeName: String; virtual;
    property ContrType: Byte read FContrType;
    property Name: String read FName write SetName;
    property ShortName: String read FShortName write SetShortName;
    property Address1: TKisEntity read FAddress1 write SetAddress1;
    property Address1Id: Integer read GetAddress1Id write SetAddress1Id;
    property Address2: TKisEntity read FAddress2 write SetAddress2;
    property Address2Id: Integer read GetAddress2Id write SetAddress2Id;
    property Phones: String read FPhones write SetPhones;
    property INN: String read FINN write SetINN;
//    property Bank: TKisEntity read FBank;// write SetBank;
    property BankId: Integer read GetBankId write SetBankId;
    property TypeAccount: Integer read GetTypeAccount write SetTypeAccount;
    property BankAccount: String read GetBankAccount write SetBankAccount;
    property BankName: String read GetBankName;
    property Comment: TStrings read GetComment write SetComment;
    property ParentId: Integer read FParentId write FParentId;
    property Properties: String read GetProperties;
    property BankAccountEntity: TKisContragentAccount read GetBankAccountEntity;
    property AccountCtrlr: TKisContrAccountCtrlr read FAccountsCtrlr;
  end;

  TKisContragentOrganisation = class(TKisContragent)
  private type
    TOrgEditorOption = (orgBank, orgChiefFIO, orgChiefPost, orgChiefDoc, orgKPP, orgOKPF, orgOKPO, orgOKONH);
    TOrgEditorOptions = set of TOrgEditorOption;
  private
    FChief: String;
    FChiefPost: String;
    FChiefDocType: SmallInt;
    FContacter: String;
    FContacterPost: String;
    FAccountant: String;
    FKPP: String;
    FOKPF: String;
    FOKPO: String;
    FOKONH: String;
    FSubdivisionId: Integer;
    FHeadOrg: TKisEntity;
    FChiefDocDate: TDate;
    FChiefDocNumber: String;
    FContacterPhones: String;
    FChiefDocs: String;
    FEditorOptions: TOrgEditorOptions;
    procedure SetChief(const Value: String);
    procedure SetChiefPost(const Value: String);
    procedure SetChiefDocType(const Value: SmallInt);
    procedure SetContacter(const Value: String);
    procedure SetContacterPost(const Value: String);
    procedure SetAccountant(const Value: String);
    procedure SetKPP(const Value: String);
    procedure SetOKPF(const Value: String);
    procedure SetOKPO(const Value: String);
    procedure SetOKONH(const Value: String);
    procedure SetSubdivisionId(const Value: Integer);
    function GetHeadOrgId: Integer;
    procedure SetHeadorgId(const Value: Integer);
    procedure SetHeadOrg(const Value: TKisEntity);
    procedure SetEditorSubdivisionState(Sender: TObject);
    procedure ClearHeadOrgClick(Sender: TObject);
    procedure SetChiefDocDate(const Value: TDate);
    procedure SelectChiefDocType(Sender: TObject);
    procedure SelectHeadOrg(Sender: TObject);
    procedure SetChiefDocNumber(const Value: String);
    procedure SetContacterPhones(const Value: String);
    procedure SetChiefDocs(const Value: String);
  protected
    procedure PrepareEditor(AEditor: TKisEntityEditor); override;
    function CreateEditor: TKisEntityEditor; override;
    procedure LoadDataIntoEditor(AEditor: TKisEntityEditor); override;
    procedure ReadDataFromEditor(AEditor: TKisEntityEditor); override;
    function CheckEditor(AEditor: TKisEntityEditor): Boolean; override;
    function GetProperties: String; override;
    function TransferContragentIntoStrings: TStringList; override;
  public
    constructor Create(Mngr: TKisMngr); override;
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    function CustomerRepresentativeName: String; override;
    // Возвращает строку описывающую документ руководителя
    function GetChiefDoc: String;
    property Chief: String read FChief write SetChief;
    property ChiefPost: String read FChiefPost write SetChiefPost;
    property ChiefDocType: SmallInt read FChiefDocType write SetChiefDocType;
    property ChiefDocNumber: String read FChiefDocNumber write SetChiefDocNumber;
    property ChiefDocDate: TDate read FChiefDocDate write SetChiefDocDate;
    property ChiefDocs: String read FChiefDocs write SetChiefDocs;
    property Contacter: String read FContacter write SetContacter;
    property ContacterPost: String read FContacterPost write SetContacterPost;
    property ContacterPhones: String read FContacterPhones write SetContacterPhones;
    property Accountant: String read FAccountant write SetAccountant;
    property KPP: String read FKPP write SetKPP;
    property OKPF: String read FOKPF write SetOKPF;
    property OKPO: String read FOKPO write SetOKPO;
    property OKONH: String read FOKONH write SetOKONH;
    property SubdivisionId: Integer read FSubdivisionId write SetSubdivisionId;
    property HeadOrgId: Integer read GetHeadOrgId write SetHeadorgId;
    property HeadOrg: TKisEntity read FHeadOrg write SetHeadOrg;
  end;

  TKisContragentPerson = class(TKisContragent)
  private type
    TPersonEditorOption = (persDocType, persDocNumber, persDocSerie, persDocOwner, persDocDate);
    TPersonEditorOptions = set of TPersonEditorOption;
  private
    FDoc: TKisEntity;
    FEditorOptions: TPersonEditorOptions;
    procedure SetDocId(const Value: Integer);
    procedure SetDoc(const Value: TKisEntity);
    function GetDoc: TKisEntity;
    function GetDocId: Integer;
  protected
    procedure CheckDocId(const Value: Integer);
    function CreateEditor: TKisEntityEditor; override;
    procedure PrepareEditor(AEditor: TKisEntityEditor); override;
    procedure LoadDataIntoEditor(AEditor: TKisEntityEditor); override;
    procedure ReadDataFromEditor(AEditor: TKisEntityEditor); override;
    function CheckEditor(AEditor: TKisEntityEditor): Boolean; override;
    function GetText: String; override;
    function GetProperties: String; override;
    function TransferContragentIntoStrings: TStringList; override;
  public
    constructor Create(Mngr: TKisMngr); override;
    destructor Destroy; override;
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    function IsEmpty: Boolean; override;
    function Equals(Entity: TKisEntity): Boolean; override;
    function CustomerRepresentativeName: String; override;
    property DocId: Integer read GetDocId write SetDocId;
    property Doc: TKisEntity read GetDoc write SetDoc;
  end;

  TKisContragentPrivate = class(TKisContragentPerson)
  private type
    TPrivateEditorOption = (privCertNumber, privCertOwner, privCertBusiness, privCertDate);
    TPrivateEditorOptions = set of TPrivateEditorOption;
  private
    FEditorOptions: TPrivateEditorOptions;
    FCert: TKisEntity;
    procedure SetCert(const Value: TKisEntity);
    function GetCertId: Integer;
    procedure SetCertId(const Value: Integer);
  protected
    function CreateEditor: TKisEntityEditor; override;
    function CheckEditor(AEditor: TKisEntityEditor): Boolean; override;
    procedure PrepareEditor(AEditor: TKisEntityEditor); override;
    procedure LoadDataIntoEditor(AEditor: TKisEntityEditor); override;
    procedure ReadDataFromEditor(AEditor: TKisEntityEditor); override;
    function GetProperties: String; override;
    function TransferContragentIntoStrings: TStringList; override;
  public
    constructor Create(Mngr: TKisMngr); override;
    destructor Destroy; override;
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    function IsEmpty: Boolean; override;
    function Equals(Entity: TKisEntity): Boolean; override;
    property CertId: Integer read GetCertId write SetCertId;
    property Certificate: TKisEntity read FCert write SetCert;
  end;

  TKisContragentMngr = class(TKisSQLMngr)
    dsContrs: TIBDataSet;
    dsContrsID: TIntegerField;
    dsContrsTYPE_ID: TIntegerField;
    dsContrsNAME: TIBStringField;
    dsContrsNAME_SHORT: TIBStringField;
    dsContrsADDRESS_1_ID: TIntegerField;
    dsContrsADDRESS_1: TIBStringField;
    dsContrsADDRESS_2_ID: TIntegerField;
    dsContrsADDRESS_2: TIBStringField;
    dsContrsPHONES: TIBStringField;
    dsContrsINN: TIBStringField;
    dsContrsBANK_ID: TIntegerField;
    dsContrsBANK_ACCOUNT: TIBStringField;
    dsContrsBANK_NAME: TIBStringField;
    dsContrsBIK: TIBStringField;
    dsContrsCOMMENTS: TIBStringField;
    dsContrsPARENT_ID: TIntegerField;
    procedure acDeleteUpdate(Sender: TObject);
    procedure acEditUpdate(Sender: TObject);
    procedure acInsertUpdate(Sender: TObject);
    procedure acInsertExecute(Sender: TObject);
    function GetParentId(ID: Integer): Integer;
  private
    FOldShowHandler: TNotifyEvent;
    procedure SaveCommon(Entity: TKisContragent);
    procedure SaveAccounts(Entity: TKisContragent);
    procedure DeleteCommon(Entity: TKisContragent);
    procedure SavePerson(Entity: TKisContragentPerson);
    procedure DeletePerson(Entity: TKisContragentPerson);
    procedure SaveOrg(Entity: TKisContragentOrganisation);
    procedure DeleteOrg(Entity: TKisContragentOrganisation);
    procedure SavePrivate(Entity: TKisContragentPrivate);
    procedure DeletePrivate(Entity: TKisContragentPrivate);
    procedure DeleteAccount(Account: TKisContragentAccount);
    procedure LoadContragent(TheEntity: TKisContragent; DataSet: TDataSet);
    procedure LoadAccounts(Entity: TKisContragent);
    procedure LoadPerson(Entity: TKisContragentPerson);
    procedure LoadPrivate(Entity: TKisContragentPrivate);
    procedure LoadOrg(Entity: TKisContragentOrganisation);
    procedure SetContragentFilterType;
    procedure ChangeViewFilter(Sender: TObject);
  protected
    function GenEntityID(EntityKind: TKisEntities = keDefault): Integer; override;
    procedure Activate; override;
    procedure Deactivate; override;
    procedure CreateView; override;
    function IsSupported(Entity: TKisEntity): Boolean; override;
    function GetIdent: TKisMngrs; override;
    function GetMainSQLText: String; override;
    function GetRefreshSQLText: String; override;
    function GetMainDataSet: TDataSet; override;
    procedure Locate(AId: Integer; LocateFail: Boolean = False); override;
    procedure PrepareSQLHelper; override;
    function CheckInnUniqueness(Entity: TKisContragent): TKisEntity;
    function ContragentsComparison(EntityOld, EntityNew: TKisEntity): Boolean;
    procedure LoadDataIntoComparer(EntityOld, EntityNew: TKisEntity; AComparer: TFmContragentsComparison);
    procedure SafeEditEntity(Entity: TKisContragent);
    procedure Reopen; override;
    procedure IntShowEntities(aFilters: IKisFilters; StartID: Integer = -1); override;
  public
    constructor Create(AOwner: TComponent); override;
    function SelectEntity(NewView: Boolean = False; aFilters: IKisFilters = nil;
      ClearExistingFilters: Boolean = True; StartID: Integer = -1): TKisEntity; override;
    function CurrentEntity: TKisEntity; override;
    function GetEntity(EntityID: Integer; EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function CreateNewEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function EditEntity(Entity: TKisEntity): TKisEntity; override;
    procedure SaveEntity(Entity: TKisEntity); override;
    function DuplicateEntity(Entity: TKisEntity): TKisEntity; override;
    function IsEntityInUse(Entity: TKisEntity): Boolean; override;
    function DeleteEntity(Entity: TKisEntity): Boolean; override;
    function CreateEntity(EntityKind: TKisEntities): TKisEntity; override;
    procedure EditCurrent; override;
  end;

implementation

{$WARN UNSAFE_CODE OFF}
{$R *.dfm}

uses
  // System
  StdCtrls, IBDatabase, IBSQL, IBQuery,
  // Common
  uIBXUtils, uCommonUtils, uVCLUtils, uSQLParsers, uDataSet,
  // Project
  uKisContragentTypeDialog, uKisContragentEditor, uKisConsts, uKisIntf,
  uKisContragentPersonEditor, uKisContragentDocuments, uKisAppModule,
  uKisContragentAddresses, uKisUtils, uKisContragentOrgEditor,
  uKisContragentPrivateEditor, uKisMngrView, uKisSearchClasses;

const
  ID_CHIEFDOCTYPE_1 = 0; //  Устав
  ID_CHIEFDOCTYPE_2 = 1; //  доверенность
  ID_CHIEFDOCTYPE_3 = 2; //  положение
  ID_CHIEFDOCTYPE_4 = 3; //  постановление суда

  ID_CF_ALL = 'Все контрагенты';
  ID_CF_ORGS = 'Юр. лица';
  ID_CF_PRIVATES = 'ИП (ЧП)';
  ID_CF_PERSONS = 'Физ. лица';


resourcestring
  // Queries
  SQ_MAIN = 'SELECT * FROM CONTRAGENTS_VIEW';
  SQ_SAVE_CONTRAGENT = 'EXECUTE PROCEDURE SAVE_CONTRAGENT' + S_RET +
    '(:ID, :TYPE_ID, :NAME, :NAME_SHORT, :ADDRESS_1_ID,' + S_RET +
    ':ADDRESS_2_ID, :PHONES, :INN, :BANK_ID, :TYPE_ACCOUNT, :BANK_ACCOUNT, :COMMENTS, :PARENT_ID)';
  SQ_SAVE_PERSON = 'EXECUTE PROCEDURE SAVE_PERSON(%d, %d)';
  SQ_SAVE_PRIVATE = 'EXECUTE PROCEDURE SAVE_PRIVATE(%d, %d, %d)';
  SQ_SAVE_ORG = 'EXECUTE PROCEDURE SAVE_CONTR_ORG ( :ID, :CHIEF, :CHIEF_POST,'
    + S_RET + ':CHIEF_DOC_TYPE, :CHIEF_DOC_NUMBER, :CHIEF_DOC_DATE, :CHIEF_DOCS, :CONTACTER, :CONTACTER_POST, :CONTACTER_PHONES,'
    + S_RET + ':ACCOUNTANT, :KPP, :OKPF, :OKPO, :OKONH, :SUBDIVISION_ID,'
    + S_RET + ':HEAD_ORG_ID)';
  SQ_CONTR_IN_USE = 'SELECT COUNT(*) FROM ORDERS WHERE CONTRAGENTS_ID=%d OR PAYER_ID=%d';
  SQ_DELETE_CONTR = 'DELETE FROM CONTRAGENTS WHERE ID=%d';
  SQ_DELETE_PERSON = 'DELETE FROM CONTR_PERSONS WHERE ID=%d';
  SQ_DELETE_PRIVATE = 'DELETE FROM CONTR_PRIVATES WHERE ID=%d';
  SQ_DELETE_ORG = 'DELETE FROM CONTR_ORGS WHERE ID=%d';
  SQ_SELECT_CONTR = 'SELECT * FROM CONTRAGENTS WHERE ID=%d';
  SQ_SELECT_PERSON_DOC = 'SELECT DOC_ID FROM CONTR_PERSONS WHERE ID=%d';
  SQ_SELECT_PRIVATE = 'SELECT DOC_ID, CERTIF_ID FROM CONTR_PRIVATES WHERE ID=%d';
  SQ_SELECT_ORG = 'SELECT * FROM CONTR_ORGS WHERE ID=%d';
  SQ_CHECK_INN = 'SELECT C.ID FROM CONTRAGENTS_ACTUAL CA, CONTRAGENTS C '
    + 'WHERE CA.CONTRAGENTS_ID=C.ID AND (C.INN = %s) AND (C.PARENT_ID <> %d)';
//  SQ_CHECK_KPP = 'SELECT ID FROM CONTR_ORGS WHERE (KPP = %s) AND (ID <> %d)'
//     + ' AND ID IN (SELECT ID FROM CONTRAGENTS_VIEW WHERE (INN =%s) AND (PARENT_ID <> %d))';
  SQ_CHECK_KPP = 'SELECT ID '
    + 'FROM CONTRAGENTS_ACTUAL CA '
    + 'INNER JOIN CONTR_ORGS CO ON (CA.CONTRAGENTS_ID=CO.ID) '
    + 'INNER JOIN CONTRAGENTS C ON (CO.ID=C.ID) '
    + 'WHERE '
    + 'CO.KPP = %s AND '
    + 'CO.ID <> %d AND '
    + 'C.INN = %s AND '
    + 'C.PARENT_ID <> %d';

{ TKisContragent }

function TKisContragent.CheckEditor(AEditor: TKisEntityEditor): Boolean;
begin
  Result := False;
  with AEditor as TKisContragentEditor do
  begin
    if Length(Trim(edName.Text)) < 5 then
    begin
      edName.SetFocus;
      MessageBox(Handle, PChar(S_CHECK_NAME), PChar(S_WARN), MB_ICONWARNING);
      Exit;
    end;
    if edNameShort.Visible then
    if (Length(Trim(edNameShort.Text)) < 5) then
    begin
      edNameShort.SetFocus;
      MessageBox(Handle, PChar(S_CHECK_SHORTNAME), PChar(S_WARN), MB_ICONWARNING);
      Exit;
    end;
    if cntrAddress in FEditorOptions then
    begin
      if Trim(edAddr1.Text) = '' then
      begin
        edAddr1.SetFocus;
        MessageBox(Handle, PChar(S_CHECK_ADDRESS1), PChar(S_WARN), MB_ICONWARNING);
        Exit;
      end;
    end;
    //
    case ContrType of
    CT_PERSON :
      begin
        if cntrINN in FEditorOptions then
        begin
          if (Length(edINN.Text) > 0)
             and (Length(edINN.Text) <> 12)
  //           and not CheckINN12(edINN.Text)
          then
          begin
            edINN.SetFocus;
            MessageBox(Handle, PChar(S_CHECK_INN), PChar(S_WARN), MB_ICONWARNING);
            Exit;
          end;
        end;
      end;
    CT_PRIVATE :
      begin
        if cntrINN in FEditorOptions then
        begin
          if (Length(edINN.Text) > 0)
             and
             (Length(edINN.Text) <> 12)
  //           and not CheckINN12(edINN.Text)
          then
          begin
            edINN.SetFocus;
            MessageBox(Handle, PChar(S_CHECK_INN), PChar(S_WARN), MB_ICONWARNING);
            Exit;
          end;
        end;
      end;
    CT_ORG :
      begin
        if cntrINN in FEditorOptions then
        begin
          if {(Length(edINN.Text) > 0) and }
             (Length(edINN.Text) <> 10)
             // or not CheckINN10(edINN.Text)
          then
          begin
            edINN.SetFocus;
            MessageBox(Handle, PChar(S_CHECK_INN), PChar(S_WARN), MB_ICONWARNING);
            Exit;
          end;
        end;
      end;
    end;
  end;
  Result := True;
end;

procedure TKisContragent.Copy(Source: TKisEntity);
begin
  inherited;
  with Source as TKisContragent do
  begin
    Self.FName := Name;
    Self.FShortName := ShortName;
    Self.FPhones := Phones;
    Self.FINN := INN;
    Self.FBankAccount := BankAccount;
    Self.FTypeAccount := TypeAccount;
    Self.Comment := Comment;
    Self.FAddress1.Assign(Address1);
    Self.FAddress2.Assign(Address2);
    Self.FParentId := ParentId;
    Self.CopyAccount(Source);
    Self.CopyAccountCtrlr(Source);
  end;
end;

constructor TKisContragent.Create;
begin
  inherited;
  FEditorOptions := [];
  FComment := nil;
  FTypeAccount := 1;
  FAddress1 := AppModule[kmContrAddresses].CreateEntity(keContrAddress);
  FAddress2 := AppModule[kmContrAddresses].CreateEntity(keContrAddress);
  FBank := AppModule[kmBanks].CreateEntity(keBank);
  FAccounts := TCustomDataSet.Create(nil);
  FAccountsCtrlr := TKisContrAccountCtrlr.CreateController(nil, AppModule[kmAccounts], keContragentAccount);
  FAccountsCtrlr.HeadEntity := Self;
  FAccountsCtrlr.ElementType := keContragentAccount;
end;

function TKisContragent.CreateEditor: TKisEntityEditor;
begin
  Result := TKisContragentEditor.Create(Application);
  EntityEditor := Result;
end;

function TKisContragentMngr.CreateEntity(EntityKind: TKisEntities): TKisEntity;
begin
  case EntityKind of
  keContrPerson:
    Result := TKisContragentPerson.Create(Self);
  keContrOrg:
    Result := TKisContragentOrganisation.Create(Self);
  keContrPrivate:
    Result := TKisContragentPrivate.Create(Self);
  keContragentAccount :
    Result := TKisContragentAccount.Create(Self);
  keDefault :
    Result := TKisContragent.Create(Self);
  else
    Result := nil;
  end;
end;

destructor TKisContragent.Destroy;
begin
  FAccounts.Free;
  FreeAndNil(FDefaultAccount);
  if Assigned(FComment) then
    FComment.Free;
  FAddress1.Free;
  FAddress2.Free;
  inherited;
end;

procedure TKisContragent.PrepareEditor(AEditor: TKisEntityEditor);
begin
  inherited;
  with EntityEditor as TKisContragentEditor do
  begin
    btnAddress1.OnClick := SelectAddress1;
    btnAddress2.OnClick := SelectAddress2;
    btnAddress1.Enabled := not ReadOnly;
    btnAddress2.Enabled := not ReadOnly;
    btnBank.OnClick := SelectBank;
    btnBank.Enabled := not ReadOnly;
    cbKindAccount.Enabled := not ReadOnly;
    IDLabel.Visible := AppModule.User.IsAdministrator;
  end;
end;

class function TKisContragent.EntityName: String;
begin
  Result := S_CONTRAGENT;
end;

function TKisContragent.Equals(Entity: TKisEntity): Boolean;
begin
  try
    Result := inherited Equals(Entity);
  except
    Result := False;
  end;
  Result := Result and Assigned(Entity);
  if Result then
    with Entity as TKisContragent do
    begin
      Result := ContrType = Self.FContrType;
      if Result then
      Result := (Self.FContrType = ContrType) and (Self.FName = Name)
        and (Self.FBankAccount = BankAccount) and (Self.FTypeAccount = TypeAccount)
        and (Self.FShortName = ShortName)
        and (Self.FComment.Text = Comment.Text) and (Self.BankId = BankId)
        and Self.FDefaultAccount.Equals(FDefaultAccount) and Self.FAddress1.Equals(Address1)
        and Self.Address2.Equals(Address2);
    end;
end;

function TKisContragent.GetAddress1Id: Integer;
begin
  Result := FAddress1.ID;
end;

function TKisContragent.GetAddress2Id: Integer;
begin
  Result := FAddress2.ID;
end;

function TKisContragent.GetBankId: Integer;
begin
  if Assigned(FDefaultAccount) then
    Result := FDefaultAccount.BankId
  else
    Result := 0;
end;

function TKisContragent.GetComment: TStrings;
begin
  if not Assigned(FComment) then
    FComment := TStringList.Create;
  Result := FComment;
end;

function TKisContragent.GetProperties: String;
begin
  Result := '';
end;

function TKisContragent.GetText: String;
begin
  Result := FName;
end;

function TKisContragent.IsEmpty: Boolean;
begin
  Result := (FBankAccount = '') and (Comment.Text = '')
    and (FINN = '') and (FName = '')
    and (FShortName = '') and (FPhones = '')
    and FAddress1.IsEmpty and FAddress2.IsEmpty and FBank.IsEmpty;
end;

procedure TKisContragent.LoadDataIntoEditor(AEditor: TKisEntityEditor);
begin
  if Assigned(AEditor) then
  with AEditor as TKisContragentEditor do
  begin
    IDLabel.Caption := IntToStr(Self.ID);
    edName.Text := Self.Name;
    edNameShort.Text := Shortname;
    edAddr1.Text := FAddress1.AsText;
    edAddr2.Text := FAddress2.AsText;
    edPhones.Text := Phones;
    if INN = '' then
      edINN.Clear
    else
      edINN.Text := INN;
    edBank.Text := BankName;
    if BankAccount = '' then
      edBankAccount.Clear
    else
      edBankAccount.Text := BankAccount;
    cbKindAccount.ItemIndex := TypeAccount;
    mComment.Lines := Self.Comment;
  end;
end;

procedure TKisContragent.ReadDataFromEditor(AEditor: TKisEntityEditor);
begin
  inherited;
  with AEditor as TKisContragentEditor do
  begin
    Self.Name := Trim(edName.Text);
    Self.ShortName := Trim(edNameShort.Text);
    Self.BankAccount := Trim(edBankAccount.Text);
    Self.TypeAccount := cbKindAccount.ItemIndex;
    Self.INN := Trim(edINN.Text);
    Self.Phones := Trim(edPhones.Text);
    Self.Comment := mComment.Lines;
  end;
end;

procedure TKisContragent.SelectAddress1(Sender: TObject);
var
  Address: TKisEntity;
begin
  if Assigned(SQLMngr.DefaultTransaction) then
    AppModule.SQLMngrs[kmContrAddresses].DefaultTransaction := SQLMngr.DefaultTransaction;
  try
    Address := AppModule.SQLMngrs[kmContrAddresses].CreateNewEntity;
    if Assigned(Address1) then
      Address.Copy(Address1);
    if TKisVisualEntity(Address).Edit then
    begin
      Address1 := Address;
      UpdateAddress1;
    end
    else
      Address.Free;
  finally
    if Assigned(SQLMngr.DefaultTransaction) then
        AppModule.SQLMngrs[kmContrAddresses].DefaultTransaction := nil;
  end;
  CopyJurAddress(nil);
end;

procedure TKisContragent.SelectAddress2(Sender: TObject);
var
  Address: TKisEntity;
begin
  if Assigned(SQLMngr.DefaultTransaction) then
    AppModule.SQLMngrs[kmContrAddresses].DefaultTransaction := SQLMngr.DefaultTransaction;
  try
    Address := AppModule.SQLMngrs[kmContrAddresses].CreateNewEntity;
    if Assigned(Address2) then
      Address.Copy(Address2);
    if TKisVisualEntity(Address).Edit then
    begin
      Address2 := Address;
      UpdateAddress2;
    end
    else
      FreeAndNil(Address);
  finally
    if Assigned(SQLMngr.DefaultTransaction) then
        AppModule.SQLMngrs[kmContrAddresses].DefaultTransaction := nil;
  end;
end;

procedure TKisContragent.SelectBank(Sender: TObject);
var
  theAccount: TKisContragentAccount;
  Pt: TPoint;
begin
  if Assigned(EntityEditor) then
  with TKisContragentEditor(EntityEditor) do
    Pt := gbBank.ClientToScreen(Point(cbKindAccount.Left, gbBank.ClientHeight));
  // Здесь будем показывать окно с банковскими счетами
  if FAccountsCtrlr.ShowEditor(Pt, theAccount) then
    if Assigned(theAccount) then
    begin
      if not Assigned(FDefaultAccount) then
      begin
        FDefaultAccount := theAccount;
        Modified := True;
      end
      else
        if not FDefaultAccount.Equals(theAccount) then
        begin
          FDefaultAccount.Free;
          FDefaultAccount := theAccount;
          Modified := True;
        end;
      UpdateBank;
    end;
end;

procedure TKisContragent.SetAddress1(const Value: TKisEntity);
begin
  if not FAddress1.Equals(Value) then
  begin
    FAddress1.Assign(Value);
    Modified := True;
  end;
end;

procedure TKisContragent.SetAddress1Id(const Value: Integer);
begin
  if FAddress1.ID <> Value then
  begin
    Address1 := AppModule[kmContrAddresses].GetEntity(Value);
    Modified := True;
  end;
end;

procedure TKisContragent.SetAddress2(const Value: TKisEntity);
begin
  if not FAddress2.Equals(Value) then
  begin
    FAddress2.Assign(Value);
    Modified := True;
  end;
end;

procedure TKisContragent.SetAddress2Id(const Value: Integer);
begin
  if FAddress2.ID <> Value then
  begin
    Address2 := AppModule[kmContrAddresses].GetEntity(Value);
    Modified := True;
  end;
end;

procedure TKisContragent.SetBank(const Value: TKisEntity);
begin
  if Assigned(Value) and not FBank.Equals(Value) then
  begin
    FBank.Assign(Value);
    Modified := True;
  end;
end;

procedure TKisContragent.SetBankAccount(const Value: String);
begin
  if FBankAccount <> Value then
  begin
    FBankAccount := Value;
    Modified := True;
  end;
end;

procedure TKisContragent.SetBankId(const Value: Integer);
begin
  if FBank.ID <> Value then
  begin
    FBank.Assign(AppModule[kmBanks].GetEntity(Value));
    Modified := True;
  end;
end;

procedure TKisContragent.SetComment(const Value: TStrings);
begin
  if not Assigned(FComment) then
    FComment := TStringList.Create;
  if not FComment.Equals(Value) then
  begin
    FComment.Assign(Value);
    Modified := True;
  end;
end;

procedure TKisContragent.SetINN(const Value: String);
begin
  CheckINN(Value);
  if FINN <> Value then
  begin
    Modified := True;
    FINN := Value;
  end;
end;

procedure TKisContragent.SetName(const Value: String);
begin
  if FName <> Value then
  begin
    FName := Value;
    Modified := True;
  end;
end;

procedure TKisContragent.SetPhones(const Value: String);
begin
  if FPhones <> Value then
  begin
    FPhones := Value;
    Modified := True;
  end;
end;

procedure TKisContragent.SetShortName(const Value: String);
begin
  if FShortName <> Value then
  begin
    FShortName := Value;
    Modified := True;
  end;
end;

procedure TKisContragent.UpdateAddress1;
begin
  if Assigned(EntityEditor) then
    TKisContragentEditor(EntityEditor).edAddr1.Text := FAddress1.AsText
end;

procedure TKisContragent.UpdateAddress2;
begin
  if Assigned(EntityEditor) then
    TKisContragentEditor(EntityEditor).edAddr2.Text := FAddress2.AsText
end;

procedure TKisContragent.UpdateBank;
begin
  if Assigned(EntityEditor) then
{  if Assigned(FBank) then
    TKisContragentEditor(EntityEditor).edBank.Text := FBank.AsText
  else
    TKisContragentEditor(EntityEditor).edBank.Clear;}
  with TKisContragentEditor(EntityEditor) do
  if Assigned(FDefaultAccount) then
  begin
    edBank.Text := BankName;
    edBankAccount.Text := BankAccount;
    cbKindAccount.ItemIndex := TypeAccount;
  end
  else
  begin
    edBank.Clear;
    edBankAccount.Clear;
    cbKindAccount.ItemIndex := -1;
  end;
end;

procedure TKisContragent.SetTypeAccount(const Value: Integer);
begin
  if FTypeAccount <> Value then
  begin
    FTypeAccount := Value;
    Modified := True;
  end;
end;

function TKisContragent.TransferContragentIntoStrings: TStringList;
begin
  Result := TStringList.Create;
  with Result do
  begin
    Add('Наименование='+FName);
    Add('Краткое наименование='+FShortName);
    Add('Банк='+FBankAccount);
    if FTypeAccount = 1 then
      Add('Тип счета='+'Р/счет')
    else
      Add('Тип счета='+'Л/счет');
    Add('ИНН='+FINN);
    Add('Телефоны='+FPhones);
    Add('Адрес юридический='+ FAddress1.AsText);
    Add('Адрес фактический='+ FAddress2.AsText);
  end;
end;

function TKisContragent.CustomerRepresentativeName: String;
begin
  Result := '';
end;

procedure TKisContragent.CopyJurAddress(Sender: TObject);
begin
  if Assigned(EntityEditor) then
  with TKisContragentEditor(EntityEditor) do
  begin
    if Trim(edAddr2.Text) = '' then
    begin
     CopyJurToFactAddress;
     UpdateAddress2;
    end;
  end;
end;

procedure TKisContragent.CopyJurToFactAddress;
begin
  Address2 := Address1;
  Address2.ID := 0;
end;

function TKisContragent.GetTypeAccount: Integer;
begin
  if Assigned(FDefaultAccount) then
    Result := Integer(FDefaultAccount.AccountType)
  else
    Result := 0;
end;

function TKisContragent.GetBankAccount: String;
begin
  if Assigned(FDefaultAccount) then
    Result := FDefaultAccount.Number
  else
    Result := ''; 
end;

function TKisContragent.GetBankName: String;
begin
  if Assigned(FDefaultAccount) then
    Result := FDefaultAccount.BankName
  else
    Result := '';
end;

procedure TKisContragent.CopyAccount(Source: TKisEntity);
begin
  with TKisContragent(Source) do
    if Assigned(FDefaultAccount) then
    begin
      FreeAndNil(Self.FDefaultAccount);
      Self.FDefaultAccount := TKisContragentAccount(AppModule[kmAccounts].CreateEntity);
      Self.FDefaultAccount.Assign(FDefaultAccount);
    end
    else
    begin
      FreeAndNil(Self.FDefaultAccount);
    end;
end;

function TKisContragent.GetBankAccountEntity: TKisContragentAccount;
begin
  if Assigned(FDefaultAccount) then
  begin
    Result := FDefaultAccount.Clone;
  end
  else
    Result := nil;
end;

procedure TKisContragent.CopyAccountCtrlr(Source: TKisEntity);
var
  I: Integer;
  SourceCtrlr: TKisContrAccountCtrlr;
begin
  Self.FAccountsCtrlr.DirectClear;
  SourceCtrlr := TKisContragent(Source).FAccountsCtrlr;
  for I := 1 to SourceCtrlr.GetRecordCount do
    FAccountsCtrlr.DirectAppend(SourceCtrlr.Accounts[I].Clone);
end;

{ TKisContragentPerson }

procedure TKisContragentPerson.CheckDocId(const Value: Integer);
begin
  ;
end;


function TKisContragentPerson.CheckEditor(AEditor: TKisEntityEditor): Boolean;

begin
  Result := inherited CheckEditor(AEditor);
  if not Result then Exit;
  with AEditor as TKisContragentPersonEditor do
  begin
    if persDocType in FEditorOptions then
    begin
      if cbDocType.ItemIndex < N_ZERO then
      begin
        cbDocType.SetFocus;
        Result := False;
        MessageBox(Handle, PChar(S_CHECK_DOCTYPE), PChar(S_WARN), MB_ICONWARNING);
        Exit;
      end;
    end;
    if persDocNumber in FEditorOptions then
    begin
      if Trim(edDocNumber.Text) = '' then
      begin
        edDocNumber.SetFocus;
        Result := False;
        MessageBox(Handle, PChar(S_CHECK_DOCNUMBER), PChar(S_WARN), MB_ICONWARNING);
        Exit;
      end;
    end;
    if persDocSerie in FEditorOptions then
    begin
      if Trim(edDocSerie.Text) = '' then
      begin
        edDocSerie.SetFocus;
        Result := False;
        MessageBox(Handle, PChar(S_CHECK_DOCSERIE), PChar(S_WARN), MB_ICONWARNING);
        Exit;
      end;
    end;
    if persDocOwner in FEditorOptions then
    begin
      if Length(Trim(cbDocOwner.Text)) < 12 then
      begin
        cbDocOwner.SetFocus;
        Result := False;
        MessageBox(Handle, PChar(S_CHECK_DOCOWNER), PChar(S_WARN), MB_ICONWARNING);
        Exit;
      end;
    end;
    if persDocDate in FEditorOptions then
    begin
      if (dtpDocDate.Date < MIN_DOC_DATE) or (dtpDocDate.Date > Date) then
      begin
        dtpDocDate.SetFocus;
        Result := False;
        MessageBox(Handle, PChar(S_CHECK_DOCDATE), PChar(S_WARN), MB_ICONWARNING);
        Exit;
      end;
    end;
  end;
end;

procedure TKisContragentPerson.Copy(Source: TKisEntity);
begin
  inherited;
  with Source as TKisContragentPerson do
  begin
    Self.Doc := Doc;
  end;
end;

constructor TKisContragentPerson.Create(Mngr: TKisMngr);
begin
  inherited;
  FContrType := CT_PERSON;
  FDoc := AppModule[kmContrDocs].CreateEntity(keContrDoc);
  FEditorOptions := [];
end;

function TKisContragentPerson.CreateEditor: TKisEntityEditor;
begin
  EntityEditor := TKisContragentPersonEditor.Create(Application);
  Result := EntityEditor;
end;

function TKisContragentPerson.CustomerRepresentativeName: String;
begin
  Result := ShortName;
end;

destructor TKisContragentPerson.Destroy;
begin
  FDoc.Free;
  inherited;
end;

class function TKisContragentPerson.EntityName: String;
begin
  Result := SEN_CONTR_PERSON;
end;

function TKisContragentPerson.Equals(Entity: TKisEntity): Boolean;
begin
  Result := inherited Equals(Entity);
  if Entity is TKisContragentPerson then
    Result := Result and FDoc.Equals(TKisContragentPerson(Entity).Doc); 
end;

function TKisContragentPerson.GetDoc: TKisEntity;
begin
  Result := FDoc;
end;

function TKisContragentPerson.GetDocId: Integer;
begin
  Result := FDoc.ID;
end;

function TKisContragentPerson.GetProperties: String;
begin
  Result := Self.Doc.AsText;
end;

function TKisContragentPerson.GetText: String;
begin
  Result := FName;
end;

function TKisContragentPerson.IsEmpty: Boolean;
begin
  Result := inherited IsEmpty and FDoc.IsEmpty;
end;

procedure TKisContragentPerson.LoadDataIntoEditor(AEditor: TKisEntityEditor);
var
  Lst: TStringList;
begin
  inherited;
  with AEditor as TKisContragentPersonEditor do
  begin
    Lst := AppModule.Lists[klPersonDoc];
    Lst.Forget;
    cbDocType.Items := Lst;
    if Assigned(Doc) then
    begin
      with Self.Doc as TKisContragentDocument do
      begin
        cbDocType.ItemIndex := cbDocType.Items.IndexOfObject(Pointer(DocKind));
        edDocNumber.Text := Number;
        edDocSerie.Text := Series;
        dtpDocDate.Date := DocDate;
        cbDocOwner.Text := GivenBy;
      end;
    end
    else
    begin
      cbDocType.ItemIndex := -1;
      edDocNumber.Clear;
      edDocSerie.Clear;
      dtpDocDate.Date := Date;
      cbDocOwner.Clear;
    end;
  end;
end;

procedure TKisContragentPerson.PrepareEditor(AEditor: TKisEntityEditor);
var
  Lst: TStringList;
begin
  inherited;
  with AEditor as TKisContragentPersonEditor do
  begin
    cbDocType.Enabled := not Self.ReadOnly;
    edDocNumber.Enabled := not Self.ReadOnly;
    edDocSerie.Enabled := not Self.ReadOnly;
    dtpDocDate.Enabled := not Self.ReadOnly;
    cbDocOwner.Enabled := not Self.ReadOnly;
    edINN.MaxLength := 12;
    Lst := AppModule.Lists[klPersonDocOwner];
    Lst.Forget;
    cbDocOwner.Items := Lst;
    cbDocOwner.ItemIndex := -1;
  end;
end;

procedure TKisContragentPerson.ReadDataFromEditor(AEditor: TKisEntityEditor);
begin
  inherited;
  with AEditor as TKisContragentPersonEditor do
  with Self.Doc as TKisContragentDocument do
  begin
    if cbDocType.ItemIndex < 0 then
      DocKind := -1
    else
      DocKind := Integer(cbDocType.Items.Objects[cbDocType.ItemIndex]);
    Number := Trim(edDocNumber.Text);
    Series := Trim(edDocSerie.Text);
    DocDate := dtpDocDate.Date;
    GivenBy := Trim(cbDocOwner.Text);
    Self.ShortName := Self.Name;
  end;
  if Self.Doc.Modified then
    Self.Modified := True;
end;

procedure TKisContragentPerson.SetDoc(const Value: TKisEntity);
begin
  if not FDoc.Equals(Value) then
  begin
    FDoc.Assign(Value);
    Modified := True;
  end;
end;

procedure TKisContragentPerson.SetDocId(const Value: Integer);
var
  TmpDoc: TKisEntity;
begin
  CheckDocId(Value);
  if FDoc.Id <> Value then
  begin
    TmpDoc := AppModule[kmContrDocs].GetEntity(Value);
    if Assigned(TmpDoc) then
      Doc := TmpDoc;
    TmpDoc.Free;
    Modified := True;
  end;
end;

function TKisContragentPerson.TransferContragentIntoStrings: TStringList;
var
  V: Variant;
begin
  Result := inherited TransferContragentIntoStrings;
  with Result do
  begin
    if Assigned(Doc) then
    begin
      with Self.Doc as TKisContragentDocument do
      begin
        if AppModule.GetFieldValue(AppModule.SQLMngrs[kmContragents].DefaultTransaction, ST_PERSON_DOC_TYPES, SF_ID, SF_NAME, DocKind, V) then
          Add('Тип документа, удостоверяющего личность='+V);
        Add('Серия='+Series);
        Add('Номер='+Number);
        Add('Когда выдан='+DateToStr(DocDate));
        Add('Кем выдан='+GivenBy);
      end;
    end;
  end;
end;

{ TKisContragentMngr }

procedure TKisContragentMngr.Activate;
begin
  inherited;
  dsContrs.Transaction := AppModule.Pool.Get;
  dsContrs.Transaction.Init();
  if not dsContrs.Transaction.Active then
    dsContrs.Transaction.StartTransaction;
  Reopen;
end;

function TKisContragentMngr.CreateNewEntity(EntityKind: TKisEntities): TKisEntity;
begin
  Result := nil;
  with TKisContragentTypeDialog.Create(Self) do
  begin
    RadioGroup1.ItemIndex := N_ZERO;
    if ShowModal = mrOk then
    begin
      case RadioGroup1.ItemIndex of
      0 :  Result := Self.CreateEntity(keContrOrg);
      1 :  Result := Self.CreateEntity(keContrPerson);
      2 :  Result := Self.CreateEntity(keContrPrivate);
      end;
      Result.ID := GenEntityID();
    end;
    Free;
  end;
end;

procedure TKisContragentMngr.Deactivate;
begin
  InSearch := False;
  if dsContrs.Transaction.Active then
    dsContrs.Transaction.Commit;
  AppModule.Pool.Back(dsContrs.Transaction);
  dsContrs.Transaction := nil;
  inherited;
end;

function TKisContragentMngr.GenEntityID(EntityKind: TKisEntities = keDefault): Integer;
begin
  Result := AppModule.GetID(SG_CONTRAGENTS, Self.DefaultTransaction);
end;

procedure TKisContragentMngr.SaveCommon(Entity: TKisContragent);
var
  Conn: IKisConnection;
  DataSet: TDataSet;
begin
  Conn := GetConnection(True, True);
  while (Entity.ID = 0) or IsEntityInUse(Entity) do
  begin
    Entity.ID := Self.GenEntityID();
    if Entity.ParentId = 0 then
      Entity.ParentId := Entity.ID;
  end;
  // Сохраняем адреса
  with AppModule.SQLMngrs[kmContrAddresses] do
  begin
    DefaultTransaction := Self.DefaultTransaction;
    if not Entity.Address1.IsEmpty then
      SaveEntity(Entity.Address1);
    if not Entity.Address2.IsEmpty then
      SaveEntity(Entity.Address2);
    DefaultTransaction := nil;
  end;
  // Сохранеям контрагента
  DataSet := Conn.GetDataSet(SQ_SAVE_CONTRAGENT);
  Conn.SetParam(DataSet, SF_ID, Entity.ID);
  Conn.SetParam(DataSet, SF_NAME, Entity.Name);
  Conn.SetParam(DataSet, SF_NAME_SHORT, Entity.ShortName);
  Conn.SetParam(DataSet, SF_TYPE_ID, Entity.ContrType);
  Conn.SetParam(DataSet, SF_ADDRESS_1_ID, Entity.Address1Id);
  if Entity.Address2Id = 0 then
    Conn.SetParam(DataSet, SF_ADDRESS_2_ID, NULL)
  else
    Conn.SetParam(DataSet, SF_ADDRESS_2_ID, Entity.Address2Id);
  Conn.SetParam(DataSet, SF_PHONES, Entity.Phones);
  Conn.SetParam(DataSet, SF_INN, Entity.INN);
  Conn.SetParam(DataSet, SF_BANK_ID, Entity.BankId);
  Conn.SetParam(DataSet, SF_TYPE_ACCOUNT, Entity.TypeAccount);
  Conn.SetParam(DataSet, SF_BANK_ACCOUNT, Entity.BankAccount);
  Conn.SetParam(DataSet, SF_PARENT_ID, Entity.ParentId);
  if Entity.Comment.Text = '' then
      Conn.SetParam(DataSet, SF_COMMENTS, NULL)
  else
    Conn.SetParam(DataSet, SF_COMMENTS, Entity.Comment.Text);
  DataSet.Open;
  // Сохраняем счета
  SaveAccounts(Entity);
end;

procedure TKisContragentMngr.SavePerson(Entity: TKisContragentPerson);
var
  Conn: IKisConnection;
  ContrDocMngr: TKisSQLMngr;
begin
  // Подготовка транзакции
  Conn := GetConnection(True, True);
  // Сохранение данных
  try
    SaveCommon(Entity);
    ContrDocMngr := AppModule.SQLMngrs[kmContrDocs];
    ContrDocMngr.DefaultTransaction := Conn.Transaction;
    try
      ContrDocMngr.SaveEntity(Entity.Doc);
    finally
      ContrDocMngr.DefaultTransaction := nil;
    end;
    with Conn.GetDataSet(Format(SQ_SAVE_PERSON, [Entity.ID, Entity.DocId])) do
      Open;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisContragentMngr.SaveEntity(Entity: TKisEntity);
var
  Conn: IKisConnection;
begin
  AppModule.Logging := True;
  if Entity is TKisContragent then
  begin
    Conn := GetConnection(True, True);
    try
      case TKisContragent(Entity).ContrType of
      CT_PERSON :
       SavePerson(TKisContragentPerson(Entity));
      CT_ORG :
        SaveOrg(TKisContragentOrganisation(Entity));
      CT_PRIVATE :
        SavePrivate(TKisContragentPrivate(Entity));
      end;
      FreeConnection(Conn, True);
    except
      FreeConnection(Conn, False);
      raise;
    end;
  end
  else
    raise EUnsupportedEntity.Create(TKisContragentMngr, Entity.ClassType);
  if Assigned(FView) and FView.Visible then
  try
    FView.Grid.SetFocus;
  except
  end;
  AppModule.Logging := False;
end;

procedure TKisContragentMngr.SaveOrg(Entity: TKisContragentOrganisation);
var
  Conn: IKisConnection;
  DataSet: TDataSet;
begin
  Conn := GetConnection(True, True);
  // Подготовка транзакции
  try
    SaveCommon(Entity);
    DataSet := Conn.GetDataSet(SQ_SAVE_ORG);
    with Entity do
    begin
      Conn.SetParam(DataSet, SF_ID, ID);
      Conn.SetParam(DataSet, SF_CHIEF, Chief);
      Conn.SetParam(DataSet, SF_CHIEF_POST, ChiefPost);
      Conn.SetParam(DataSet, SF_CHIEF_DOC_TYPE, ChiefDocType);
      Conn.SetParam(DataSet, SF_CHIEF_DOC_NUMBER, ChiefDocNumber);
      Conn.SetParam(DataSet, SF_CHIEF_DOC_DATE, DateToStr(ChiefDocDate));
      Conn.SetParam(DataSet, SF_CHIEF_DOCS, ChiefDocs);
      Conn.SetParam(DataSet, SF_CONTACTER, Contacter);
      Conn.SetParam(DataSet, SF_CONTACTER_POST, ContacterPost);
      Conn.SetParam(DataSet, SF_CONTACTER_PHONES, ContacterPhones);
      Conn.SetParam(DataSet, SF_ACCOUNTANT, Accountant);
      Conn.SetParam(DataSet, SF_KPP, KPP);
      Conn.SetParam(DataSet, SF_OKPF, OKPF);
      Conn.SetParam(DataSet, SF_OKPO, OKPO);
      Conn.SetParam(DataSet, SF_OKONH, OKONH);
      if SubdivisionId > 0 then
      Conn.SetParam(DataSet, SF_SUBDIVISION_ID, SubdivisionId)
      else
        Conn.SetParam(DataSet, SF_SUBDIVISION_ID, NULL);
      if HeadOrgId > 0 then
        Conn.SetParam(DataSet, SF_HEAD_ORG_ID, HeadOrgId)
      else
        Conn.SetParam(DataSet, SF_HEAD_ORG_ID, NULL);
    end;
    DataSet.Open;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisContragentMngr.SavePrivate(Entity: TKisContragentPrivate);
var
  Conn: IKisConnection;
  M: TKisSQLMngr;
begin
  Conn := GetConnection(True, True);
  try
    SaveCommon(Entity);
    M := AppModule.SQLMngrs[kmContrDocs];
    M.DefaultTransaction := Conn.Transaction;
    try
      M.SaveEntity(Entity.Doc);
    finally
      M.DefaultTransaction := nil;
    end;
    //
    M := AppModule.SQLMngrs[kmContrCertificates];
    M.DefaultTransaction := Conn.Transaction;
    try
      M.SaveEntity(Entity.Certificate);
    finally
      M.DefaultTransaction := nil;
    end;
    with Conn.GetDataSet(Format(SQ_SAVE_PRIVATE, [Entity.ID, Entity.DocId, Entity.CertId])) do
      Open;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

function TKisContragentMngr.EditEntity(Entity: TKisEntity): TKisEntity;
begin
  inherited;
  Result := Entity.Create(Self);
  Result.Assign(Entity);
  if Result is TKisVisualEntity then
    TKisVisualEntity(Result).Edit;
end;

function TKisContragentMngr.IsEntityInUse(Entity: TKisEntity): Boolean;
var
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, True);
  try
    with Conn.GetDataSet(Format(SQ_CONTR_IN_USE, [Entity.ID, Entity.ID])) do
    begin
      Open;
      Result := Fields[0].AsInteger > 0;
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

procedure TKisContragentMngr.CreateView;
var
  Combo: TComboBox;
begin
  inherited CreateView;
  FView.Caption := S_CONTRAGENTS;
  FView.Grid.Options := FView.Grid.Options - [dgEditing];
  FView.Grid.ReadOnly := True;
  Combo := TComboBox.Create(FView);
  FView.ToolBar.InsertControl(Combo);
  Combo.Align := alRight;
  Combo.Style := csDropDownList;
  Combo.Name := 'TFilterCombo';
  Combo.Items.Add('Все контрагенты');
  Combo.Items.Add('Юр. лица');
  Combo.Items.Add('Физ. лица');
  Combo.Items.Add('ИП (ЧП)');
  Combo.OnChange := ChangeViewFilter;
end;

function TKisContragentMngr.DeleteEntity(Entity: TKisEntity): Boolean;
var
  Conn: IKisConnection;
begin
  Conn := GetConnection(True, True);
  try
    if IsSupported(Entity) then
    begin
      if IsEntityInUse(Entity) then
      begin
        Result := False;
        inherited DeleteEntity(Entity);
      end
      else
      begin
        if Entity is TKisContragent then
        begin
          DeleteCommon(TKisContragent(Entity));
          case TKisContragent(Entity).ContrType of
          CT_PERSON :
            DeletePerson(TKisContragentPerson(Entity));
          CT_ORG :
            DeleteOrg(TKisContragentOrganisation(Entity));
          CT_PRIVATE :
            DeletePrivate(TKisContragentPrivate(Entity));
          end;
        end
        else
          if Entity is TKisContragentAccount then
            DeleteAccount(TKisContragentAccount(Entity));
        Result := True;
      end;
    end;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisContragentMngr.DeleteCommon(Entity: TKisContragent);
var
  Conn: IKisConnection;
  ContrAddrMngr: TKisSQLMngr;
begin
  Self.CheckDefaultTransaction;
  Conn := GetConnection(True, True);
  with Conn.GetDataSet(Format(SQ_DELETE_CONTR, [Entity.ID])) do
    Open;
  ContrAddrMngr := AppModule.SQLMngrs[kmContrAddresses];
  ContrAddrMngr.DefaultTransaction := Conn.Transaction;
  try
    if not Entity.Address1.IsEmpty or (Entity.Address2.Id > 0) then
      ContrAddrMngr.DeleteEntity(Entity.Address1);
    if not Entity.Address2.IsEmpty or (Entity.Address2.Id > 0) then
      ContrAddrMngr.DeleteEntity(Entity.Address2);
  finally
    ContrAddrMngr.DefaultTransaction := nil;
  end;
end;

procedure TKisContragentMngr.DeletePerson(Entity: TKisContragentPerson);
var
  Conn: IKisConnection;
  ContrDocsMngr: TKisSQLMngr;
begin
  Self.CheckDefaultTransaction;
  Conn := GetConnection(True, True);
  with Conn.GetDataSet(Format(SQ_DELETE_PERSON, [Entity.ID])) do
    Open;
  if not Entity.Doc.IsEmpty then
  begin
    ContrDocsMngr := AppModule.SQLMngrs[kmContrDocs];
    ContrDocsMngr.DefaultTransaction := Conn.Transaction;
    try
      ContrDocsMngr.DeleteEntity(Entity.Doc);
    finally
      ContrDocsMngr.DefaultTransaction := nil;
    end;
  end;
end;

procedure TKisContragentMngr.DeleteOrg(Entity: TKisContragentOrganisation);
var
  Conn: IKisConnection;
begin
  CheckDefaultTransaction;
  Conn := GetConnection(True, True);
  with Conn.GetDataSet(Format(SQ_DELETE_ORG, [Entity.ID])) do
    Open;
end;

procedure TKisContragentMngr.DeletePrivate(Entity: TKisContragentPrivate);
var
  Conn: IKisConnection;
  ContrDocMngr: TKisSQLMngr;
begin
  CheckDefaultTransaction;
  Conn := GetConnection(True, True);
  with Conn.GetDataSet(Format(SQ_DELETE_PRIVATE, [Entity.ID])) do
    Open;
  if not Entity.Doc.IsEmpty then
  begin
    ContrDocMngr := AppModule.SQLMngrs[kmContrDocs];
    ContrDocMngr.DefaultTransaction := Conn.Transaction;
    try
      ContrDocMngr.DeleteEntity(Entity.Doc);
    finally
      ContrDocMngr.DefaultTransaction := nil;
    end;
  end;
end;

function TKisContragentMngr.IsSupported(Entity: TKisEntity): Boolean;
begin
  Result := Assigned(Entity) and (Entity is TKisContragent);
  if not Result then
    inherited IsSupported(Entity);
end;

function TKisContragentMngr.CurrentEntity: TKisEntity;
begin
  if dsContrs.Active then
  begin
    Result := GetEntity(dsContrs.FieldByName(SF_ID).AsInteger);
    Result.Modified := False;
  end
  else
    Result := nil;
end;

function TKisContragentMngr.GetEntity(EntityID: Integer;
  EntityKind: TKisEntities = keDefault): TKisEntity;
var
  Conn: IKisConnection;
  DataSet: TDataSet;
begin
  Conn := GetConnection(True, False);
  try
    DataSet := Conn.GetDataSet(Format(SQ_SELECT_CONTR, [EntityID]));
    DataSet.Open;
    if not DataSet.IsEmpty then
    begin
      case DataSet.FieldByName(SF_TYPE_ID).AsInteger of
      CT_ORG :
        begin
          Result := Self.CreateEntity(keContrOrg);
        end;
      CT_PRIVATE :
        begin
          Result := Self.CreateEntity(keContrPrivate);
        end;
      CT_PERSON :
        begin
          Result := Self.CreateEntity(keContrPerson);
        end;
      end;
      Result.ID := EntityID;
      LoadContragent(TKisContragent(Result), DataSet);
      case TKisContragent(Result).ContrType of
      CT_ORG :
        begin
          LoadOrg(TKisContragentOrganisation(Result));
        end;
      CT_PRIVATE :
        begin
          LoadPrivate(TKisContragentPrivate(Result));
        end;
      CT_PERSON :
        begin
          LoadPerson(TKisContragentPerson(Result));
        end;
      end;
    end
    else
      Result := nil;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    FreeAndNil(Result);
    raise;
  end;
end;

procedure TKisContragentMngr.LoadContragent(TheEntity: TKisContragent; DataSet: TDataSet);
begin
  with DataSet, TheEntity do
  begin
    Name := FieldByName(SF_NAME).AsString;
    ShortName := FieldByName(SF_NAME_SHORT).AsString;
    Address1Id := FieldByName(SF_ADDRESS_1_ID).AsInteger;
    Address2Id := FieldByName(SF_ADDRESS_2_ID).AsInteger;
    Phones := FieldByName(SF_PHONES).AsString;
    INN := FieldByName(SF_INN).AsString;
    Comment.Text := FieldByName(SF_COMMENTS).AsString;
    ParentId := FieldByName(SF_PARENT_ID).AsInteger;
    // Грузим дефолтный счет
    if Assigned(FDefaultAccount) then
      FDefaultAccount.Free;
    FDefaultAccount := TKisContragentAccount(AppModule[kmAccounts].CreateEntity());
    TheEntity.FDefaultAccount.BankId := FieldByName(SF_BANK_ID).AsInteger;
    FDefaultAccount.Number := FieldByName(SF_BANK_ACCOUNT).AsString;
    FDefaultAccount.AccountType := TKisAccountType(FieldByName(SF_TYPE_ACCOUNT).AsInteger);
  end;
  LoadAccounts(TheEntity);
end;

procedure TKisContragentMngr.LoadOrg(Entity: TKisContragentOrganisation);
begin
  if Assigned(Self.DefaultTransaction) then
    with TIBQuery.Create(nil) do
    begin
      Forget;
      BufferChunks := 1;
      SQL.Text := Format(SQ_SELECT_ORG, [Entity.ID]);
      Transaction := Self.DefaultTransaction;
      Open;
      if not IsEmpty then
      begin
        Entity.Chief := FieldByName(SF_CHIEF).AsString;
        Entity.ChiefPost := FieldByName(SF_CHIEF_POST).AsString;
        Entity.ChiefDocType := FieldByName(SF_CHIEF_DOC_TYPE).AsInteger;
        Entity.ChiefDocNumber := FieldByName(SF_CHIEF_DOC_NUMBER).AsString;
        Entity.ChiefDocDate := FieldByName(SF_CHIEF_DOC_DATE).AsDateTime;
        Entity.Contacter := FieldByName(SF_CONTACTER).AsString;
        Entity.ContacterPost := FieldByName(SF_CONTACTER_POST).AsString;
        Entity.Accountant := FieldByName(SF_ACCOUNTANT).AsString;
        Entity.KPP := FieldbyName(SF_KPP).AsString;
        Entity.OKPF := FieldByName(SF_OKPF).AsString;
        Entity.OKPO := fieldByname(SF_OKPO).AsString;
        Entity.OKONH := FieldByname(SF_OKONH).AsString;
        Entity.SubdivisionId := FieldByName(SF_SUBDIVISION_ID).AsInteger;
        Entity.HeadOrgId := FieldByName(SF_HEAD_ORG_ID).AsInteger;
        Entity.ChiefDocs := FieldByName(SF_CHIEF_DOCS).AsString;
        Entity.ContacterPhones := FieldByName(SF_CONTACTER_PHONES).AsString;
      end;
      Close;
    end
  else
    raise Exception.CreateFmt(S_DEFAULT_TRANSACTION_MISSED, [Self.ClassName]);
end;

procedure TKisContragentMngr.LoadPerson(Entity: TKisContragentPerson);
begin
  if Assigned(Self.DefaultTransaction) then
    with TIBQuery.Create(nil) do
    begin
      Forget;
      BufferChunks := 1;
      SQL.Text := Format(SQ_SELECT_PERSON_DOC, [Entity.ID]);
      Transaction := Self.DefaultTransaction;
      Open;
      if not IsEmpty then
      begin
        Entity.DocId := Fields[N_ZERO].AsInteger;
      end;
      Close;
    end
  else
    raise Exception.CreateFmt(S_DEFAULT_TRANSACTION_MISSED, [Self.ClassName]);
end;

procedure TKisContragentMngr.LoadPrivate(Entity: TKisContragentPrivate);
begin
  if Assigned(Self.DefaultTransaction) then
    with TIBQuery.Create(nil) do
    begin
      Forget;
      BufferChunks := 1;
      SQL.Text := Format(SQ_SELECT_PRIVATE, [Entity.ID]);
      Transaction := Self.DefaultTransaction;
      Open;
      if not IsEmpty then
      begin
        Entity.DocId := Fields[N_ZERO].AsInteger;
        Entity.CertId := Fields[N_ONE].AsInteger;
      end;
      Close;
    end
  else
    raise Exception.CreateFmt(S_DEFAULT_TRANSACTION_MISSED, [Self.ClassName]);
end;

function TKisContragentMngr.GetIdent: TKisMngrs;
begin
  Result := kmContragents;
end;

function TKisContragentMngr.DuplicateEntity(
  Entity: TKisEntity): TKisEntity;
begin
  if IsSupported(Entity) then
  begin
    Result := TKisEntityClass(Entity.ClassType).Create(Self);
    Result.Assign(Entity);
  end
  else
    Result := nil;
end;

constructor TKisContragentMngr.Create(AOwner: TComponent);
begin
  inherited;
  FOldShowHandler := nil;
end;

function TKisContragentMngr.GetMainSQLText: String;
begin
  Result := SQ_MAIN;
end;

procedure TKisContragentMngr.ChangeViewFilter(Sender: TObject);
var
  C: TComboBox;
  Fltrs: IKisFilters;
begin
  if Assigned(FView) then
  begin
    C := FView.ToolBar.FindChildControl('TFilterCombo') as TComboBox;
    if Assigned(C) then
      with TFilterFactory do
        Fltrs := CreateList(CreateFilter(SF_TYPE_ID, C.ItemIndex, frEqual));
        if C.ItemIndex > 0 then        
          ApplyFilters(Fltrs, False)
        else
          CancelFilters(Fltrs);
  end;
end;

procedure TKisContragentMngr.SetContragentFilterType;
var
  C: TComboBox;
  Fltr: IKisFilter;
begin
  if Assigned(FView) then
  begin
    C := TComboBox(FView.ToolBar.FindChildControl('TFilterCombo'));
    //if Assigned(FOldShowHandler) then
       //FOldShowHandler(Sender);
  end
  else
    C := nil;
  //
  if Assigned(C) then
  begin
    Fltr := FFilters.Find(SF_TYPE_ID);
    if Assigned(Fltr) then
      with TFilterFactory do
        if AppModule.User.OfficeId = ID_OFFICE_PRIVATE_BUILDING then
        begin
          C.ItemIndex := 2;
          ApplyFilters(CreateList(CreateFilter(SF_TYPE_ID, 2, frEqual)), False);
        end
        else
        begin
          C.ItemIndex := 1;
          ApplyFilters(CreateList(CreateFilter(SF_TYPE_ID, 1, frEqual)), False);
        end
    else
      C.ItemIndex := 0;
  end;
end;

procedure TKisContragentMngr.Locate(AId: Integer; LocateFail: Boolean = False);
begin
  inherited;
  if dsContrs.Active then
    if not dsContrs.Locate(SF_PARENT_ID, GetParentId(AId), []) and LocateFail then
      AppModule.Alert('Переход к старому контрагенту не возможен, т.к. он принадлежит другой категории!');
end;

procedure TKisContragentMngr.PrepareSQLHelper;
begin
  inherited;
  with FSQLHelper do
  begin
    with AddTable do
    begin
      TableName := ST_CONTRAGENTS_VIEW;
      TableLabel := 'Основная (контрагенты)';
      AddStringField(SF_NAME, SFL_NAME, 500, [fpSearch, fpSort, fpQuickSearch]);
      AddStringField(SF_NAME_SHORT, SFL_SHORTNAME, 120, [fpSearch, fpSort, fpQuickSearch]);
      AddStringField(SF_ADDRESS_1, 'Адрес юридический', 420, [fpSearch, fpSort, fpQuickSearch]);
      AddStringField(SF_ADDRESS_2, 'Адрес фактический', 420, [fpSearch, fpSort, fpQuickSearch]);
      AddStringField(SF_PHONES, SFL_PHONES, 30, [fpSearch, fpSort, fpQuickSearch]);
      AddStringField(SF_INN, SFL_INN, 12, [fpSearch, fpSort, fpQuickSearch]);
      AddStringField(SF_COMMENTS, 'Комментарий', 1000, [fpSearch, fpSort, fpQuickSearch]);
      AddStringField(SF_ID, SFL_INSERT_ORDER, 1, [fpSort]);
      AddStringField(SF_BANK_NAME, SFL_BANK, 81, [fpSearch, fpSort, fpQuickSearch]);
      AddStringField(SF_BIK, SFL_BIK, 9, [fpSearch, fpSort, fpQuickSearch]);
      AddStringField(SF_BANK_ACCOUNT, 'Р/счет', 20, [fpSearch, fpSort, fpQuickSearch]);
    end;
  end;
end;

procedure TKisContragentMngr.EditCurrent;
var
  AEntity: TKisEntity;
begin
  AEntity := CurrentEntity;
  if Assigned(AEntity) then
    try
      SafeEditEntity(TKisContragent(AEntity));
    finally
      AEntity.Free;
    end;
end;

procedure TKisContragentMngr.IntShowEntities;
begin
  if not Assigned(FView) then
  begin
    CreateView;
    FView.Grid.OnDblClick := ViewGridDblClick;
    FView.Grid.OnMouseUp := ViewGridMouseUp;
    InSearch := False;
  end
  else
    FView.BringToFront;
  //
  if Assigned(aFilters) then
    ApplyFilters(aFilters, True)
  else
    SetContragentFilterType;
  //
  Active := True;
  FView.FormStyle := fsMDIChild;
  ReadViewState;
  FView.ButtonsPanel.Visible := False;
end;

function TKisContragentMngr.SelectEntity(NewView: Boolean; aFilters: IKisFilters;
  ClearExistingFilters: Boolean; StartID: Integer): TKisEntity;
var
  TmpView: TKisMngrView;
  Save_Cursor: TCursor;
begin
  Save_Cursor := Screen.Cursor;
  Screen.Cursor := crSQLWait;
  TmpView := nil;
  if NewView then
  begin
    TmpView := FView;
    FView := nil;
  end;
  if not Assigned(FView) then
  begin
    CreateView;
    FView.Grid.OnDblClick := ViewGridDblClick;
    FView.Grid.OnMouseUp := ViewGridMouseUp;
  end
  else
    FView.BringToFront;
  FView.FormStyle := fsNormal;
  ReadViewState;
  FView.ButtonsPanel.Visible := True;

  ApplyFilters(aFilters, ClearExistingFilters);
  SetContragentFilterType;

  Active := True;
  Locate(StartId);
  Screen.Cursor := Save_Cursor;
  if FView.ShowModal = mrOK then
  begin
    Result := CurrentEntity;
  end
  else
    Result := nil;
  CancelFilters(aFilters);
  if NewView then
  begin
    FView.Free;
    FView := TmpView;
  end;
end;

function TKisContragentMngr.CheckInnUniqueness(Entity: TKisContragent): TKisEntity;
var
  ResultID: Integer;
begin
  Result := nil;
  CheckDefaultTransaction;
  if Entity.INN <> '' then
  begin
    with TIBQuery.Create(nil) do
    begin
      Forget;
      BufferChunks := 10;
      SQL.Text := Format(SQ_CHECK_INN, [QuotedStr(Entity.INN), Entity.ParentId]);
      Transaction := Self.DefaultTransaction;
      Open;
      if RecordCount > 0 then
      begin
        ResultId := Fields[0].AsInteger;
        if Entity.ContrType = CT_ORG then
        begin
          if TKisContragentOrganisation(Entity).KPP <> '' then
          begin
            SQL.Clear;
            SQL.Text := Format(SQ_CHECK_KPP,
              [QuotedStr(TKisContragentOrganisation(Entity).KPP),
               Entity.ID,
               QuotedStr(TKisContragentOrganisation(Entity).INN),
               Entity.ParentId]);
            Transaction := Self.DefaultTransaction;
            Open;
            if RecordCount > 0 then
               Result := AppModule[kmContragents].GetEntity(FieldByName(SF_ID).AsInteger);
          end
          else
            Result := AppModule[kmContragents].GetEntity(ResultID);
        end
        else
          Result := AppModule[kmContragents].GetEntity(FieldByName(SF_ID).AsInteger);
      end;
    end;
  end;
end;

function TKisContragentMngr.ContragentsComparison(EntityOld,
  EntityNew: TKisEntity): Boolean;
var
  AComparer: TFmContragentsComparison;
begin
  AComparer := TFmContragentsComparison.Create(self);
  with AComparer do
  try
    LoadDataIntoComparer(EntityOld, EntityNew, AComparer);
    ShowModal;
    Result := ModalResult = mrOk;
  finally
    Free;
  end;
end;

procedure TKisContragentMngr.LoadDataIntoComparer(EntityOld,
  EntityNew: TKisEntity; AComparer: TFmContragentsComparison);
begin
  with AComparer as TFmContragentsComparison do
  begin
    ValueListEditorOld.Strings.Assign(TKisContragent(EntityOld).TransferContragentIntoStrings);
    ValueListEditorNew.Strings.Assign(TKisContragent(EntityNew).TransferContragentIntoStrings);
  end;
end;

procedure TKisContragentMngr.SafeEditEntity(Entity: TKisContragent);
var
  NeedSave, NeedBack, ContinueEdit: Boolean;
  Tmp: TKisEntity;
  ID: Integer;
begin
  NeedSave := False;
  ID := 0;
  if Assigned(dsContrs.Transaction) then
  begin
    NeedBack := not Assigned(Self.DefaultTransaction);
    if NeedBack then
      Self.DefaultTransaction := dsContrs.Transaction;
  end
  else
    raise Exception.CreateFmt(S_DEFAULT_TRANSACTION_MISSED, [Self.ClassName]);

  try
    if Entity is TKisVisualEntity then
    begin
      Tmp := nil;
      ContinueEdit := True;
      while ContinueEdit do
      begin
        Entity.Modified := False;
        NeedSave := TKisVisualEntity(Entity).Edit;
        if not NeedSave then
        begin
          FreeAndNil(Tmp);
          Break; // Пользователь нажал Отмена в редакторе
        end;
        // Пользователь нажал ОК
        NeedSave := Entity.Modified or Assigned(Tmp);
        if not NeedSave then
          // Данные не изменились и проверка идет в первый раз
          Break;
        FreeAndNil(Tmp);
        Tmp := CheckInnUniqueness(TKisContragent(Entity));
        if Assigned(Tmp) then
        begin
          AppModule.Alert('Контрагент с таким ИНН уже существует!');
          ContinueEdit := ContragentsComparison(Tmp, Entity);
          if not ContinueEdit then
            NeedSave := ContinueEdit;
        end
        else
        begin
          NeedSave := True;
          Break;
        end;
      end;


        //
(*        AEntity.Modified := False;
        ContinueEdit := TKisVisualEntity(AEntity).Edit;
        if ContinueEdit then
          NeedSave := AEntity.Modified;
        ContinueEdit := AEntity.Modified or Assigned(Tmp);
        if NeedSave or Assigned(Tmp) then
        begin
          FreeAndNil(Tmp);
          Tmp := CheckInnUniqueness(TKisContragent(AEntity));
          if Assigned(Tmp) then
            ContinueEdit := ContragentsComparison(Tmp, AEntity)
          else
            ContinueEdit := false;
          NeedSave := {not ((Assigned(Tmp)) and } not ContinueEdit;
        end
        //else
          //ContinueEdit := false;
      end;
      {repeat
        AEntity.Modified := False;
        NeedSave := TKisVisualEntity(AEntity).Edit and AEntity.Modified;
        FreeAndNil(Tmp);
        if NeedSave then
        begin
          Tmp := CheckInnUniqueness(TKisContragent(AEntity));
          NeedSave := not ((Assigned(Tmp)) and (not ContragentsComparison(Tmp, AEntity)))
        end;
      until Assigned(Tmp) and NeedSave;}   *)
      if NeedSave then
      begin
        SaveEntity(Entity);
        ID := Entity.ID;
      end
      else
      begin
        if Assigned(Tmp) then
          ID := TMP.ID;
        FreeAndNil(Tmp);
      end;
    end;
  finally
    if Assigned(dsContrs.Transaction) then
    begin
      if NeedSave then
      begin
        Self.DefaultTransaction.Commit;
        Self.DefaultTransaction.StartTransaction;
        Reopen;
      end;
      if ID <> 0 then
        Locate(ID, not NeedSave);
      if NeedBack then
        Self.DefaultTransaction := nil;
    end;
  end;
end;

function TKisContragentMngr.GetParentId(ID: Integer): Integer;
var
  v: Variant;
begin
  if AppModule.GetFieldValue(Self.DefaultTransaction, ST_CONTRAGENTS, SF_ID, SF_PARENT_ID, ID, V) then
    Result := v
  else
    Result := -1;
end;

procedure TKisContragentMngr.Reopen;
begin
  if Assigned(DefaultTransaction) and DefaultTransaction.Active then
    DefaultTransaction.CommitRetaining;
  inherited Reopen;
end;

function TKisContragentMngr.GetMainDataSet: TDataSet;
begin
  Result := dsContrs;
end;

function TKisContragentMngr.GetRefreshSQLText: String;
begin
  Result := 'SELECT * FROM CONTRAGENTS_VIEW WHERE ID=:ID';
end;

procedure TKisContragentMngr.DeleteAccount(Account: TKisContragentAccount);
begin

end;

procedure TKisContragentMngr.SaveAccounts(Entity: TKisContragent);
var
  AccMngr: TKisAccountsMngr;
begin
  AccMngr := TKisAccountsMngr(AppModule[kmAccounts]);
  AccMngr.Connection := GetConnection(True, True);
  try
    AccMngr.SaveController(Entity.FAccountsCtrlr);
  finally
    AccMngr.Connection := nil;
  end;
end;

procedure TKisContragentMngr.LoadAccounts(Entity: TKisContragent);
var
  AccountMngr: TkisAccountsMngr;
begin
  if Assigned(Entity) then
  begin
    AccountMngr := tKisAccountsMngr(AppModule[kmAccounts]);
    AccountMngr.Connection := GetConnection(True, False);
    try
      Accountmngr.LoadController(Entity.FAccountsCtrlr, Entity.ID);
    finally
      AccountMngr.Connection := nil;
    end;
  end;
end;

{ TKisContragentPrivate }

function TKisContragentPrivate.CheckEditor(AEditor: TKisEntityEditor): Boolean;
begin
  Result := inherited CheckEditor(AEditor);
  if Result then
  with AEditor as TKisContragentPrivateEditor do
  begin
    if privCertNumber in FEditorOptions then
    begin
      if Trim(edCertNumber.Text) = '' then
      begin
        edCertNumber.SetFocus;
        Result := False;
        MessageBox(Handle, PChar(S_CHECK_CERTNUMBER), PChar(S_WARN), MB_ICONWARNING);
        Exit;
      end;
    end;
    if privCertBusiness in FEditorOptions then
    begin
      if Trim(edBusiness.Text) = '' then
      begin
        edBusiness.SetFocus;
        Result := False;
        MessageBox(Handle, PChar(S_CHECK_CERTBUSINESS), PChar(S_WARN), MB_ICONWARNING);
        Exit;
      end;
    end;
    if privCertOwner in FEditorOptions then
    begin
      if Length(Trim(edCertOwner.Text)) < 12 then
      begin
        edCertOwner.SetFocus;
        Result := False;
        MessageBox(Handle, PChar(S_CHECK_CERTOWNER), PChar(S_WARN), MB_ICONWARNING);
        Exit;
      end;
    end;
    if privCertDate in FEditorOptions then
    begin
      if (dtpCertDate.Date < MIN_DOC_DATE) or (dtpCertDate.Date > Date) then
      begin
        dtpCertDate.SetFocus;
        Result := False;
        MessageBox(Handle, PChar(S_CHECK_CERTDATE), PChar(S_WARN), MB_ICONWARNING);
        Exit;
      end;
    end;
  end;
end;

procedure TKisContragentPrivate.Copy(Source: TKisEntity);
begin
  inherited;
  with Source as TKisContragentPrivate do
  begin
    Self.Certificate := Certificate;
  end;
end;

constructor TKisContragentPrivate.Create(Mngr: TKisMngr);
begin
  inherited;
  FContrType := CT_PRIVATE;
  Self.FCert := AppModule.Mngrs[kmContrCertificates].CreateEntity(keDefault);
end;

function TKisContragentPrivate.CreateEditor: TKisEntityEditor;
begin
  EntityEditor := TKisContragentPrivateEditor.Create(Application);
  Result := EntityEditor;
end;

destructor TKisContragentPrivate.Destroy;
begin
  FCert.Free;
  inherited;
end;

class function TKisContragentPrivate.EntityName: String;
begin
  Result := SEN_CONTR_PRIVATE;
end;

function TKisContragentPrivate.Equals(Entity: TKisEntity): Boolean;
begin
  Result := inherited Equals(Entity);
  if Entity is TKisContragentPrivate then
    Result := Result and FCert.Equals(TKisContragentPrivate(Entity).Certificate); 
end;

function TKisContragentPrivate.GetCertId: Integer;
begin
  Result := FCert.ID;
end;

function TKisContragentPrivate.GetProperties: String;
begin
  Result := inherited GetProperties;
  if Result <> '' then
    Result := Result + '; ';
  Result := Result + Self.Certificate.AsText;
end;

function TKisContragentPrivate.IsEmpty: Boolean;
begin
  Result := inherited IsEmpty and FCert.IsEmpty;
end;

procedure TKisContragentPrivate.LoadDataIntoEditor(AEditor: TKisEntityEditor);
begin
  inherited;
  with AEditor as TKisContragentPrivateEditor do
  with FCert as TKisContragentCertificate do
  begin
    edCertNumber.Text := Number;
    dtpCertDate.Date := CertDate;
    edBusiness.Text := Business;
    edCertOwner.Text := GivenBy;
  end;
end;

procedure TKisContragentPrivate.PrepareEditor(AEditor: TKisEntityEditor);
begin
  inherited;
  with AEditor as TKisContragentPrivateEditor do
  with FCert as TKisContragentCertificate do
  begin
    edCertNumber.Enabled := not Self.ReadOnly;
    dtpCertDate.Enabled := not Self.ReadOnly;
    edBusiness.Enabled := not Self.ReadOnly;
    edCertOwner.Enabled := not Self.ReadOnly;
  end;
end;

procedure TKisContragentPrivate.ReadDataFromEditor(AEditor: TKisEntityEditor);
begin
  inherited;
  with AEditor as TKisContragentPrivateEditor do
  with FCert as TKisContragentCertificate do
  begin
    FCert.Modified := False;
    Number := Trim(edCertNumber.Text);
    CertDate := dtpCertDate.Date;
    Business := Trim(edBusiness.Text);
    GivenBy := Trim(edCertOwner.Text);
  end;
  if FCert.Modified then
    Self.Modified := True;
end;

procedure TKisContragentPrivate.SetCert(const Value: TKisEntity);
begin
  if not FCert.Equals(Value) then
  begin
    FCert.Assign(Value);
    Modified := True;
  end;
end;

procedure TKisContragentPrivate.SetCertId(const Value: Integer);
var
  Tmp: TKisEntity;
begin
  if FCert.Id <> Value then
  begin
    Tmp := AppModule[kmContrCertificates].GetEntity(Value);
    Self.Certificate := Tmp;
    Tmp.Free;
    Modified := True;
  end;
end;

function TKisContragentPrivate.TransferContragentIntoStrings: TStringList;
var
  V: Variant;
begin
  Result := inherited TransferContragentIntoStrings;
  with Result do
  begin
    if Assigned(Doc) then
    begin
      with Self.Doc as TKisContragentDocument do
      begin
        if AppModule.GetFieldValue(AppModule.SQLMngrs[kmContragents].DefaultTransaction, ST_PERSON_DOC_TYPES, SF_ID, SF_NAME, DocKind, V) then
          Add('Тип документа, удостоверяющего личность='+V);
        Add('Серия='+Series);
        Add('Номер='+Number);
        Add('Когда выдан='+DateToStr(DocDate));
        Add('Кем выдан='+GivenBy);
      end;
    end;
    with FCert as TKisContragentCertificate do
    begin
      Add('Сертификат №='+Number);
      Add('Дата выдачи='+DateToStr(CertDate));
      Add('Вид деятельности='+Business);
      Add('Кем выдан='+GivenBy);
    end;
  end;  
end;

{ TKisContragentOrganisation }

constructor TKisContragentOrganisation.Create(Mngr: TKisMngr);
begin
  inherited; // of TKisContragent
  FContrType := CT_ORG;
  FHeadOrg := Manager.CreateEntity(keDefault);
  FEditorOptions := [];
end;

procedure TKisContragentMngr.acDeleteUpdate(Sender: TObject);
begin
  inherited;
  if acDelete.Enabled then
    acDelete.Enabled := AppModule.User.CanDoAction(maDelete, keContragent);
end;

procedure TKisContragentMngr.acEditUpdate(Sender: TObject);
begin
  inherited;
  if acEdit.Enabled then
    acEdit.Enabled := AppModule.User.CanDoAction(maEdit, keContragent);
end;

function TKisContragentOrganisation.GetHeadOrgId: Integer;
begin
  Result := FHeadOrg.ID;
end;

procedure TKisContragentOrganisation.SetAccountant(const Value: String);
begin
  if FAccountant <> Value then
  begin
    FAccountant := Value;
    Modified := True;
  end;
end;

procedure TKisContragentOrganisation.SetChief(const Value: String);
begin
  if FChief <> Value then
  begin
    FChief := Value;
    Modified := True;
  end;
end;

procedure TKisContragentOrganisation.SetChiefDocType(const Value: SmallInt);
begin
  if FChiefDocType <> Value then
  begin
    FChiefDocType := Value;
    Modified := True;
  end;
end;

procedure TKisContragentOrganisation.SetChiefPost(const Value: String);
begin
  if FChiefPost <> Value then
  begin
    FChiefPost := Value;
    Modified := True;
  end;
end;

procedure TKisContragentOrganisation.SetContacter(const Value: String);
begin
  if FContacter <> Value then
  begin
    FContacter := Value;
    Modified := True;
  end;
end;

procedure TKisContragentOrganisation.SetContacterPost(const Value: String);
begin
  if FContacterPost <> Value then
  begin
    FContacterPost := Value;
    Modified := True;
  end;
end;

procedure TKisContragentOrganisation.SetHeadOrgId(const Value: Integer);
var
  Tmp: TKisEntity;
begin
  if FHeadOrg.Id <> Value then
  begin
    Tmp := Manager.GetEntity(Value);
    HeadOrg := Tmp;
    Tmp.Free;
    Modified := True;
  end;
end;

procedure TKisContragentOrganisation.SetHeadOrg(const Value: TKisEntity);
begin
  if (Value = nil) then
  begin
    if not HeadOrg.IsEmpty then
    begin
      FHeadOrg.Free;
      FHeadOrg := Manager.CreateEntity(keDefault);
      Modified := True;
    end
  end
  else
    if not FHeadOrg.Equals(Value) then
    begin
      FHeadOrg.Assign(Value);
      Modified := True;
    end;
end;

procedure TKisContragentOrganisation.SetKPP(const Value: String);
begin
  if FKPP <> Value then
  begin
    FKPP := Value;
    Modified := True;
  end;
end;

procedure TKisContragentOrganisation.SetOKONH(const Value: String);
begin
  if Trim(FOKONH) <> Value then
  begin
    FOKONH := Value;
    Modified := true;
  end;
end;

procedure TKisContragentOrganisation.SetOKPF(const Value: String);
begin
  if Trim(FOKPF) <> Value then
  begin
    FOKPF := Value;
    Modified := True;
  end;
end;

procedure TKisContragentOrganisation.SetOKPO(const Value: String);
begin
  if Trim(FOKPO) <> Value then
  begin
    FOKPO := Value;
    Modified := True;
  end;
end;

procedure TKisContragentOrganisation.SetSubdivisionId(
  const Value: Integer);
begin
  if FSubdivisionId <> Value then
  begin
    FSubdivisionId := Value;
    Modified := True;
  end;
end;

procedure TKisContragentOrganisation.Copy(Source: TKisEntity);
begin
  inherited; // of TKisContragent
  with Source as TKisContragentOrganisation do
  begin
    Self.FChief := Chief;
    Self.FChiefPost := ChiefPost;
    Self.FChiefDocType := ChiefDocType;
    Self.FChiefDocDate := ChiefDocDate;
    Self.FChiefDocNumber := ChiefDocNumber;
    Self.FContacter := Contacter;
    Self.FContacterPost := ContacterPost;
    Self.FContacterPhones := ContacterPhones;
    Self.FAccountant := Accountant;
    Self.FKPP := KPP;
    Self.FOKPF := OKPF;
    Self.FOKPO := OKPO;
    Self.FOKONH := OKONH;
    Self.FSubdivisionId := SubdivisionId;
    Self.FHeadOrg.Assign(HeadOrg);
  end;
end;

function TKisContragentOrganisation.CreateEditor: TKisEntityEditor;
var
  Lst: TStringList;
begin
  EntityEditor := TKisContragentOrgEditor.Create(Application);
//  EntityEditor.CheckProcedure := CheckEditor;
  with EntityEditor as TKisContragentOrgEditor do
  begin
    edINN.MaxLength := 10;
    Lst := AppModule.Lists[klSubdivision];
    Lst.Forget;
    cbSubdivisionType.Items := Lst;
    cbSubdivisionType.OnChange := SetEditorSubdivisionState;
    //cbSubdivisionType.ItemIndex := -1;
    //cbSubdivisionType.ItemIndex := 0;
    //SetEditorSubdivisionState(nil);
    btnClearHeadOrg.OnClick := ClearHeadOrgClick;
    btnSelectHeadOrg.OnClick := SelectHeadOrg;
    cbChiefDocType.Items := IStringList(AppModule.Lists[klChiefDocType]).StringList;
    cbChiefDocType.OnChange := SelectChiefDocType;
    cbChiefDocType.ItemIndex := -1;
    SelectChiefDocType(nil);
  end;
  Result := EntityEditor;
end;

procedure TKisContragentOrganisation.LoadDataIntoEditor(AEditor: TKisEntityEditor);
begin
  if Assigned(AEditor) then
  begin
    inherited;
    with AEditor as TKisContragentOrgEditor do
    begin
      edChiefFIO.Text := Self.FChief;
      edChiefPost.Text := Self.FChiefPost;
      edContacterFIO.Text := Self.FContacter;
      edContacterPost.Text := Self.FContacterPost;
      edContacterPhone.Text := Self.ContacterPhones;
      cbChiefDocType.ItemIndex := Pred(Self.FChiefDocType);
      SelectChiefDocType(nil);
      dtpChiefDocDate.Date := FChiefDocDate;
      edChiefDocNumber.Text := ChiefDocNumber;
      edChiefDocs.Text := ChiefDocs;
      edAccountantFIO.Text := Self.FAccountant;
      edOKPO.Text := Self.FOKPO;
      edOKPF.Text := Self.FOKPF;
      edOKONH.Text := Self.FOKONH;
      edKPP.Text := Self.FKPP;
      cbSubdivisionType.ItemIndex := Self.FSubdivisionId;
      SetEditorSubdivisionState(nil);
      {if Self.FSubdivisionId > N_ZERO then
        cbSubdivisionType.ItemIndex := Pred(Self.FSubdivisionId)
      else
        cbSubdivisionType.ItemIndex := -1;}
      edHeadOrgName.Text := TKisContragent(FHeadOrg).Name;
      edHeadOrgAddress.Text := TKisContragent(FHeadOrg).Address1.AsText;
    end;
  end;
end;

procedure TKisContragentOrganisation.SetEditorSubdivisionState;
var
  State_: Boolean;
begin
  if Assigned(EntityEditor) then
  with EntityEditor as TKisContragentOrgEditor do
  begin
    State_ := cbSubdivisionType.ItemIndex > N_ZERO;
    edHeadOrgName.Enabled := State_;
    edHeadOrgName.ReadOnly := true;
    edHeadOrgAddress.Enabled := State_;
    edHeadOrgAddress.ReadOnly := true;
    btnClearHeadOrg.Enabled := State_;
    btnSelectHeadOrg.Enabled := State_;
    if not State_ then
    begin
      edHeadOrgName.Clear;
      edHeadOrgAddress.Clear; 
    end;
  end;
end;

procedure TKisContragentOrganisation.ClearHeadOrgClick(Sender: TObject);
begin
  if Assigned(EntityEditor) then
  begin
    HeadOrg := Manager.CreateEntity(keDefault);
    with EntityEditor as TKisContragentOrgEditor do
    begin
      edHeadOrgName.Clear;
      edHeadOrgAddress.Clear;
    end;
  end;
end;

procedure TKisContragentOrganisation.SetChiefDocDate(const Value: TDate);
begin
  if FChiefDocDate <> Value then
  begin
    FChiefDocDate := Value;
    Modified := True;
  end;
end;

procedure TKisContragentOrganisation.SelectChiefDocType(Sender: TObject);
begin
  if Assigned(EntityEditor) then
  with EntityEditor as TKisContragentOrgEditor do
  case cbChiefDocType.ItemIndex of
  ID_CHIEFDOCTYPE_2 : // доверенность
      begin
        Label14.Visible := True;
        dtpChiefDocDate.Visible := True;
        if Self.ChiefDocDate = 0 then
          dtpChiefDocDate.Date := MIN_CHIEF_DOC_DATE;
      end;
  else
      begin
        Label14.Visible := False;
        dtpChiefDocDate.Visible := False;
      end;
  end;
end;

procedure TKisContragentOrganisation.ReadDataFromEditor(AEditor: TKisEntityEditor);
begin
  inherited;
  with AEditor as TKisContragentOrgEditor do
  begin
    Chief := Trim(edChiefFIO.Text);
    ChiefPost := Trim(edChiefPost.Text);
    ChiefDocType := Succ(cbChiefDocType.ItemIndex);
    if dtpChiefDocDate.Visible then
      ChiefDocDate := dtpChiefDocDate.Date
    else
      ChiefDocDate := 0;
    ChiefDocNumber := Trim(edChiefDocNumber.Text);
    ChiefDocs := Trim(edChiefDocs.Text);
    Contacter := Trim(edContacterFIO.Text);
    ContacterPost := Trim(edContacterPost.Text);
    ContacterPhones := Trim(edContacterPhone.Text);
    Accountant := Trim(edAccountantFIO.Text);
    KPP := Trim(edKPP.Text);
    OKPF := Trim(edOKPF.Text);
    OKPO := Trim(edOKPO.Text);
    OKONH := Trim(edOKONH.Text);
    //SubdivisionId := Succ(cbSubdivisionType.ItemIndex);
    SubdivisionId := cbSubdivisionType.ItemIndex;
    if SubdivisionId < 1 then
      HeadOrgId := 0;
  end;
end;

procedure TKisContragentOrganisation.SelectHeadOrg(Sender: TObject);
var
  Ent: TKisEntity;
begin
  with TFilterFactory do
    Ent := SQLMngr.SelectEntity(True,
      CreateList(CreateFilter(SF_TYPE_ID, CT_ORG, frEqual)), True);
    if Assigned(Ent) then
    begin
      if ParentId = TKisContragent(Ent).ParentId then
         MessageBox(0, PChar('Нельзя выбрать "себя" в качестве головной организации!'), PChar('Внимание'),
           MB_OK + MB_ICONERROR)
      else
      begin
        HeadOrg := Ent;
        FreeAndNil(Ent);
        if Assigned(EntityEditor) then
        with EntityEditor as TKisContragentOrgEditor do
        begin
          edHeadOrgName.Text := TKisContragent(FHeadOrg).Name;
          edHeadOrgAddress.Text := TKisContragent(FHeadOrg).Address1.AsText;
        end;
      end;
    end
end;

function TKisContragentOrganisation.CheckEditor(AEditor: TKisEntityEditor): Boolean;
var
  S: String;
begin
  Result := inherited CheckEditor(AEditor);
  if Result then
  with AEditor as TKisContragentOrgEditor do
  begin
    Result := False;
    if orgBank in FEditorOptions then
    begin
      if BankId < 1 then
      begin
        MessageBox(Handle, PChar(S_CHECK_DEFAULT_ACCOUNT), PChar(S_WARN), MB_ICONWARNING + ID_OK);
        Exit;
      end;
    end;
    if orgChiefFIO in FEditorOptions then
    begin
      S := Trim(edChiefFIO.Text);
      if (S = '') or not CheckFIO(S) then
      begin
        MessageBox(Handle, PChar(S_CHECK_CHIEF_FIO), PChar(S_WARN), MB_ICONWARNING + ID_OK);
        edChiefFIO.SetFocus;
        Exit;
      end;
    end;
    if orgChiefPost in FEditorOptions then
    begin
      S := Trim(edChiefPost.Text);
      if (S = '') then
      begin
        MessageBox(Handle, PChar(S_CHECK_CHIEF_POST), PChar(S_WARN), MB_ICONWARNING + ID_OK);
        edChiefPost.SetFocus;
        Exit;
      end;
    end;
    if orgChiefDoc in FEditorOptions then
    begin
      case cbChiefDocType.ItemIndex of
      ID_CHIEFDOCTYPE_1 :
        begin
        end;
      ID_CHIEFDOCTYPE_2 :
        begin
          if (dtpChiefDocDate.Date < MIN_DOC_DATE) or (dtpChiefDocDate.Date >= Date) then
          begin
            MessageBox(Handle, PChar(S_CHECK_CHIEF_DOC_DATE), PChar(S_WARN), ID_OK + MB_ICONWARNING);
            dtpChiefDocDate.SetFocus;
            Exit;
          end;
        end;
      ID_CHIEFDOCTYPE_3 :
        begin
        end;
      ID_CHIEFDOCTYPE_4 :
        begin
        end;
      else
        begin
          MessageBox(Handle, PChar(S_SELECT_CHIEF_DOCTYPE), PChar(S_WARN), MB_ICONWARNING + ID_OK);
          cbChiefDocType.SetFocus;
          Exit;
        end;
      end;
    end;
    if orgKPP in FEditorOptions then
    begin
      S := Trim(edKPP.Text);
      if (S = '') or not StrIsNumber(S) or (Length(S) < 9) then
      begin
        MessageBox(Handle, PChar(S_CHECK_KPP), PChar(S_WARN), MB_ICONWARNING + ID_OK);
        edKPP.SetFocus;
        Exit;
      end;
    end;
    if orgOKPF in FEditorOptions then
    begin
      S := Trim(edOKPF.Text);
      if (S <> '') then
      if (not StrIsNumber(S) or (Length(S) < 2)
        or (StrToInt(S) < 40)) then
      begin
        MessageBox(Handle, PChar(S_CHECK_OKPF), PChar(S_WARN), MB_ICONWARNING + ID_OK);
        edOKPF.SetFocus;
        Exit;
      end;
    end;
    if orgOKPO in FEditorOptions then
    begin
      S := Trim(edOKPO.Text);
      if (S <> '') then
      if (not StrIsNumber(S) or (Length(S) < 2)) then
      begin
        MessageBox(Handle, PChar(S_CHECK_OKPO), PChar(S_WARN), MB_ICONWARNING + ID_OK);
        edOKPO.SetFocus;
        Exit;
      end;
    end;
    if orgOKONH in FEditorOptions then
    begin
      S := Trim(edOKONH.Text);
      if (S <> '') then
      if (not StrIsNumber(S) or (Length(S) <> 5)) then
      begin
        MessageBox(Handle, PChar(S_CHECK_OKONH), PChar(S_WARN), MB_ICONWARNING + ID_OK);
        edOKONH.SetFocus;
        Exit;
      end;
    end;
{    if Trim(edChiefDocs.Text) = '' then
    begin
      MessageBox(Handle, PChar(S_CHECK_CHIEF_DOCS), PChar(S_WARN), MB_ICONWARNING + ID_OK);
      edChiefDocs.SetFocus;
      Exit;
    end;      }
    Result := True;
  end;
end;

function TKisContragentOrganisation.GetProperties: String;
begin
  Result := inherited GetProperties;
  Result := 'КПП ' + Self.KPP + ', ОКПФ ' + OKPF + ', ОКПО ' + OKPO + ', ОКОНХ ' + OKONH + #13
    + Self.ChiefPost + #32 + Self.Chief;
end;


procedure TKisContragentMngr.acInsertUpdate(Sender: TObject);
begin
//  inherited;
  acInsert.Enabled := Assigned(DataSource.DataSet) and DataSource.DataSet.Active
      and AppModule.User.CanDoAction(maInsert, keContragent);
end;

class function TKisContragentOrganisation.EntityName: String;
begin
  Result := SEN_CONTR_ORG;
end;

procedure TKisContragentOrganisation.SetChiefDocNumber(
  const Value: String);
begin
  if FChiefDocNumber <> Value then
  begin
    FChiefDocNumber := Value;
    Modified := True;
  end;
end;

procedure TKisContragentOrganisation.PrepareEditor(
  AEditor: TKisEntityEditor);
begin
  inherited;
  with EntityEditor as TKisContragentOrgEditor do
  begin
    edChiefFIO.Enabled := not Self.ReadOnly;
    edChiefPost.Enabled := not Self.ReadOnly;
    edContacterFIO.Enabled := not Self.ReadOnly;
    edContacterPost.Enabled := not Self.ReadOnly;
    cbChiefDocType.Enabled := not Self.ReadOnly;
    dtpChiefDocDate.Enabled := not Self.ReadOnly;
    edChiefDocNumber.Enabled := not Self.ReadOnly;
    edAccountantFIO.Enabled := not Self.ReadOnly;
    edOKPO.Enabled := not Self.ReadOnly;
    edOKPF.Enabled := not Self.ReadOnly;
    edOKONH.Enabled := not Self.ReadOnly;
    edKPP.Enabled := not Self.ReadOnly;
    edHeadOrgName.Enabled := not Self.ReadOnly;
    edHeadOrgAddress.Enabled := not Self.ReadOnly;
    cbKindAccount.Enabled := not Self.ReadOnly;
    cbSubDivisionType.Enabled := not Self.ReadOnly;
    btnClearHeadOrg.Enabled := not Self.ReadOnly;
    btnSelectHeadOrg.Enabled := not Self.ReadOnly;
  end;
end;

function TKisContragentOrganisation.TransferContragentIntoStrings: TStringList;
var
  V: Variant;
begin
  Result := inherited TransferContragentIntoStrings;
  with Result do
  begin
    Add('ФИО руководителя='+Self.FChief);
    Add('Должность руководителя='+Self.FChiefPost);
    Add('Контактное лицо='+Self.FContacter);
    Add('Должность='+Self.FContacterPost);
    if AppModule.GetFieldValue(AppModule.SQLMngrs[kmContragents].DefaultTransaction, ST_CHIEF_DOC_TYPES, SF_ID, SF_NAME, Self.FChiefDocType, V) then
      Add('Документ='+V);
    Add('№='+Self.FChiefDocNumber);
    if Self.FChiefDocDate <> 0 then
      Add('от='+DateToStr(Self.FChiefDocDate));
    Add('Глав. бух. ФИО='+Self.FAccountant);
    Add('ОКПО='+Self.FOKPO);
    Add('ОКОПФ='+Self.FOKPF);
    Add('ОКОНХ='+Self.FOKONH);
    Add('КПП='+Self.FKPP);
    if AppModule.GetFieldValue(AppModule.SQLMngrs[kmContragents].DefaultTransaction, ST_SUBDIV_TYPES, SF_ID, SF_NAME, Self.FSubdivisionId, V) then
      Add('Тип дочернего подразделения='+V);
    Add('Наим. головной организации='+TKisContragent(FHeadOrg).Name);
    Add('Адрес головной организации='+TKisContragent(FHeadOrg).Address1.AsText);
  end;
end;

procedure TKisContragentMngr.acInsertExecute(Sender: TObject);
var
  Ent: TKisEntity;
begin
  Ent := CreateNewEntity(keDefault);
  Ent.Forget();
  SafeEditEntity(TKisContragent(Ent));
end;

function TKisContragentOrganisation.GetChiefDoc: String;
var
  Lst: TStringList;
  I: Integer;
begin
  Result := '';
  if FChiefDocs <> '' then
    Result := FChiefDocs
  else
  begin
    Lst := AppModule.Lists[klChiefDocType2];
    Lst.Forget;
    I := Lst.IndexOfObject(Pointer(ChiefDocType));
    if I >= 0 then
      Result := Lst[I]
    else
      Result := '';
    if ChiefDocNumber <> '' then
      Result := Result + ' №' + ChiefDocNumber;
    if ChiefDocDate > 0 then
      Result := Result + ' от '
        + FormatDateTime(S_DATESTR_FORMAT, ChiefDocDate);
  end;
end;

function TKisContragentOrganisation.CustomerRepresentativeName: String;
begin
  Result := ChiefPost + ' ' + Chief;
end;

procedure TKisContragentOrganisation.SetContacterPhones(
  const Value: String);
begin
  if FContacterPhones <> Value then
  begin
    FContacterPhones := Value;
    modified := True;
  end;
end;

procedure TKisContragentOrganisation.SetChiefDocs(const Value: String);
begin
  if FChiefDocs <> Value then
  begin
    FChiefDocs := Value;
    Modified := True;
  end;
end;

end.
