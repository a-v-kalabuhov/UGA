{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Менеджер геодезических знаков                   }
{                                                       }
{       Copyright (c) 2004, МП УГА                      }
{                                                       }
{       Автор: Сирота Е.А.                              }
{                                                       }
{*******************************************************}

{ Описание: реализует операции над геодезическими знаками
  Имя модуля: uKisGeoPunkts
  Версия: 1.02
  Дата последнего изменения: 06.09.2005
  Цель: модуль содержит реализации классов менеджера геодезических знаков
  Используется: AppModule
  Использует: Kernel Classes
  Исключения: нет }
{
  1.02       06.09.2005
     - переделана работа с отчетами на TKisReportModule

  1.01       25.08.2005
     - вся работа с БД переведена на IKisConnection

  0.1        07.02.2005
     - начальная версия
}

unit uKisGeoPunkts;

{$I KisFlags.pas}

interface

uses
   // System
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  DB, ImgList, ActnList, IBCustomDataSet, DBClient,
  IBDatabase, 
  // Common
   uGC, uIBXUtils, uDataSet,
  // Project
  uKisClasses, uKisSQLClasses, uKisEntityEditor, uKisUtils, uVCLUtils;

type

  TKisGeoPunkt = class(TKisVisualEntity)
    private
      FAName: String;
      FCenterType: String;
      FPunktDate: TDate;
      FCreator: String;
      FPartChief: String;
      FAClass: String;
      FSymbolInfo: String;
      FSymbolInfo2: String;
      FPlaceInfo: String;
      FType1Id: Integer;
      FType2Id: Integer;
      FStatus: Integer;
      FImage: TBitmap;
      procedure SetAName(const Value: String);
      procedure SetCenterType(const Value: String);
      procedure SetPunktDate(const Value: TDate);
      procedure SetCreator(const Value: String);
      procedure SetPartChief(const Value: String);
      procedure SetAClass(const Value: String);
      procedure SetSymbolInfo(const Value: String);
      procedure SetType1Id(const Value: Integer);
      procedure SetType2Id(const Value: Integer);
      procedure SetSymbolInfo2(const Value: String);
      procedure SetPlaceInfo(const Value: String);
      procedure SetStatus(const Value: Integer);
      procedure SetImage(const Value: TBitmap);
      procedure ClearImage;
      procedure PrintReport(Sender: TObject);
    protected
      function CheckEditor(Editor: TKisEntityEditor): Boolean; override;
      function CreateEditor: TKisEntityEditor; override;
      procedure PrepareEditor(Editor: TKisEntityEditor); override;
      procedure LoadDataIntoEditor(Editor: TKisEntityEditor); override;
      procedure ReadDataFromEditor(Editor: TKisEntityEditor); override;
    public
      constructor Create(Mngr: TKisMngr); override;
      destructor Destroy; override;
      class function EntityName: String; override;
      procedure Copy(Source: TKisEntity); override;
      procedure Load(DataSet: TDataSet); override;
      function Equals(Entity: TKisEntity): Boolean; override;
      property AName: String read FAName write SetAName;
      property CenterType: String read FCenterType write SetCenterType;
      property PunktDate: TDate read FPunktDate write SetPunktDate;
      property Creator: String read FCreator write SetCreator;
      property PartChief: String read FPartChief write SetPartChief;
      property AClass: String read FAClass write SetAClass;
      property SymbolInfo: String read FSymbolInfo write SetSymbolInfo;
      property SymbolInfo2: String read FSymbolInfo2 write SetSymbolInfo2;
      property PlaceInfo: String read FPlaceInfo write SetPlaceInfo;
      property Type1Id: Integer read FType1Id write SetType1Id;
      property Type2Id: Integer read FType2Id write SetType2Id;
      property Status: Integer read FStatus write SetStatus;
      property Image: TBitmap read FImage write SetImage;
    end;


  TKisGeoPunktsMngr = class(TKisSQLMngr)
    dsGeoPunkts: TIBDataSet;
    dsGeoPunktsNAME: TStringField;
    dsGeoPunktsCENTER_TYPE: TStringField;
    dsGeoPunktsPUNKT_DATE: TDateField;
    dsGeoPunktsCREATOR: TStringField;
    dsGeoPunktsPART_CHIEF: TStringField;
    dsGeoPunktsTYPES_1_ID: TIntegerField;
    dsGeoPunktsTYPES_2_ID: TIntegerField;
    dsGeoPunktsACLASS: TStringField;
    dsGeoPunktsSYMBOL_INFO: TStringField;
    dsGeoPunktsSYMBOL_INFO_2: TStringField;
    dsGeoPunktsPLACE_INFO: TStringField;
    dsGeoPunktsNAME_TYPE1: TStringField;
    dsGeoPunktsNAME_TYPE2: TStringField;
    dsGeoPunktsSTATUS: TIntegerField;
    dsGeoPunktsID: TIntegerField;
    procedure dsGeoPunktsSTATUSGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure acInsertUpdate(Sender: TObject);
    procedure acDeleteUpdate(Sender: TObject);
    procedure acEditUpdate(Sender: TObject);
  private
    procedure LoadGeoPunktImage(Entity: TKisGeoPunkt);
    procedure PrepareReport(Entity: TKisGeoPunkt);
  protected
    function GenEntityID(EntityKind: TKisEntities = keDefault): Integer; override;
    function IsSupported(Entity: TKisEntity): Boolean; override;
    function GetIdent: TKisMngrs; override;
    function GetMainSQLText: String; override;
    function GetRefreshSQLText: String; override;
    function GetMainDataSet: TDataSet; override;
    procedure Locate(AId: Integer; LocateFail: Boolean = False); override;
    procedure PrepareSQLHelper; override;
    procedure Activate; override;
    procedure Deactivate; override;
    procedure CreateView; override;
  public
    function GetEntity(EntityID: Integer; EntityKind: TKisEntities = keDefault): TKisEntity; override;
    function CreateNewEntity(EntityKind: TKisEntities = keDefault): TKisEntity; override;
    procedure SaveEntity(Entity: TKisEntity); override;
    function IsEntityInUse(Entity: TKisEntity): Boolean; override;
    procedure DeleteEntity(Entity: TKisEntity); override;
    function CreateEntity(EntityKind: TKisEntities): TKisEntity; override;
    function CurrentEntity: TKisEntity; override;
  end;

