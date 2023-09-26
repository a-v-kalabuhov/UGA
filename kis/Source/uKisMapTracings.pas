unit uKisMapTracings;

interface

uses
  // System
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ImgList, ActnList, Grids, DBGrids, ComCtrls, StdCtrls, IBCustomDataSet,
  // Common
  uDataSet, uIBXUtils, uGC, uCommonUtils, uGeoTypes, uGeoUtils,
  // Project
  uKisClasses, uKisSQLClasses, uKisEntityEditor, uKisMapTracingEditor,
  uKisMapTracingGivingEditor, uKisConsts, uKisAppModule, uKisIntf, uKisLicensedOrgs, uKisUtils,
  uKisMapsMngrView, uKisPrintModule, uKisSearchClasses, uKisExceptions;

type
  TKisMapTracingGiving = class(TKisVisualEntity)
  private
    FGiveOut: Boolean;
    FKind: Boolean;
    FRecipient: String;
    FPersonName: String;
    FGiveDate: String;
    FBackDate: String;
    FPeriod: Integer;
    FComment: String;
    procedure SetKind(const Value: Boolean);
    procedure SetRecipient(const Value: String);
    procedure SetPersonName(const Value: String);
    procedure SetGiveDate(const Value: String);
    procedure SetBackDate(const Value: String);
    procedure SetPeriod(const Value: Integer);
    procedure SelectOrg(Sender: TObject);
    procedure LoadPeopleList(Sender: TObject);
    procedure LoadOfficesAndPeople(Sender: TObject);
    procedure SetComment(const Value: String);
  protected
    function CreateEditor: TKisEntityEditor; override;
    procedure PrepareEditor(Editor: TKisEntityEditor); override;
    procedure UnprepareEditor(Editor: TKisEntityEditor); override;
    procedure LoadDataIntoEditor(Editor: TKisEntityEditor); override;
    procedure ReadDataFromEditor(Editor: TKisEntityEditor); override;
    function CheckEditor(Editor: TKisEntityEditor): Boolean; override;
  public
    procedure Copy(Source: TKisEntity); override;
    function Equals(Entity: TKisEntity): Boolean; override;
    class function EntityName: String; override;
    function IsEmpty: Boolean; override;
    procedure Load(DataSet: TDataSet); override;
    property Kind: Boolean read FKind write SetKind;
    property Recipient: String read FRecipient write SetRecipient;
    property PersonName: String read FPersonName write SetPersonName;
    property GiveDate: String read FGiveDate write SetGiveDate;
    property BackDate: String read FBackDate write SetBackDate;
    property Period: Integer read FPeriod write SetPeriod;
    property Comment: String read FComment write SetComment;
  end;

  TGivingsCtrlr = class(TKisEntityController)
  public
    procedure FillFieldDefs(FieldDefsRef: TFieldDefs); override;
    function GetFieldData(Index: Integer; Field: TField; out Data): Boolean; override;
    procedure SetFieldData(Index: Integer; Field: TField; var Data); override;
    procedure CopyFrom(Source: TGivingsCtrlr);
  end;

  TKisMapTracing = class(TKisVisualEntity)
  private
    FNomenclature: String;
    FIsSecret: Boolean;
    FRecipient: String;
    FPersonName: String;
    FPeriod: Integer;
    FDoNeedCheck: Boolean;
    FGiveDate: String;
    FGivingsCtrlr: TGivingsCtrlr;
    FGivings: TCustomDataSet;
    FIsNew: Boolean;
    procedure SetNomenclature(const Value: String);
    procedure SetIsSecret(const Value: Boolean);
    function GetGivings: TDataSet;
    function IsNomenclatureUnique(const Value: String): Boolean;
    procedure DeleteLastGiving(Sender: TObject);
    procedure EditLastGiving(Sender: TObject);
    function IntNomenclature: String;
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
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    function Equals(Entity: TKisEntity): Boolean; override;
    function IsEmpty: Boolean; override;
    procedure Load(DataSet: TDataSet); override;
    procedure GiveOut(ToClient: Boolean);
    procedure GiveBack;
    property Nomenclature: String read FNomenclature write SetNomenclature;
    property IsSecret: Boolean read FIsSecret write SetIsSecret;
    property Givings: TDataSet read GetGivings;

    property IsNew: Boolean read FIsNew write FIsNew;
  end;

  TMapListCtrlr = class(TKisEntityController)
  public
    procedure FillFieldDefs(FieldDefsRef: TFieldDefs); override;
    function GetFieldData(Index: Integer; Field: TField; out Data): Boolean; override;
    function CanBack: Boolean;
    function CanGive: Boolean;
    function GiveOut(ToClient: Boolean): Boolean;
    function GiveBack: Boolean;
    function Exists(const Nomenclature: String): Boolean;
  end;

  TKisMapTracingMngr = class(TKisSQLMngr)
    acGiveOut: TAction;
    acGiveBack: TAction;
    acGiveOutToMP: TAction;
    dsMapTracings: TIBDataSet;
    dsMapTracingsID: TIntegerField;
    dsMapTracingsNOMENCLATURE: TStringField;
    dsMapTracingsIS_SECRET: TIntegerField;
    dsMapTracingsRECIPIENT: TStringField;
    dsMapTracingsPERSON_NAME: TStringField;
    dsMapTracingsPERIOD: TIntegerField;
    dsMapTracingsGIVE_DATE: TDateField;
    dsMapTracingsIS_OVERDUE: TIntegerField;
    dsMapTracingsDO_NEED_CHECK: TIntegerField;
    Action4: TAction;
    acLegend: TAction;
    dsMapList: TDataSource;
    ActionListMass: TActionList;
    acMassGiveOut: TAction;
    acMassGiveBack: TAction;
    acClearMapList: TAction;
    acMassGiveOutToOrg: TAction;
    acPrint: TAction;
    Action5: TAction;
    procedure acGiveOutExecute(Sender: TObject);
    procedure acGiveOutToMPExecute(Sender: TObject);
    procedure acGiveOutUpdate(Sender: TObject);
    procedure acGiveOutToMPUpdate(Sender: TObject);
    procedure acGiveBackUpdate(Sender: TObject);
    procedure acGiveBackExecute(Sender: TObject);
    procedure acLegendExecute(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure acMassGiveOutExecute(Sender: TObject);
    procedure acMassGiveOutToOrgExecute(Sender: TObject);
    procedure acMassGiveBackExecute(Sender: TObject);
    procedure acClearMapListExecute(Sender: TObject);
    procedure acClearMapListUpdate(Sender: TObject);
    procedure acMassGiveBackUpdate(Sender: TObject);
    procedure acMassGiveOutUpdate(Sender: TObject);
    procedure acPrintExecute(Sender: TObject);
  private
    FMapsList: TCustomDataSet;
    FMapsListCtrlr: TMapListCtrlr;
    procedure SaveMapTracing(Entity: TKisMapTracing);
    procedure SaveMapTracingGiving(Entity: TKisMapTracingGiving);
    procedure LoadGivings(Entity: TKisMapTracing);
    procedure GridCellColors(Sender: TObject; Field: TField;
      var Background, FontColor: TColor; State: TGridDrawState; var FontStyle:TFontStyles);
    procedure GivingsGridCellColors(Sender: TObject; Field: TField;
      var Background, FontColor: TColor; State: TGridDrawState; var FontStyle:TFontStyles);
    procedure AddToMapList;
    procedure PrepareViewLegend;
    procedure PrepareMassActions;
    procedure GridKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GivingGridKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure UpdateGivingsGrid;
  protected
    procedure Activate; override;
    procedure Deactivate; override;
    function GenEntityID(EntityKind: TKisEntities = keDefault): Integer; override;
    function GetIdent: TKisMngrs; override;
    function GetMainDataSet: TDataSet; override;
    function GetMainSQLText: String; override;
    function GetRefreshSQLText: String; override;
    procedure CreateView; override;
    procedure Locate(AId: Integer; LocateFail: Boolean = False); override;
    function IsSupported(Entity: TKisEntity): Boolean; override;
    procedure PrepareSQLHelper; override;
    procedure ReadViewState; override;
    procedure WriteViewState; override;
  public
    function CreateEntity(EntityKind: TKisEntities): TKisEntity; override;
    function CreateNewEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function GetEntity(EntityID: Integer; EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function DeleteEntity(Entity: TKisEntity): Boolean; override;
    function IsEntityInUse(Entity: TKisEntity): Boolean; override;
    function CurrentEntity: TKisEntity; override;
    procedure SaveEntity(Entity: TKisEntity); override;
    procedure UpdateIntNumbers;
  end;

implementation

{$R *.dfm}

const
  SG_MAP_TRACINGS = 'MAP_TRACINGS';
  SG_MAP_TRACING_GIVINGS = 'MAP_TRACING_GIVINGS';

  SQ_MAIN = 'SELECT * FROM MAP_TRACINGS';
  SQ_SELECT_MAP_TRACING = 'SELECT * FROM MAP_TRACINGS WHERE ID=%d';
  SQ_SELECT_MAP_TRACING_GIVING = 'SELECT * FROM MAP_TRACING_GIVINGS WHERE ID=%d';
  SQ_GET_GIVING_LIST = 'SELECT * FROM MAP_TRACING_GIVINGS WHERE MAP_TRACINGS_ID=%d ORDER BY ID DESC';
  SQ_SAVE_MAP_TRACING = 'EXECUTE PROCEDURE SAVE_MAP_TRACING(:ID, :NOMENCLATURE, :IS_SECRET, :RECIPIENT, :PERSON_NAME, :PERIOD, :DO_NEED_CHECK, :GIVE_DATE)';
  SQ_SAVE_MAP_TRACING_INT_NOMENCLATURE = 'UPDATE MAP_TRACINGS SET INT_NOMENCLATURE=:INT_NOMENCLATURE WHERE ID=:ID';
  SQ_SAVE_MAP_TRACING_GIVING = 'EXECUTE PROCEDURE SAVE_MAP_TRACING_GIVING(:ID, :MAP_TRACINGS_ID, :KIND, :RECIPIENT, :PERSON_NAME, :GIVE_DATE, :BACK_DATE, :PERIOD, :COMMENT)';
  SQ_DELETE_MAP_TRACING = 'DELETE FROM MAP_TRACINGS WHERE ID=%d';
  SQ_DELETE_MAP_TRACING_GIVING = 'DELETE FROM MAP_TRACING_GIVINGS WHERE ID=%d';

{ TKisMapTracing }

function TKisMapTracing.CheckEditor(Editor: TKisEntityEditor): Boolean;
var
  S: String;
  N: TNomenclature;
begin
  Result := False;
  with TKisMapTracingEditor(Editor) do
  begin
    S := edNomenclature.Text + '-' + edNom2.Text + '-' + edNom3.Text;
    N.Init(S, False);
    if N.Valid and (N.Scale = gs500) then
    begin
      S := N.Nomenclature();
      edNomenclature.Text := N.Part1;
      edNom2.Text := N.Part2;
      edNom3.Text := N.Part3;
    end
    else
    begin
      MessageBox(Handle, PChar(S_CHECK_NOMENCLATURE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edNomenclature.SetFocus;
      Exit;
    end;
    if IsNew then
    if not IsNomenclatureUnique(S) then
    begin
      MessageBox(Handle, PChar(S_CHECK_NOMENCLATURE_IS_UNIQUE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edNomenclature.SetFocus;
      Exit;
    end;
    Result := True;
  end;
end;

procedure TKisMapTracing.Copy(Source: TKisEntity);
begin
  inherited;
  with TKisMapTracing(Source) do
  begin
    Self.Nomenclature := Nomenclature;
    Self.IsSecret := IsSecret;
    Self.FGivingsCtrlr.CopyFrom(FGivingsCtrlr);
  end;
end;

constructor TKisMapTracing.Create(Mngr: TKisMngr);
begin
  inherited;
  FGivingsCtrlr := TGivingsCtrlr.CreateController(nil, Mngr, keMapTracingGiving);
  FGivingsCtrlr.HeadEntity := Self;
  FGivings := TCustomDataSet.Create(nil);
  FGivings.Controller := FGivingsCtrlr;
  FGivings.Active := True;
end;

function TKisMapTracing.CreateEditor: TKisEntityEditor;
begin
  Result := TKisMapTracingEditor.Create(Application);
end;

procedure TKisMapTracing.DeleteLastGiving(Sender: TObject);
begin
  if MessageBox(EntityEditor.Handle,
    PChar(S_CONFIRM_DELETE_LAST_GIVING),
    PChar(S_CONFIRM),
    MB_YESNO + MB_ICONQUESTION) = ID_YES
  then
  begin
    Givings.First;
    Givings.Delete;
    Givings.Last;
    Givings.First;
    if Givings.FieldByName(SF_GIVE_DATE).AsString <> '' then
    begin
      FRecipient := Givings.FieldByName(SF_RECIPIENT).AsString;
      FPersonName := Givings.FieldByName(SF_PERSON_NAME).AsString;
      FPeriod := Givings.FieldByName(SF_PERIOD).AsInteger;
      FGiveDate := Givings.FieldByName(SF_GIVE_DATE).AsString;
    end
    else
    begin
      FRecipient := '';
      FPersonName := '';
      FPeriod := -1;
      FGiveDate := '';
    end;
  end;
end;

destructor TKisMapTracing.Destroy;
begin
  FGivings.Free;
  FGivingsCtrlr.Free;
  inherited;
end;

procedure TKisMapTracing.EditLastGiving(Sender: TObject);
var
  Tmp: TKisMapTracingGiving;
begin
  Tmp := TKisMapTracingGiving(FGivingsCtrlr.Elements[1]);
  if Tmp.Edit then
  begin
    Givings.Refresh;
    if Givings.FieldByName(SF_GIVE_DATE).AsString <> '' then
    begin
      FRecipient := Givings.FieldByName(SF_RECIPIENT).AsString;
      FPersonName := Givings.FieldByName(SF_PERSON_NAME).AsString;
      FPeriod := Givings.FieldByName(SF_PERIOD).AsInteger;
      FGiveDate := Givings.FieldByName(SF_GIVE_DATE).AsString;
    end
    else
    begin
      FRecipient := '';
      FPersonName := '';
      FPeriod := -1;
      FGiveDate := '';
    end;
  end;
end;

class function TKisMapTracing.EntityName: String;
begin
  Result := 'Калька';
end;

function TKisMapTracing.Equals(Entity: TKisEntity): Boolean;
begin
  with TKisMapTracing(Entity) do
    Result := (Self.Nomenclature = Nomenclature) and (Self.IsSecret xor IsSecret);
end;

function TKisMapTracing.GetGivings: TDataSet;
begin
  Result := FGivings;
end;

procedure TKisMapTracing.GiveBack;
var
  Giving: TKisMapTracingGiving;
  OldState, OldState2: Boolean;
begin
  OldState := Modified;
  // Создем новое движение
  Giving := TKisMapTracingGiving(FGivingsCtrlr.Elements[1]);
  OldState2 := Giving.Modified;
  Giving.BackDate := DateToStr(Date);
  Giving.FGiveOut := False;
  Giving.Modified := True;
  // Показываем редактор с выбором организаций
  if Giving.Edit then
  begin
    FGivingsCtrlr.DirectAppend(Giving);
    Self.Modified := True;
    // Копируем данные из движения в свои поля
    FRecipient := '';
    FPersonName := '';
    FGiveDate := '';
    FPeriod := -1;
    FDoNeedCheck := False;
  end
  else
  begin
    Giving.BackDate := '';
    Giving.Modified := OldState2;
    Modified := OldState;
  end;
end;

procedure TKisMapTracing.GiveOut(ToClient: Boolean);
var
  Giving: TKisMapTracingGiving;
  OldState: Boolean;
begin
  OldState := Modified;
  // Создем новое движение
  Giving := TKisMapTracingGiving(Manager.CreateNewEntity(keMapTracingGiving));
  Giving.FKind := ToClient;
  Giving.FPeriod := 1;
  Giving.FGiveDate := DateToStr(Date);
  Giving.FGiveOut := True;
  Giving.Head := Self;
  Giving.Modified := False;
  // Показываем редактор с выбором организаций
  if Giving.Edit then
  begin
    FGivingsCtrlr.DirectAppend(Giving);
    Self.Modified := True;
    // Копируем данные из движения в свои поля
    FRecipient := Giving.Recipient;
    FPersonName := Giving.PersonName;
    FGiveDate := Giving.GiveDate;
    FPeriod := Giving.Period;
    FDoNeedCheck := ToClient;
  end
  else
  begin
    Modified := OldState;
    Giving.Free;
  end;
end;

function TKisMapTracing.IntNomenclature: String;
var
  L: TStringList;
  S: String;
  N: TNomenclature;
begin
  N.Init(Nomenclature, True);
  if N.Valid then
    S := N.Nomenclature();
  L := TStringList.Create;
  L.Forget();
  TGeoUtils.GetNomenclatureParts(S, L);
  try
    if Length(L[0]) < 2 then
      L[0] := ' ' + L[0];
    L[1] := IntToStr(LatinToArabian(L[1]));
    if Length(L[1]) < 2 then
      L[1] := ' ' + L[1];
    if Length(L[2]) < 2 then
      L[2] := ' ' + L[2];
    Result := L[0] + '-' + L[1] + '-' + L[2];
  except
    Result := '';
  end;
end;

function TKisMapTracing.IsEmpty: Boolean;
begin
  Result := (Nomenclature = '') and (not IsSecret);
end;

function TKisMapTracing.IsNomenclatureUnique(const Value: String): Boolean;
var
  V: Variant;
begin
  Result := not AppModule.GetFieldValue(nil, ST_MAP_TRACINGS, SF_NOMENCLATURE, SF_ID, Value, V);
end;

procedure TKisMapTracing.Load(DataSet: TDataSet);
begin
  inherited;
  ID := DataSet.FieldByName(SF_ID).AsInteger;
  Nomenclature := DataSet.FieldByName(SF_NOMENCLATURE).AsString;
  IsSecret := Boolean(DataSet.FieldByName(SF_IS_SECRET).AsInteger);
  FRecipient := DataSet.FieldByName(SF_RECIPIENT).AsString;
  FPersonName := DataSet.FieldByName(SF_PERSON_NAME).AsString;
  FPeriod := DataSet.FieldByName(SF_PERIOD).AsInteger;
  FDoNeedCheck := Boolean(DataSet.FieldByName(SF_IS_SECRET).AsInteger);
  FGiveDate := DataSet.FieldByName(SF_GIVE_DATE).AsString;
  TKisMapTracingMngr(Manager).LoadGivings(Self);
  Modified := False;
end;

procedure TKisMapTracing.LoadDataIntoEditor(Editor: TKisEntityEditor);
var
  NomParts: TStringList;
  N: TNomenclature;
begin
  inherited;
  with TKisMapTracingEditor(Editor) do
  begin
    if Nomenclature = '' then
    begin
      edNomenclature.Clear;
      edNom2.Clear;
      edNom3.Clear;
    end
    else
    begin
      N.Init(Nomenclature, False);
      NomParts := TStringList.Create;
      NomParts.Forget();
      TGeoUtils.GetNomenclatureParts(Nomenclature, NomParts);
      if NomParts.Count > 0 then
        edNomenclature.Text := NomParts[0]
      else
        edNomenclature.Text := '';
      if NomParts.Count > 1 then
        edNom2.Text := NomParts[1]
      else
        edNom2.Text := '';
      if NomParts.Count > 2 then
        edNom3.Text := NomParts[2]
      else
        edNom3.Text := '';
    end;
    cbIsSecret.Checked := IsSecret;
  end;
end;

procedure TKisMapTracing.PrepareEditor(Editor: TKisEntityEditor);
begin
  inherited;
  TKisMapTracingEditor(Editor).DataSource.DataSet := Self.Givings;
  Givings.Last;
  AppModule.ReadGridProperties(TKisMapTracingEditor(Editor), TKisMapTracingEditor(Editor).gGivings);
  TKisMapTracingEditor(Editor).btnDeleteLast.OnClick := DeleteLastGiving;
  TKisMapTracingEditor(Editor).btnEditLast.OnClick := EditLastGiving;
end;

procedure TKisMapTracing.ReadDataFromEditor(Editor: TKisEntityEditor);
begin
  inherited;
  with TKisMapTracingEditor(Editor) do
  begin
    Nomenclature := edNomenclature.Text + '-' + edNom2.Text + '-' + edNom3.Text;
    IsSecret  := cbIsSecret.Checked;
  end;
end;

procedure TKisMapTracing.SetIsSecret(const Value: Boolean);
begin
  if FIsSecret <> Value then
  begin
    FIsSecret := Value;
    Modified := True;
  end;
end;

procedure TKisMapTracing.SetNomenclature(const Value: String);
begin
  if FNomenclature <> Value then
  begin
    FNomenclature := Value;
    Modified := True;
  end;
end;

procedure TKisMapTracing.UnprepareEditor(Editor: TKisEntityEditor);
begin
  AppModule.WriteGridProperties(TKisMapTracingEditor(Editor), TKisMapTracingEditor(Editor).gGivings);
  inherited;
end;

{ TKisMapTracingGiving }

procedure TKisMapTracingGiving.Copy(Source: TKisEntity);
begin
  inherited;
  with TKisMapTracingGiving(Source) do
  begin
    Self.FKind := FKind;
    Self.FRecipient := FRecipient;
    Self.FPersonName := FPersonName;
    Self.FGiveDate := FGiveDate;
    Self.FBackDate := FBackDate;
    Self.FPeriod := FPeriod;
    Modified := False;
  end;
end;

class function TKisMapTracingGiving.EntityName: String;
begin
  Result := 'Движение кальки';
end;

function TKisMapTracingGiving.Equals(Entity: TKisEntity): Boolean;
begin
  with TKisMapTracingGiving(Entity) do
    Result :=
      (Self.FKind = FKind) and
      (Self.FRecipient = FRecipient) and
      (Self.FPersonName = FPersonName) and
      (Self.FGiveDate = FGiveDate) and
      (Self.FBackDate = FBackDate) and
      (Self.FPeriod = FPeriod);
end;

function TKisMapTracingGiving.IsEmpty: Boolean;
begin
  Result :=
    (FKind xor False) and
    (FRecipient = '') and
    (FPersonName = '') and
    (FGiveDate = '') and
    (FBackDate = '') and
    (FPeriod = 0);
end;

procedure TKisMapTracingGiving.Load(DataSet: TDataSet);
begin
  inherited;
  ID := DataSet.FieldByName(SF_ID).AsInteger;
  FKind := Boolean(DataSet.FieldByName(SF_KIND).AsInteger);
  FRecipient := DataSet.FieldByName(SF_RECIPIENT).AsString;
  FPersonName := DataSet.FieldByName(SF_PERSON_NAME).AsString;
  FGiveDate := DataSet.FieldByName(SF_GIVE_DATE).AsString;
  FBackDate := DataSet.FieldByName(SF_BACK_DATE).AsString;
  FPeriod := DataSet.FieldByName(SF_PERIOD).AsInteger;
  FComment := DataSet.FieldByName(SF_COMMENT).AsString;
  Modified := False;
end;

procedure TKisMapTracingGiving.SetBackDate(const Value: String);
begin
  if FBackDate <> Value then
  begin
    FBackDate := Value;
    Modified := True;
  end;
end;

procedure TKisMapTracingGiving.SetGiveDate(const Value: String);
begin
  if FGiveDate <> Value then
  begin
    FGiveDate := Value;
    Modified := True;
  end;
end;

procedure TKisMapTracingGiving.SetKind(const Value: Boolean);
begin
  if FKind <> Value then
  begin
    FKind := Value;
    Modified := True;
  end;
end;

procedure TKisMapTracingGiving.SetPersonName(const Value: String);
begin
  if FPersonName <> Value then
  begin
    FPersonName := Value;
    Modified := True;
  end;
end;

procedure TKisMapTracingGiving.SetRecipient(const Value: String);
begin
  if FRecipient <> Value then
  begin
    FRecipient := Value;
    Modified := True;
  end;
end;

procedure TKisMapTracingGiving.SetPeriod(const Value: Integer);
begin
  if FPeriod <> Value then
  begin
    FPeriod := Value;
    Modified := True;
  end;
end;

{ TGivesCtrlr }

procedure TGivingsCtrlr.CopyFrom(Source: TGivingsCtrlr);
var
  I: Integer;
  Tmp: TKisMapTracingGiving;
begin
  DirectClear;
  for I := 1 to Source.Count do
  begin
    Tmp := TKisMapTracingGiving(AppModule[kmMapTracings].CreateEntity(keMapTracingGiving));
    Tmp.Assign(Source.Elements[I]);
    DirectAppend(Tmp);
  end;
end;

procedure TGivingsCtrlr.FillFieldDefs(FieldDefsRef: TFieldDefs);
begin
  inherited;
  FieldDefsRef.Add(SF_ID, ftInteger);
  FieldDefsRef.Add(SF_KIND, ftBoolean);
  FieldDefsRef.Add(SF_RECIPIENT, ftString, 255);
  FieldDefsRef.Add(SF_PERSON_NAME, ftString, 100);
  FieldDefsRef.Add(SF_GIVE_DATE, ftDate);
  FieldDefsRef.Add(SF_BACK_DATE, ftDate);
  FieldDefsRef.Add(SF_PERIOD, ftInteger);
end;

function TGivingsCtrlr.GetFieldData(Index: Integer; Field: TField;
  out Data): Boolean;
var
  Giving: TKisMapTracingGiving;
begin
  Giving := TKisMapTracingGiving(Elements[Index]);
  Result := Assigned(Giving);
  if Result then
  case Field.FieldNo of
  1 : GetInteger(Giving.ID, Data);
  2 : GetBoolean(Giving.Kind, Data);
  3 : GetString(Giving.Recipient, Data);
  4 : GetString(Giving.PersonName, Data);
  5 : if Giving.GiveDate <> '' then
        GetDate(StrToDate(Giving.GiveDate), Data)
      else
        Result := False;
  6 : if Giving.BackDate <> '' then
        GetDate(StrToDate(Giving.BackDate), Data)
      else
        Result := False;
  7 : GetInteger(Giving.Period, Data);
  else
    Result := False
  end;
end;

procedure TGivingsCtrlr.SetFieldData(Index: Integer; Field: TField;
  var Data);
begin

end;

procedure TKisMapTracingMngr.acGiveOutExecute(Sender: TObject);
var
  MapTracing: TKisMapTracing;
begin
  inherited;
  MapTracing := TKisMapTracing(CurrentEntity);
  if Assigned(MapTracing) then
  begin
    MapTracing.Modified := False;
    MapTracing.GiveOut(True);
    if MapTracing.Modified then
    begin
      SaveEntity(MapTracing);
      dsMapTracings.Refresh;
    end;
  end;
end;

procedure TKisMapTracingMngr.acGiveOutToMPExecute(Sender: TObject);
var
  MapTracing: TKisMapTracing;
begin
  inherited;
  MapTracing := TKisMapTracing(CurrentEntity);
  if Assigned(MapTracing) then
  begin
    MapTracing.Modified := False;
    MapTracing.GiveOut(False);
    if MapTracing.Modified then
    begin
      SaveEntity(MapTracing);
      dsMapTracings.Refresh;
    end;
  end;
end;

procedure TKisMapTracingMngr.Activate;
begin
  inherited;
  dsMapTracings.Transaction := AppModule.Pool.Get;
  dsMapTracings.Transaction.Init();
//  dsMapTracings.Transaction.AutoStopAction := saNone;
  Reopen;
end;

function TKisMapTracingMngr.CreateEntity(
  EntityKind: TKisEntities): TKisEntity;
begin
  case EntityKind of
  keDefault, keMapTracing :
    Result := TKisMapTracing.Create(Self);
  keMapTracingGiving :
    Result := TKisMapTracingGiving.Create(Self);
  else
    Result := nil;
  end;
end;

function TKisMapTracingMngr.CreateNewEntity(
  EntityKind: TKisEntities): TKisEntity;
begin
  Result := CreateEntity(EntityKind);
  if Assigned(Result) then
  begin
    Result.ID := Self.GenEntityID(EntityKind);
    if Result is TKisMapTracing then
      TKisMapTracing(Result).IsNew := True;
  end
  else
    raise Exception.Create(S_CANT_CREATE_NEW_ENTITY);
end;

procedure TKisMapTracingMngr.CreateView;
begin
  if not Assigned(FView) then
  begin
    FView := TKisMapsMngrView.Create(Self);
    with TKisMapsMngrView(FView) do
    begin
      if dgEditing in dbgGiving.Options then
        dbgGiving.Options := dbgGiving.Options - [dgEditing];
      dbgGiving.DataSource := Self.dsMapList;
      Grid.OnKeyUp := GridKeyUp;
      dbgGiving.OnKeyUp := GivingGridKeyUp;
      dbgGiving.OnCellColors := GivingsGridCellColors;
    end;
  end;
  PrepareViewLegend;
  inherited CreateView;
  FView.Caption := 'Кальки планшетов 1:500';
  FView.Grid.OnCellColors := GridCellColors;
  PrepareMassActions;
  //
  FView.ToolBarNav.Visible := True;
end;

function TKisMapTracingMngr.CurrentEntity: TKisEntity;
begin
  Result := GetEntity(dsMapTracingsID.AsInteger, keMapTracing);
  Result.Modified := False;
end;

procedure TKisMapTracingMngr.Deactivate;
begin
  inherited;
  dsMapTracings.Close;
  if not dsMapTracings.Transaction.Active then
    dsMapTracings.Transaction.Commit;
  AppModule.Pool.Back(dsMapTracings.Transaction);
end;

function TKisMapTracingMngr.DeleteEntity(Entity: TKisEntity): Boolean;
var
  Conn: IKisConnection;
  S: String;
begin
  if not Assigned(Entity) then Exit;
  Conn := GetConnection(True, True);
  if IsEntityInUse(Entity) then
  begin
    Result := False;
    inherited DeleteEntity(Entity);
  end
  else
    try
      if Entity is TKisMapTracing then
        S := Format(SQ_DELETE_MAP_TRACING, [Entity.ID])
      else
        if Entity is TKisMapTracingGiving then
          S := Format(SQ_DELETE_MAP_TRACING_GIVING, [Entity.ID]);
      if S <> '' then
      begin
        Conn.GetDataSet(S).Open;
        Result := True;
      end
      else
        Result := False;
      FreeConnection(Conn, True);
    except
      FreeConnection(Conn, False);
      raise;
    end;
end;

function TKisMapTracingMngr.GenEntityID(EntityKind: TKisEntities): Integer;
begin
  case EntityKind of
    keDefault, keMapTracing :
      Result := AppModule.GetID(SG_MAP_TRACINGS, nil);
    keMapTracingGiving :
      Result := AppModule.GetID(SG_MAP_TRACING_GIVINGS, nil);
  else
    Result := -1;
  end;
end;

function TKisMapTracingMngr.GetEntity(EntityID: Integer;
  EntityKind: TKisEntities): TKisEntity;
var
  DataSet: TDataSet;
  Conn: IKisConnection;
  SQLText: String;
begin
  Result := nil;
  Conn := GetConnection(True, False);
  try
    case EntityKind of
    keDefault, keMapTracing :
      SQLText := Format(SQ_SELECT_MAP_TRACING, [EntityID]);
    keMapTracingGiving :
      SQLText := Format(SQ_SELECT_MAP_TRACING_GIVING, [EntityID]);
    else
      raise ELoadEntity.Create(EntityID, EntityKind);
    end;
    DataSet := Conn.GetDataSet(SQLText);
    DataSet.Open;
    if not DataSet.IsEmpty then
    begin
      Result := CreateEntity(EntityKind);
      Result.Load(DataSet);
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

function TKisMapTracingMngr.GetIdent: TKisMngrs;
begin
  Result := kmMapTracings;
end;

function TKisMapTracingMngr.GetMainDataSet: TDataSet;
begin
  Result := dsMapTracings;
end;

function TKisMapTracingMngr.GetMainSQLText: String;
begin
  Result := SQ_MAIN;
end;

function TKisMapTracingMngr.GetRefreshSQLText: String;
begin
  Result := GetMainSQLText + ' WHERE ID=:ID';
end;

procedure TKisMapTracingMngr.GridCellColors(Sender: TObject; Field: TField;
  var Background, FontColor: TColor; State: TGridDrawState; var FontStyle:TFontStyles);
begin
  if (gdSelected in State) or (gdFOcused in State) then
  begin
    Background := clHighlight;
    FontColor := clWindow;
  end
  else
    if dsMapTracingsIS_SECRET.AsInteger = 1 then
    begin
      BackGround := $CCFFCC;
    end
    else
    if dsMapTracingsIS_OVERDUE.AsInteger = 1 then
      BackGround := $9999FF
    else
    if (dsMapTracingsRECIPIENT.AsString = '') and
       (dsMapTracingsDO_NEED_CHECK.AsInteger = 1)
    then
    begin
      BackGround := $99FFFF;
      FontColor := clNavy;
    end;
end;

function TKisMapTracingMngr.IsEntityInUse(Entity: TKisEntity): Boolean;
begin
  Result := False;
end;

function TKisMapTracingMngr.IsSupported(Entity: TKisEntity): Boolean;
begin
  Result := (Entity is TKisMapTracing) or (Entity is TKisMapTracingGiving);
end;

procedure TKisMapTracingMngr.LoadGivings(Entity: TKisMapTracing);
var
  Conn: IKisConnection;
  DataSet: TDataSet;
  Giving: TKisEntity;
begin
  Entity.FGivingsCtrlr.DirectClear;
  Conn := GetConnection(True, False);
  try
    DataSet := Conn.GetDataSet(Format(SQ_GET_GIVING_LIST, [Entity.ID]));
    DataSet.Open;
    while not DataSet.Eof do
    begin
      Giving := CreateEntity(keMapTracingGiving);
      Giving.Load(DataSet);
      Entity.FGivingsCtrlr.DirectAppend(Giving);
      DataSet.Next;
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

procedure TKisMapTracingMngr.PrepareSQLHelper;
begin
  inherited;
  with FSQLHelper.AddTable do
  begin
    TableName := ST_MAP_TRACINGS;
    TableLabel := 'Основная (кальки)';
    AddStringField(SF_NOMENCLATURE, SFL_NOMENCLATURE, 20, [fpSearch, fpQuickSearch]);
    AddStringField(SF_INT_NOMENCLATURE, SFL_NOMENCLATURE, 20, [fpSort]);
    AddSimpleField(SF_IS_SECRET, SFL_IS_SECRET, ftBoolean, [fpSearch, fpSort]);
    AddStringField(SF_RECIPIENT, SFL_RECIPIENT, 255, [fpSearch, fpSort, fpQuickSearch]);
    AddStringField(SF_PERSON_NAME, SFL_PERSON_NAME, 100, [fpSearch, fpSort, fpQuickSearch]);
    AddSimpleField(SF_GIVE_DATE, SFL_DATE_OF_GIVE, ftDate, [fpSearch, fpSort]);
    AddSimpleField(SF_PERIOD, SFL_PERIOD, ftInteger, [fpSearch, fpSort]);
    AddSimpleField(SF_IS_OVERDUE, SFL_IS_OVERDUE, ftBoolean, [fpSearch, fpSort]);
    AddSimpleField(SF_ID, SFL_ID, ftInteger, [fpSort]);
  end;
end;

procedure TKisMapTracingMngr.SaveEntity(Entity: TKisEntity);
begin
  inherited;
  if Assigned(Entity) then
  if IsSupported(Entity) then
  if (Entity is TKisMapTracing) then
       SaveMapTracing(TKisMapTracing(Entity))
  else
     if (Entity is TKisMapTracingGiving) then
        SaveMapTracingGiving(TKisMapTracingGiving(Entity));
end;

procedure TKisMapTracingMngr.SaveMapTracing(Entity: TKisMapTracing);
var
  I: Integer;
  Conn: IKisConnection;
  DataSet: TDataSet;
begin
  if not Assigned(Entity) then
    Exit;
  Conn := GetConnection(True, True);
  try
    DataSet := Conn.GetDataSet(SQ_SAVE_MAP_TRACING);
    if Entity.ID < 1 then
      Entity.ID := Self.GenEntityID(keMapTracing);
    // :ID, :NOMENCLATURE, :IS_SECRET, :RECIPIENT, :PERSON_NAME, :PERIOD,
    // :DO_NEED_CHECK, :GIVE_DATE
    Conn.SetParam(DataSet, SF_ID, Entity.ID);
    Conn.SetParam(DataSet, SF_NOMENCLATURE, Entity.Nomenclature);
    Conn.SetParam(DataSet, SF_IS_SECRET, Integer(Entity.IsSecret));
    Conn.SetParam(DataSet, SF_RECIPIENT, Entity.FRecipient);
    Conn.SetParam(DataSet, SF_PERSON_NAME, Entity.FPersonName);
    if Entity.FPeriod < 1 then
      Conn.SetParam(DataSet, SF_PERIOD, Null)
    else
      Conn.SetParam(DataSet, SF_PERIOD, Entity.FPeriod);
    Conn.SetParam(DataSet, SF_DO_NEED_CHECK, Integer(Entity.FDoNeedCheck));
    Conn.SetParam(DataSet, SF_GIVE_DATE, Entity.FGiveDate);
    DataSet.Open;
    // Сохраняем внутреннюю номенклатуру для сортировки
    DataSet := Conn.GetDataSet(SQ_SAVE_MAP_TRACING_INT_NOMENCLATURE);
    Conn.SetParam(DataSet, SF_ID, Entity.ID);
    Conn.SetParam(DataSet, SF_INT_NOMENCLATURE, Entity.IntNomenclature);
//    dataSet.Open;
    // Сохраняем список выдачи планшетов
    with Entity.FGivingsCtrlr do
    begin
      for I := 1 to Count do
        if Elements[I].Modified then
          Self.SaveEntity(Elements[I]);
      for I := 0 to Pred(DeletedCount) do
        Self.DeleteEntity(DeletedElements[I]);
    end;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisMapTracingMngr.SaveMapTracingGiving(
  Entity: TKisMapTracingGiving);
var
  Conn: IKisConnection;
  DataSet: TDataSet;
begin
  if not Assigned(Entity) then
    Exit;
  Conn := GetConnection(True, True);
  try
    DataSet := Conn.GetDataSet(SQ_SAVE_MAP_TRACING_GIVING);
    if Entity.ID < 1 then
      Entity.ID := Self.GenEntityID(keMapTracing);
    // :ID, :MAP_TRACINGS_ID, :KIND, :RECIPIENT, :PERSON_NAME, :GIVE_DATE,
    // :BACK_DATE, :PERIOD, :COMMENT
    Conn.SetParam(DataSet, SF_ID, Entity.ID);
    Conn.SetParam(DataSet, SF_MAP_TRACINGS_ID, Entity.HeadId);
    Conn.SetParam(DataSet, SF_KIND, Integer(Entity.Kind));
    Conn.SetParam(DataSet, SF_RECIPIENT, Entity.Recipient);
    Conn.SetParam(DataSet, SF_PERSON_NAME, Entity.PersonName);
    Conn.SetParam(DataSet, SF_GIVE_DATE, Entity.GiveDate);
    Conn.SetParam(DataSet, SF_BACK_DATE, Entity.BackDate);
    Conn.SetParam(DataSet, SF_PERIOD, Entity.Period);
    Conn.SetParam(DataSet, SF_COMMENT, Entity.Comment);
    DataSet.Open;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisMapTracingMngr.acGiveOutUpdate(Sender: TObject);
begin
  inherited;
  acGiveOut.Enabled := (not Boolean(dsMapTracingsDO_NEED_CHECK.AsInteger))
    and (not Boolean(dsMapTracingsIS_SECRET.AsInteger));
end;

procedure TKisMapTracingMngr.acGiveOutToMPUpdate(Sender: TObject);
begin
  inherited;
  acGiveOutToMP.Enabled := (not Boolean(dsMapTracingsDO_NEED_CHECK.AsInteger))
    and (not Boolean(dsMapTracingsIS_SECRET.AsInteger));
end;

function TKisMapTracingGiving.CheckEditor(
  Editor: TKisEntityEditor): Boolean;
var
  aGiveDate, aBackDate: TDateTime;
  B: Boolean;

  procedure ErrorInBackDate;
  begin
    MessageBox(Editor.Handle, PChar(S_CHECK_DATE_OF_BACK), PChar(S_WARN), MB_OK + MB_ICONWARNING);
    with Editor as TKisMapTracingGivingEditor do
      edBackDate.SetFocus;
  end;
  
begin
  Result := False;
  with TKisMapTracingGivingEditor(Editor) do
  begin
    if (Trim(edGiveDate.Text) = '') or not TryStrToDate(edGiveDate.Text, aGiveDate) or
          ((aGiveDate > Date) or (aGiveDate < MIN_DOC_DATE))
    then
    begin
      MessageBox(Editor.Handle, PChar(S_CHECK_DATE_OF_GIVE), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edGiveDate.SetFocus;
      Exit;
    end;
    if (aGiveDate > Date) then
    begin
      MessageBox(Editor.Handle, PChar('Дата выдачи больше сегодняшней!'), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edGiveDate.SetFocus;
      Result := False;
      Exit;
    end;
    B := Trim(edPeriod.Text) = '';
    if not B then
      B := not StrIsNumber(Trim(edPeriod.Text));
    if B then
    begin
      AppModule.Alert(S_CHECK_TERM_OF_GIVE);
      edPeriod.SetFocus;
      Exit;
    end;
    if FKind then
      if (edOrgname.Text = '') then
      begin
        AppModule.Alert(S_CHECK_EXTERIOR_ORGS);
        edOrgname.SetFocus;
        Exit;
      end
      else
        if (Trim(edContacter.Text) = '') then
        begin
          AppModule.Alert(S_CHECK_EXECUTOR);
          edContacter.SetFocus;
          Exit;
        end;
      if not FKind then
      begin
        if (Trim(cbOffices.Text) = '') then
        begin
          AppModule.Alert(S_CHECK_OFFICE);
          cbOffices.SetFocus;
          Exit;
        end;
        if (Trim(cbPeople.Text) = '') then
        begin
          AppModule.Alert(S_CHECK_EXECUTOR);
          cbPeople.SetFocus;
          Exit;
        end;
      end;
    if not FGiveOut then
    begin
      if (edBackDate.Text = '') then
      begin
        ErrorInBackDate;
        Result := False;
        Exit;
      end;
      if not TryStrToDate(edBackDate.Text, aBackDate) then
      begin
        ErrorInBackDate;
        Result := False;
        Exit;
      end;
      if (aBackDate < MIN_DOC_DATE) then
      begin
        ErrorInBackDate;
        Result := False;
        Exit;
      end;
      if aBackDate < aGiveDate then
      begin
        MessageBox(Editor.Handle, PChar('Дата возврата меньше даты выдачи!'), PChar(S_WARN), MB_OK + MB_ICONWARNING);
        edBackDate.SetFocus;
        Result := False;
        Exit;
      end;
    end;
  end;
  Result := True;
end;

function TKisMapTracingGiving.CreateEditor: TKisEntityEditor;
begin
  Result := TKisMapTracingGivingEditor.Create(Application);
end;

procedure TKisMapTracingGiving.LoadDataIntoEditor(
  Editor: TKisEntityEditor);
begin
  inherited;
  with TKisMapTracingGivingEditor(Editor) do
  begin
    if FKind then
    begin
      edOrgName.Text := Recipient;
      edContacter.Text := PersonName;
    end
    else
    begin
      LoadOfficesAndPeople(nil);
      cbOffices.ItemIndex := cbOffices.Items.IndexOf(Recipient);
      cbOffices.OnChange(nil);
      cbPeople.ItemIndex := cbPeople.Items.IndexOf(PersonName);
    end;
    edGiveDate.Text := GiveDate;
    edPeriod.Text := IntToStr(Period);
    edBackDate.Text := BackDate;
    edComment.Text := Comment;
  end;
end;

procedure TKisMapTracingGiving.PrepareEditor(Editor: TKisEntityEditor);
begin
  inherited;
  with TKisMapTracingGivingEditor(Editor) do
  begin
    btnSelectOrg.Visible := FKind;
    edOrgName.Visible := FKind;
    edContacter.Visible := FKind;
    cbOffices.Visible := not FKind;
    cbPeople.Visible := not FKind;
    if FKind then
    begin
     lRecipient.Caption := 'Наименование организации';
     lPersonName.Caption := 'Контактное лицо';
    end
    else
    begin
     lRecipient.Caption := 'Отдел';
     lPersonName.Caption := 'Исполнитель';
     cbOffices.OnChange := LoadPeopleList;
    end;
    btnSelectOrg.OnClick := SelectOrg;
    gbGive.Enabled := FGiveOut;
    gbBack.Enabled := not FGiveOut;
    if FGiveOut then
      ActiveControl := edGiveDate
    else
      ActiveControl := edBackDate;
  end;
end;

procedure TKisMapTracingGiving.ReadDataFromEditor(
  Editor: TKisEntityEditor);
begin
  inherited;
  with TKisMapTracingGivingEditor(Editor) do
  begin
    if FKind then
    begin
      Recipient := edOrgName.Text;
      PersonName := edContacter.Text;
    end
    else
    begin
      Recipient := cbOffices.Text;
      PersonName := cbPeople.Text;
    end;
    GiveDate := edGiveDate.Text;
    Period := StrToInt(edPeriod.Text);
    BackDate := edBackDate.Text;
    Comment := Trim(edComment.Text);
  end;
end;

procedure TKisMapTracingGiving.UnprepareEditor(Editor: TKisEntityEditor);
begin
  inherited;

end;

procedure TKisMapTracingGiving.SelectOrg(Sender: TObject);
var
  Ent: TKisEntity;
begin
  with TKisLicensedOrgMngr(AppModule[kmLicensedOrgs]) do
  begin
    Ent := KisObject(SelectEntity).AEntity;
    if Assigned(Ent) then
    with TKisMapTracingGivingEditor(EntityEditor) do
    begin
      edOrgname.Text := TKisLicensedOrg(Ent).Name;
      edContacter.Text := TKisLicensedOrg(Ent).MapperFio;
    end;
  end;
end;

procedure TKisMapTracingGiving.LoadOfficesAndPeople(Sender: TObject);
begin
  with EntityEditor as TKisMapTracingGivingEditor do
  begin
    cbOffices.Items := IStringList(AppModule.Lists[klOffices]).StringList;
    cbOffices.ItemIndex := cbOffices.Items.IndexOf(Recipient);
  end;
end;

procedure TKisMapTracingGiving.LoadPeopleList(Sender: TObject);
var
  P: Integer;
begin
  with EntityEditor as TKisMapTracingGivingEditor do
  begin
    if cbOffices.ItemIndex < 0 then
      cbPeople.Items.Clear
    else
    begin
      cbPeople.ItemIndex := -1;
      P := Integer(cbOffices.Items.Objects[cbOffices.ItemIndex]);
      cbPeople.Items := IStringList(AppModule.PeolpeList(P)).StringList;
    end;
  end;
end;

procedure TKisMapTracingMngr.acGiveBackUpdate(Sender: TObject);
begin
  inherited;
  acGiveBack.Enabled := dsMapTracingsPERIOD.AsInteger > 0;
end;

procedure TKisMapTracingMngr.acGiveBackExecute(Sender: TObject);
var
  MapTracing: TKisMapTracing;
begin
  inherited;
  MapTracing := TKisMapTracing(CurrentEntity);
  if Assigned(MapTracing) then
  begin
    MapTracing.Modified := False;
    MapTracing.GiveBack;
    if MapTracing.Modified then
    begin
      SaveEntity(MapTracing);
      dsMapTracings.Refresh;
    end;
  end;
end;

procedure TKisMapTracingMngr.Locate(AId: Integer; LocateFail: Boolean);
begin
  inherited;
  try
    dsMapTracings.DisableControls;
    dsMapTracings.First;
    dsMapTracings.Locate(SF_ID, AId, []);
  finally
    dsMapTracings.EnableControls;
  end;
end;

procedure TKisMapTracingMngr.acLegendExecute(Sender: TObject);
begin
  inherited;
  with FView do
    Legend.ShowLegend(ClientHeight - Legend.FormHeight,
                      ClientWidth - Legend.FormWidth - 10);

end;

procedure TKisMapTracingGiving.SetComment(const Value: String);
begin
  if FComment <> Value then
  begin
    FComment := Value;
    Modified := True;
  end;
end;

{ TMapListCtrlr }

function TMapListCtrlr.CanBack: Boolean;
var
  I: Integer;
  aRecipient: String;
begin
  Result := False;
  if Count = 0 then
    Exit;
  aRecipient := TKisMapTracing(Elements[1]).FRecipient;
  if aRecipient = '' then
    Exit;
  // Все должны быть выданы одному заказчику
  for I := 2 to Count do
    if aRecipient <> TKisMapTracing(Elements[I]).FRecipient then
      Exit;
  Result := True;
end;

function TMapListCtrlr.CanGive: Boolean;
var
  I: Integer;
begin
  Result := False;
  if Count = 0 then
    Exit;
  // Все должны быть не выданы и не в секретной части
  for I := 1 to Count do
    with TKisMapTracing(Elements[I]) do
      if (FRecipient <> '') or IsSecret then
        Exit;
  Result := True;
end;

function TMapListCtrlr.Exists(const Nomenclature: String): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 1 to Count do
    if Nomenclature = TKisMapTracing(Elements[I]).Nomenclature then
      Exit;
  Result := False;
end;

procedure TMapListCtrlr.FillFieldDefs(FieldDefsRef: TFieldDefs);

  function Exists(const Name: String): Boolean;
  begin
    Result := TDefCollection(FieldDefsRef).Find(Name) <> nil;
  end;

begin
  inherited;
  if not Exists(SF_ID) then
    FieldDefsRef.Add(SF_ID, ftInteger);
  if not Exists(SF_NOMENCLATURE) then
    FieldDefsRef.Add(SF_NOMENCLATURE, ftString, 20);
  if not Exists(SF_IS_SECRET) then
    FieldDefsRef.Add(SF_IS_SECRET, ftBoolean);
  if not Exists(SF_RECIPIENT) then
    FieldDefsRef.Add(SF_RECIPIENT, ftString, 255);
end;

function TMapListCtrlr.GetFieldData(Index: Integer; Field: TField;
  out Data): Boolean;
var
  Map: TKisMapTracing;
begin
  Map := TKisMapTracing(Elements[Index]);
  Result := Assigned(Map);
  if Result then
  case Field.FieldNo of
  1 : GetInteger(Map.ID, Data);
  2 : GetString(Map.Nomenclature, Data);
  3 : GetBoolean(Map.IsSecret, Data);
  4 : GetString(Map.FRecipient, Data);
  else
    Result := False
  end;
end;

procedure TKisMapTracingMngr.AddToMapList;
var
  Ent: TKisEntity;
begin
  Ent := CurrentEntity;
  if Assigned(Ent) then
    if not TKisMapTracing(Ent).IsSecret then
    if not FMapsListCtrlr.Exists(TKisMapTracing(Ent).Nomenclature) then
      FMapsListCtrlr.DirectAppend(Ent)
    else
      Ent.Free;
end;

procedure TKisMapTracingMngr.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FMapsList := TCustomDataSet.Create(Self);
  FMapsListCtrlr := TMapListCtrlr.CreateController(Self, Self, keMapTracing);
  FMapsList.Controller := FMapsListCtrlr;
  FMapsList.Open;
  dsMapList.DataSet := FMapsList;
end;

procedure TKisMapTracingMngr.PrepareViewLegend;
begin
  with FView.Legend do
  begin
    ItemOffset := 8;
    Caption := 'Цвета';
    with Items.Add do
    begin
      Color := clWindow;
      Caption := 'В картохранилище';
    end;
    with Items.Add do
    begin
      Color := $9999FF;
      Caption := 'Просрочен';
    end;
    with Items.Add do
    begin
      Color := $99FFFF;
      Caption := 'Выдан на руки';
    end;
    with Items.Add do
    begin
      Color := $CCFFCC;
      Caption := 'В спецчасти';
    end;
  end;
end;

procedure TKisMapTracingMngr.PrepareMassActions;
var
  Btn: TToolButton;
begin
  with TKisMapsMngrView(FView) do
  begin
    tbMassGiving.Images := Self.ImageList;
    Btn := TToolButton.Create(tbMassGiving);
    Btn.Action := acClearMapList;
    tbMassGiving.InsertControl(Btn);
    Btn := TToolButton.Create(tbMassGiving);
    Btn.Action := acMassGiveBack;
    tbMassGiving.InsertControl(Btn);
    Btn := TToolButton.Create(tbMassGiving);
    Btn.Action := acMassGiveOut;
    tbMassGiving.InsertControl(Btn);
    Btn := TToolButton.Create(tbMassGiving);
    Btn.Action := acMassGiveOutToOrg;
    tbMassGiving.InsertControl(Btn);
  end;
end;

procedure TKisMapTracingMngr.ReadViewState;
var
  I: Integer;
begin
  inherited ReadViewState;
  if Assigned(FView) and not (csDestroying in FView.ComponentState) then
    with FView as TKisMapsMngrView do
    begin
      I := AppModule.ReadAppParam(Self, FView, 'MAP_LIST_GRID_WIDTH', varInteger);
      if I > 0 then
        gbGiving.Width := I
      else
        gbGiving.Width := FView.Width div 5;
      AppModule.ReadGridProperties(Self, dbgGiving);
    end;
end;

procedure TKisMapTracingMngr.WriteViewState;
begin
  inherited WriteViewState;
  if Assigned(FView) and not (csDestroying in FView.ComponentState) then
    with FView as TKisMapsMngrView do
    begin
      AppModule.SaveAppParam(Self, FView, 'MAP_LIST_GRID_WIDTH', gbGiving.Width);
      AppModule.WriteGridProperties(Self, dbgGiving);
    end;
end;

procedure TKisMapTracingMngr.acMassGiveOutExecute(Sender: TObject);
begin
  inherited;
  if FMapsListCtrlr.GiveOut(False) then
  begin
    FMapsList.Close;
    FMapsListCtrlr.DirectClear;
    FMapsList.Open;
    Reopen;
  end;
end;

procedure TKisMapTracingMngr.acMassGiveOutToOrgExecute(Sender: TObject);
begin
  inherited;
  if FMapsListCtrlr.GiveOut(True) then
  begin
    FMapsList.Close;
    FMapsListCtrlr.DirectClear;
    FMapsList.Open;
    Reopen;
  end;
end;

procedure TKisMapTracingMngr.acMassGiveBackExecute(Sender: TObject);
begin
  inherited;
  if FMapsListCtrlr.GiveBack then
  begin
    FMapsList.Close;
    FMapsListCtrlr.DirectClear;
    FMapsList.Open;
    Reopen;
  end;
end;

procedure TKisMapTracingMngr.acClearMapListExecute(Sender: TObject);
begin
  inherited;
  FMapsListCtrlr.DirectClear;
  FMapsList.First;
end;

procedure TKisMapTracingMngr.GridKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_SPACE then
  begin
    AddToMapList;
    UpdateGivingsGrid;
  end;
end;

procedure TKisMapTracingMngr.GivingGridKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_SPACE then
    if not FMapsList.IsEmpty then
     FMapsList.Delete;
end;

procedure TKisMapTracingMngr.UpdateGivingsGrid;
begin
  if Assigned(FView) then
  with TKisMapsMngrView(FView) do
  begin
    FMapsList.Active := False;
    FMapsList.Active := True;
    FMapsList.Last;
  end;
end;

procedure TKisMapTracingMngr.GivingsGridCellColors(Sender: TObject;
  Field: TField; var Background, FontColor: TColor; State: TGridDrawState; var FontStyle:TFontStyles);
begin
  if (gdSelected in State) or (gdFocused in State) then
  begin
    Background := clHighlight;
    FontColor := clWindow;
  end
  else
    if FMapsList.FieldByName(SF_IS_SECRET).AsBoolean then
    begin
      BackGround := $CCFFCC;
    end
    else
    if FMapsList.FieldByName(SF_RECIPIENT).AsString <> '' then
      BackGround := $99FFFF;
end;

procedure TKisMapTracingMngr.acClearMapListUpdate(Sender: TObject);
begin
  inherited;
  acClearMapList.Enabled := not FMapsList.IsEmpty;
end;

procedure TKisMapTracingMngr.acMassGiveBackUpdate(Sender: TObject);
begin
  inherited;
  acMassGiveBack.Enabled := FMapsListCtrlr.CanBack;
end;

procedure TKisMapTracingMngr.acMassGiveOutUpdate(Sender: TObject);
begin
  inherited;
  acMassGiveOut.Enabled := FMapsListCtrlr.CanGive;
  acMassGiveOutToOrg.Enabled := acMassGiveOut.Enabled;
end;

function TMapListCtrlr.GiveBack: Boolean;
var
  MapTracing: TKisMapTracing;
  Giving: TKisMapTracingGiving;
  I: Integer;
  aBackDate: String;
begin
  try
    aBackDate := DateToStr(Date);
    Result := MessageBox(
       Application.Handle,
       PChar('Принять сегодняшней датой?'), PChar(S_CONFIRM), MB_YESNO + MB_ICONQUESTION) = IDYES;
    if Result then
      for I := 1 to Count do
      begin
        MapTracing := TKisMapTracing(Elements[I]);
        if Assigned(MapTracing) then
        with MapTracing do
        begin
          Giving := TKisMapTracingGiving(MapTracing.FGivingsCtrlr.Elements[1]);
          Giving.BackDate := aBackDate;
          Giving.Modified := True;
          Mngr.SaveEntity(Giving);
          FGivingsCtrlr.DirectClear;
          FRecipient := '';
          FPersonName := '';
          FGiveDate := '';
          FPeriod := -1;
          FDoNeedCheck := False;
          Modified := True;
          Mngr.SaveEntity(MapTracing);
//          MapTracing.Free;
        end;
      end;
  except
    raise;
  end;
end;

function TMapListCtrlr.GiveOut(ToClient: Boolean): Boolean;
var
  MapTracing: TKisMapTracing;
  Giving: TKisMapTracingGiving;
  I: Integer;
begin
  try
    // Создем новое движение
    Giving := TKisMapTracingGiving(Mngr.CreateEntity(keMapTracingGiving));
    Giving.FKind := ToClient;
    Giving.FPeriod := 1;
    Giving.FGiveDate := DateToStr(Date);
    Giving.FGiveOut := True;
    Giving.Head := nil;
    Giving.Modified := False;
    // Показываем редактор с выбором организаций
    Result := Giving.Edit;
    if Result then
    begin
      if Assigned(Giving) then
      for I := 1 to Count do
      begin
        Giving.ID := TKisMapTracingMngr(Mngr).GenEntityID(keMapTracingGiving);
        MapTracing := TKisMapTracing(Elements[I]);
        Giving.Head := MapTracing;
        Giving.Modified := True;

        if Assigned(MapTracing) then
        with MapTracing do
        begin
          Mngr.SaveEntity(Giving);
          FGivingsCtrlr.DirectClear;
          FRecipient := Giving.Recipient;
          FPersonName := Giving.PersonName;
          FGiveDate := Giving.GiveDate;
          FPeriod := Giving.Period;
          FDoNeedCheck := ToClient;
          Modified := True;
          Mngr.SaveEntity(MapTracing);
        end;
      end;
    end;
    FreeAndNil(Giving);
  except
    raise;
  end;
end;

procedure TKisMapTracingMngr.acPrintExecute(Sender: TObject);
begin
  inherited;
  with PrintModule do
  begin
    ReportFile := AppModule.ReportsPath + 'КГО\Кальки_с_экрана.frf';
    ReportTitle := 'Список калек'; 
    SetMasterDataSet(dsMapTracings, 'MasterData');
    PrintReport;
  end;
end;

procedure TKisMapTracingMngr.UpdateIntNumbers;
var
  Conn: IKisConnection;
  DataSet1, DataSet2: TDataSet;
  MapTracing: TKisMapTracing;
  S: String;
begin
  Conn := GetConnection(True, True);
  try
    DataSet1 := Conn.GetDataSet('SELECT ID, NOMENCLATURE FROM MAP_TRACINGS WHERE INT_NOMENCLATURE IS NULL');
    DataSet1.Open;
    DataSet2 := Conn.GetDataSet(SQ_SAVE_MAP_TRACING_INT_NOMENCLATURE);
    MapTracing := TKisMapTracing(CreateEntity(keMapTracing));
    while not DataSet1.Eof do
    begin
      MapTracing.ID := DataSet1.FieldValues[SF_ID];
      MapTracing.Nomenclature := DataSet1.FieldValues[SF_NOMENCLATURE];
      Conn.SetParam(dataSet2, SF_ID, MapTracing.ID);
      S := MapTracing.IntNomenclature;
      Conn.SetParam(dataSet2, SF_INT_NOMENCLATURE, S);
      DataSet2.Open;
      DataSet2.Close;
      DataSet1.Next;
    end;
    DataSet1.Close;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;


end.