implementation

{$R *.dfm}

uses
  // System
  {$IFDEF IMAGECOMPRESS}
  ZLib,
  {$ENDIF}
  // Common
  uSQLParsers, FR_Class,
  // Project
  uKisAppModule, uKisConsts, uKisGeoPunktsEditor, uKisPrintModule, uKisIntf,
  uKisSearchClasses;

resourcestring

  // Generators
  SG_GEOPUNKTS = 'GEOPUNKTS';
  // Queries
  SQ_MAIN = 'SELECT G.ID, G.NAME, G.CENTER_TYPE, G.PUNKT_DATE, G.CREATOR, '
            + 'G.PART_CHIEF, G.TYPES_1_ID, G.TYPES_2_ID, G.ACLASS, G.SYMBOL_INFO, '
            + 'G.SYMBOL_INFO_2, G.PLACE_INFO, G.STATUS, GP1.NAME AS NAME_TYPE1, '
            + 'GP2.NAME AS NAME_TYPE2 '
            + 'FROM GEOPUNKTS G '
            + 'LEFT JOIN GPUNKT_TYPES_1 GP1 ON G.TYPES_1_ID=GP1.ID '
            + 'LEFT JOIN GPUNKT_TYPES_2 GP2 ON G.TYPES_2_ID=GP2.ID ';
  SQ_SELECT_GEOPUNKTS = 'SELECT * FROM GEOPUNKTS WHERE ID=%d';
  SQ_SAVE_GEOPUNKTS = 'EXECUTE PROCEDURE SAVE_GEOPUNKTS(:ID, :NAME, :CENTER_TYPE, '
            + ':PUNKT_DATE, :CREATOR, :PART_CHIEF, :TYPES_1_ID, :TYPES_2_ID, '
            + ':ACLASS, :SYMBOL_INFO, :SYMBOL_INFO_2, :PLACE_INFO, :STATUS)';
  SQ_DELETE_GEOPUNKTS = 'DELETE FROM GEOPUNKTS WHERE ID=%d';
  SQ_GET_IMAGE = 'SELECT IMAGE FROM GEOPUNKTS WHERE ID=%d';
  SQ_SET_IMAGE = 'UPDATE GEOPUNKTS SET IMAGE=:IMAGE WHERE ID=:ID';


{ TkisGeoPunkts }

function TKisGeoPunkt.CheckEditor(Editor: TKisEntityEditor): Boolean;
begin
  Result := True;
end;

procedure TKisGeoPunkt.Copy(Source: TKisEntity);
var
  B: Boolean;
begin
  inherited;
  with Source as TKisGeoPunkt do
  begin
    Self.FAName := FAName;
    Self.FCenterType := FCenterType;
    Self.FPunktDate := FPunktDate;
    Self.FCreator := FCreator;
    Self.FPartChief := FPartChief;
    Self.FAClass := FAClass;
    Self.FSymbolInfo := FSymbolInfo;
    Self.FSymbolInfo2 := FSymbolInfo2;
    Self.FPlaceInfo := FPlaceInfo;
    Self.FType1Id := FType1Id;
    Self.FType2Id := FType2Id;
    Self.FStatus := FStatus;
    B := Self.Modified;
    Self.Image := FImage;
    Self.Modified := B;
  end;
end;

function TKisGeoPunkt.CreateEditor: TKisEntityEditor;
begin
   Result := TKisGeoPunktsEditor.Create(Application);
end;

class function TKisGeoPunkt.EntityName: String;
begin
  Result := SEN_GEOPUNKTS;
end;

function TKisGeoPunkt.Equals(Entity: TKisEntity): Boolean;
begin
  inherited Equals(Entity);
  with Entity as TkisGeoPunkt do
  begin
    Result := (Self.FAName = FAName) and (Self.FCenterType = FCenterType)
      and (Self.FPunktDate = FPunktDate) and (Self.FCreator = FCreator)
      and (Self.FPartChief = FPartChief) and (Self.FAClass = FAClass)
      and (Self.FSymbolInfo = FSymbolInfo) and (Self.FSymbolInfo2 = FSymbolInfo2)
      and (Self.FPlaceInfo = FPlaceInfo) and (Self.FType1Id = FType1Id)
      and (Self.FType2Id = FType2Id) and (Self.FStatus = FStatus);
  end;
end;

procedure TKisGeoPunkt.Load(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    Self.ID := FieldByName(SF_ID).AsInteger;
    Self.FAName := FieldByName(SF_NAME).AsString;
    Self.FCenterType := FieldByName(SF_CENTER_TYPE).AsString;
    Self.FPunktDate := FieldByName(SF_PUNKT_DATE).AsDateTime;
    Self.FCreator := FieldByName(SF_CREATOR).AsString;
    Self.FPartChief := FieldByName(SF_PART_CHIEF).AsString;
    Self.FAClass := FieldByName(SF_ACLASS).AsString;
    Self.FSymbolInfo := FieldByName(SF_SYMBOL_INFO).AsString;
    Self.FSymbolInfo2 := FieldByName(SF_SYMBOL_INFO2).AsString;
    Self.FPlaceInfo := FieldByName(SF_PLACE_INFO).AsString;
    Self.FType1Id := FieldByName(SF_TYPE1_ID).AsInteger;
    Self.FType2Id := FieldByName(SF_TYPE2_ID).AsInteger;
    Self.Status := FieldByName(SF_STATUS).AsInteger;
    Self.Image := TPicture(FieldByName(SF_IMAGE)).Bitmap;
  end;
end;

procedure TKisGeoPunkt.LoadDataIntoEditor(Editor: TKisEntityEditor);
begin
  with Editor as TKisGeoPunktsEditor do
  begin
    edName.Text := AName;
    edCenterType.Text := CenterType;
    edPunktDate.Text := DateToStr(PunktDate);
    edCreator.Text := Creator;
    edPartChief.Text := PartChief;
    edClass.Text := AClass;
    edSymbolInfo.Text := SymbolInfo;
    edSymbolInfo2.Text := SymbolInfo2;
    edPlaceInfo.Text := PlaceInfo;
    cbStatus.Checked := Boolean(Status);
    ComboLocate(cbPunktType1, Type1Id);
    ComboLocate(cbPunktType2, Type2Id);
    ImgGeoPunkt.Picture.Bitmap := Image;
  end;
end;

procedure TKisGeoPunkt.PrepareEditor(Editor: TKisEntityEditor);
var
  PunktTypes: TStringList;
begin
  inherited;
  SetControlState(Editor, ReadOnly);
  with Editor as TKisGeoPunktsEditor do
  begin
    PunktTypes := IObject(AppModule.Lists[klPunktType1]).AObject as TStringList;
    cbPunktType1.Items.Assign(PunktTypes);
    cbPunktType1.Enabled := not ReadOnly;
    PunktTypes := IObject(AppModule.Lists[klPunktType2]).AObject as TStringList;
    cbPunktType2.Items.Assign(PunktTypes);
    cbPunktType2.Enabled := not ReadOnly;
    btnLoadImage.Enabled := not ReadOnly;
    btnClearImage.Enabled := not ReadOnly;
    btnOK.Enabled := not ReadOnly;
    btnPrintReport.OnClick := PrintReport;
    btnPrintReport.Enabled := True;
  end;
end;

procedure TKisGeoPunkt.ReadDataFromEditor(Editor: TKisEntityEditor);
begin
  inherited;
  with Editor as TKisGeoPunktsEditor do
  begin
    Type1Id := Integer(cbPunktType1.Items.Objects[cbPunktType1.ItemIndex]);
    Type2Id := Integer(cbPunktType2.Items.Objects[cbPunktType2.ItemIndex]);
    AName := edName.Text;
    CenterType := edCenterType.Text;
    PunktDate := StrToDate(edPunktDate.Text);
    Creator := edCreator.Text;
    PartChief := edPartChief.Text;
    AClass := edClass.Text;
    SymbolInfo := edSymbolInfo.Text;
    SymbolInfo2 := edSymbolInfo2.Text;
    PlaceInfo := edPlaceInfo.Text;
    Status := Integer(cbStatus.Checked);
    Image := ImgGeoPunkt.Picture.Bitmap;
  end;
end;

procedure TKisGeoPunkt.SetAClass(const Value: String);
begin
  if FAClass <> Value then
  begin
    FAClass := Value;
    Modified := True;
  end;
end;

procedure TKisGeoPunkt.SetAName(const Value: String);
begin
  if FAName <> Value then
  begin
    FAName := Value;
    Modified := True;
  end;
end;

procedure TKisGeoPunkt.SetCenterType(const Value: String);
begin
  if FCenterType <> Value then
  begin
    FCenterType := Value;
    Modified := True;
  end;
end;


procedure TKisGeoPunkt.SetCreator(const Value: String);
begin
  if FCreator <> Value then
  begin
    FCreator := Value;
    Modified := True;
  end;
end;


procedure TKisGeoPunkt.SetImage(const Value: TBitmap);
begin
  if FImage <> Value then
  begin
    FreeAndNil(FImage);
    if Assigned(Value) then
    begin
      FImage := TBitmap.Create;
      FImage.Assign(Value);
    end;
    Modified := True;
  end;
end;

procedure TKisGeoPunkt.SetPartChief(const Value: String);
begin
  if FPartChief <> Value then
  begin
    FPartChief := Value;
    Modified := True;
  end;
end;

procedure TKisGeoPunkt.SetPlaceInfo(const Value: String);
begin
  if FPlaceInfo <> Value then
  begin
    FPlaceInfo := Value;
    Modified := True;
  end;
end;

procedure TKisGeoPunkt.SetPunktDate(const Value: TDate);
begin
  if FPunktDate <> Value then
  begin
    FPunktDate := Value;
    Modified := True;
  end;
end;

procedure TKisGeoPunkt.SetStatus(const Value: Integer);
begin
  if FStatus <> Value then
  begin
    FStatus := Value;
    Modified := True;
  end;
end;

procedure TKisGeoPunkt.SetSymbolInfo(const Value: String);
begin
  if FSymbolInfo <> Value then
  begin
    FSymbolInfo := Value;
    Modified := True;
  end;
end;

procedure TKisGeoPunkt.SetSymbolInfo2(const Value: String);
begin
  if FSymbolInfo2 <> Value then
  begin
    FSymbolInfo2 := Value;
    Modified := True;
  end;
end;

procedure TKisGeoPunkt.SetType1Id(const Value: Integer);
begin
  if FType1Id <> Value then
  begin
    FType1Id := Value;
    Modified := True;
  end;
end;

procedure TKisGeoPunkt.SetType2Id(const Value: Integer);
begin
  if FType2Id <> Value then
  begin
    FType2Id := Value;
    Modified := True;
  end;
end;

{ TKisGeoPunktsMngr }

function TKisGeoPunktsMngr.CreateEntity(
  EntityKind: TKisEntities): TKisEntity;
begin
  Result := TKisGeoPunkt.Create(Self);
end;

function TKisGeoPunktsMngr.CreateNewEntity(
  EntityKind: TKisEntities): TKisEntity;
begin
  Result := TKisGeoPunkt.Create(Self);
  Result.ID := GenEntityID();
end;

procedure TKisGeoPunktsMngr.DeleteEntity(Entity: TKisEntity);
var
  Conn: IKisConnection;
begin
  if not IsSupported(Entity) then
    inherited;
  Conn := GetConnection(True, True);
  try
    if IsEntityInUse(Entity) then
      inherited;
    Conn.GetDataSet(Format(SQ_DELETE_GEOPUNKTS, [Entity.ID])).Open;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

function TKisGeoPunktsMngr.GenEntityID(EntityKind: TKisEntities): Integer;
begin
  Result := AppModule.GetID(SG_GEOPUNKTS, Self.DefaultTransaction);
end;

function TKisGeoPunktsMngr.GetEntity(EntityID: Integer;
  EntityKind: TKisEntities): TKisEntity;
var
  Conn: IKisConnection;
  DataSet: TDataSet;
  Gp: TKisGeoPunkt;
begin
  Conn := GetConnection(True, False);
  try
    DataSet := Conn.GetDataSet(Format(SQ_SELECT_GEOPUNKTS, [EntityID]));
    DataSet.Open;
    if not DataSet.IsEmpty then
    begin
      Gp := TKisGeoPunkt.Create(Self);
      with DataSet do
      begin
        Gp.ID := EntityID;
        Gp.AName := FieldByName(SF_NAME).AsString;
        Gp.CenterType := FieldByName(SF_CENTER_TYPE).AsString;
        Gp.PunktDate := FieldByName(SF_PUNKT_DATE).AsDateTime;
        Gp.Creator := FieldByName(SF_CREATOR).AsString;
        Gp.PartChief := FieldByName(SF_PART_CHIEF).AsString;
        Gp.AClass := FieldByName(SF_ACLASS).AsString;
        Gp.SymbolInfo := FieldByName(SF_SYMBOL_INFO).AsString;
        Gp.SymbolInfo2 := FieldByName(SF_SYMBOL_INFO2).AsString;
        Gp.Type1Id := FieldByName(SF_TYPE1_ID).AsInteger;
        Gp.Type2Id := FieldByName(SF_TYPE2_ID).AsInteger;
        Gp.Status := FieldByName(SF_STATUS).AsInteger;
        Gp.PlaceInfo := FieldByName(SF_PLACE_INFO).AsString;
        LoadGeoPunktImage(Gp);
        Gp.ReadOnly := not (KisAppModule.User.IsAdministrator or (KisAppModule.User.OfficeID = ID_OFFICE_GIS));
        Result := Gp;
      end;
    end
    else
      Result := nil;
  finally
    FreeConnection(Conn, True);
  end;
end;

function TKisGeoPunktsMngr.GetIdent: TKisMngrs;
begin
  Result := kmGeoPunkts;
end;

function TKisGeoPunktsMngr.GetMainSQLText: String;
begin
  Result := SQ_MAIN;
end;

function TKisGeoPunktsMngr.IsEntityInUse(Entity: TKisEntity): Boolean;
begin
  Result := false;
end;

function TKisGeoPunktsMngr.IsSupported(Entity: TKisEntity): Boolean;
begin
  Result := Assigned(Entity) and (Entity is TKisGeoPunkt);
  if not Result then
    Result := inherited IsSupported(Entity);
end;

procedure TKisGeoPunktsMngr.SaveEntity(Entity: TKisEntity);
var
  Conn: IKisConnection;
  DataSet: TDataSet;
  Str: TStream;
begin
  Conn := GetConnection(True, True);
  try
    DataSet := Conn.GetDataSet(SQ_SAVE_GEOPUNKTS);
    with Entity as TKisGeoPunkt do
    begin
      Conn.SetParam(DataSet, SF_ID, ID);
      Conn.SetParam(DataSet, SF_NAME, AName);
      Conn.SetParam(DataSet, SF_CENTER_TYPE, CenterType);
      Conn.SetParam(DataSet, SF_PUNKT_DATE, DateToStr(PunktDate));
      Conn.SetParam(DataSet, SF_CREATOR, Creator);
      Conn.SetParam(DataSet, SF_PART_CHIEF, PartChief);
      Conn.SetParam(DataSet, SF_ACLASS, AClass);
      Conn.SetParam(DataSet, SF_SYMBOL_INFO, SymbolInfo);
      Conn.SetParam(DataSet, SF_SYMBOL_INFO2, SymbolInfo2);
      Conn.SetParam(DataSet, SF_PLACE_INFO, PlaceInfo);
      Conn.SetParam(DataSet, SF_TYPE1_ID, Type1Id);
      Conn.SetParam(DataSet, SF_TYPE2_ID, Type2Id);
      Conn.SetParam(DataSet, SF_STATUS, Status);
    end;
    DataSet.Open;
    ///
    with Entity as TKisGeoPunkt do
      if Assigned(Image) then
      begin
        DataSet := Conn.GetDataSet(SQ_SET_IMAGE);
        Str := IObject(TMemoryStream.Create).AObject as TStream;
        Image.SaveToStream(Str);
        Str.Position := 0;
        Conn.SetParam(DataSet, SF_ID, ID);
        Conn.SetBlobParam(DataSet, SF_IMAGE, Str);
        DataSet.Open;
      end;
    FreeConnection(Conn, True);
  except
    FreeConnection(Conn, False);
    raise;
  end;
end;

procedure TKisGeoPunktsMngr.Activate;
begin
  inherited;
  dsGeoPunkts.Transaction := AppModule.Pool.Get;
  dsGeoPunkts.Transaction.Init();
  dsGeoPunkts.Transaction.AutoStopAction := saNone;
  Reopen;
end;

procedure TKisGeoPunktsMngr.CreateView;
begin
  inherited;
  FView.Caption := 'Геодезические знаки'; 
end;

function TKisGeoPunktsMngr.CurrentEntity: TKisEntity;
begin
  Result := GetEntity(dsGeoPunkts.FieldByName(SF_ID).AsInteger, keGeoPunkts);
  TKisVisualEntity(Result).ReadOnly := True;
end;

procedure TKisGeoPunktsMngr.dsGeoPunktsSTATUSGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  inherited;
  if Boolean(Sender.AsInteger) then
    Text := 'Действителен'
  else
    Text := 'Уничтожен';
end;

procedure TKisGeoPunktsMngr.Deactivate;
begin
  inherited;
  dsGeoPunkts.Close;
  if not dsGeoPunkts.Transaction.Active then
     dsGeoPunkts.Transaction.Commit;
  AppModule.Pool.Back(dsGeoPunkts.Transaction);
end;

procedure TKisGeoPunktsMngr.PrepareSQLHelper;
begin
  inherited;
  with FSQLHelper do
  begin
    with AddTable do
    begin
      TableName := ST_GEOPUNKTS;
      TableLabel := 'Основная (Геодезические знаки)';
      AddStringField(SF_NAME, 'Наименование знака', 80, [fpSearch, fpSort, fpQuickSearch]);
      AddStringField(SF_CENTER_TYPE, 'Тип центра', 40, [fpSearch, fpSort, fpQuickSearch]);
      AddSimpleField(SF_PUNKT_DATE, 'Дата координирования', ftDate, [fpSearch, fpSort]);
      AddStringField(SF_CREATOR, 'Исполнитель',30, [fpSearch, fpSort, fpQuickSearch]);
      AddStringField(SF_PART_CHIEF, 'Начальник партии',30, [fpSearch, fpSort, fpQuickSearch]);
      AddStringField(SF_ACLASS, 'Класс пункта', 20, [fpSearch, fpSort, fpQuickSearch]);
      AddStringField(SF_SYMBOL_INFO, 'Наружный знак', 100, [fpSearch, fpSort, fpQuickSearch]);
      AddStringField(SF_SYMBOL_INFO2, 'Чертеж центра', 100, [fpSearch, fpSort, fpQuickSearch]);
      AddStringField(SF_PLACE_INFO, 'Описание местоположения', 255, [fpSearch, fpSort, fpQuickSearch]);
    end;
  end;
end;

procedure TKisGeoPunktsMngr.acInsertUpdate(Sender: TObject);
begin
  acInsert.Enabled := AppModule.User.CanDoAction(maInsert, keGeoPunkts);
end;

procedure TKisGeoPunktsMngr.acDeleteUpdate(Sender: TObject);
begin
  acDelete.Enabled := AppModule.User.CanDoAction(maDelete, keGeoPunkts);
end;

procedure TKisGeoPunktsMngr.acEditUpdate(Sender: TObject);
begin
  acEdit.Enabled := AppModule.User.CanDoAction(maEdit, keGeoPunkts);
end;

constructor TKisGeoPunkt.Create;
begin
  inherited;
  FImage := TBitmap.Create;
end;

destructor TKisGeoPunkt.Destroy;
begin
  FreeAndNil(FImage);
  inherited;
end;

procedure TKisGeoPunktsMngr.LoadGeoPunktImage(Entity: TKisGeoPunkt);
var
  Conn: IKisConnection;
{$IFDEF IMAGECOMPRESS}
  bStream, dStream: TStream;
{$ENDIF}
begin
  Conn := GetConnection(True, False);
  try
    with Conn.GetDataSet(Format(SQ_GET_IMAGE, [Entity.ID])) do
    begin
      Open;
      if not IsEmpty then
      begin
        {$IFDEF IMAGECOMPRESS}
        bStream := CreateBlobStream(Fields[0], bmRead);
        dStream := TDecompressionStream.Create(bStream);
        Entity.FImage.LoadFromStream(dStream);
        {$ELSE}
        Entity.FImage.LoadFromStream(
          IObject(CreateBlobStream(Fields[0], bmRead)).AObject as TStream);
        {$ENDIF}
      end
      else
        Entity.ClearImage;
    end;
  finally
    FreeConnection(Conn, True);
  end;
end;

procedure TKisGeoPunktsMngr.Locate(AId: Integer; LocateFail: Boolean);
begin
  inherited;
  dsGeoPunkts.Locate(SF_ID, AId, []);
end;

procedure TKisGeoPunkt.ClearImage;
begin
  FreeAndNil(FImage);
  FImage := TBitmap.Create;
end;

procedure TKisGeoPunktsMngr.PrepareReport(Entity: TKisGeoPunkt);
var
  Plan: TfrView;
  L: TStringList;
  v: Variant;
begin
  with PrintModule do
  begin
    ReportFile := AppModule.ReportsPath + 'Геодезические знаки.frf';
    L := IObject(TStringList.Create).AObject as TStringList;
    L.Delimiter := ' ';
    if AppModule.GetFieldValue(DefaultTransaction, ST_GPUNKT_TYPE1, SF_ID, SF_NAME,
            Entity.FType1Id, V)
    then
      SetParamValue('PunktType1', QuotedStr(V))
    else
      SetParamValue('PunktType1', '');
    if AppModule.GetFieldValue(Self.DefaultTransaction, ST_GPUNKT_TYPE2, SF_ID, SF_NAME,
            Entity.FType2Id, V)
    then
      SetParamValue('PunktType2', QuotedStr(V))
    else
      SetParamValue('PunktType2', '');
    SetParamValue('PunktClass', QuotedStr(Entity.FAClass));
    SetParamValue('AName', QuotedStr(Entity.FAName));
    SetParamValue('CenterType', QuotedStr(Entity.FCenterType));
    L.Text := Entity.FPlaceInfo;
    SetParamValue('PlaceInfo', QuotedStr(L.DelimitedText));
    L.Text := Entity.SymbolInfo;
    SetParamValue('SymbolInfo', QuotedStr(L.DelimitedText));
    L.Text := Entity.FSymbolInfo2;
    SetParamValue('SymbolInfo2', QuotedStr(L.DelimitedText));
    SetParamValue('PunktDate', QuotedStr(DateToStr(Entity.FPunktDate)));
    SetParamValue('Creator', QuotedStr(Entity.FCreator));
    SetParamValue('PartChief', QuotedStr(Entity.FPartChief));

    Plan := frReport.FindObject('GeoImage');
    if Assigned(Plan) then
    if not (Plan is TfrPictureView) then
      Plan := nil;
    if Assigned(Plan) then
    begin
      if Entity.Image.HandleAllocated then
        TfrPictureView(Plan).Picture.Bitmap.Assign(Entity.Image);
    end;
    PrintReport;
  end;
end;

procedure TKisGeoPunkt.PrintReport;
begin
  TKisGeoPunktsMngr(Self.Manager).PrepareReport(Self);
end;

function TKisGeoPunktsMngr.GetMainDataSet: TDataSet;
begin
  Result := dsGeoPunkts;
end;

function TKisGeoPunktsMngr.GetRefreshSQLText: String;
begin
  Result := GetMainSQLtext + ' WHERE G.ID=:ID';
end;

end.
