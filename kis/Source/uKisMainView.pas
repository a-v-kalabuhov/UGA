{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Гланое окно приложения                          }
{                                                       }
{       Copyright (c) 2003-2005, МП УГА                 }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание:
  Имя модуля: Kernel SQL Classes
  Версия: 1.04
  Дата последнего изменения: 04.05.2005
  Цель: содержит классы, обеспецивающие работу системы с SQL-серверами .
  Используется:
  Использует:   CustomDataSet, IBX Utilities, SQL Parsers,
  Исключения:   }
{
  1.04           04.05.2005
     - удален модуль "Снимаемая ситуация"

  1.03
     - добавлен модуль "Лицензированные организации"

  1.02           22.11.2004
     - изменена фильтрация писем - добавлен фильтр по отделу
}

unit uKisMainView;

{$I KisFlags.pas}

interface

uses
  // System
  Windows, Controls, ExtCtrls, DBCtrls, StdCtrls, ComCtrls, ToolWin, Menus,
  Classes, Forms, ImgList, Buttons, AppEvnts, SysUtils, ActnList, DbGrids, Dialogs,
  StdActns, Db, IBDatabase, IBSQL, IBQuery,
  // Jedi
  JvComponentBase, JvFormPlacement, JvBaseDlg, JvDesktopAlert,
  // shared
  uIBXUtils, uCommonUtils, uGC,
  // Project
  IBChild, uMfClasses, uKisFilters;

type
  TIBChildClass = class of TIBChildForm;

  TKisMainView = class(TForm)
    MainMenu: TMainMenu;
    itmTables: TMenuItem;
    GuideMenu: TMenuItem;
    AboutItem: TMenuItem;
    itmHelp: TMenuItem;
    itmFirms: TMenuItem;
    itmStreets: TMenuItem;
    itmWindow: TMenuItem;
    itmWindowNext: TMenuItem;
    itmWindowCascade: TMenuItem;
    itmWindowArrange: TMenuItem;
    itmWindowMinimize: TMenuItem;
    itmRegions: TMenuItem;
    itmVillages: TMenuItem;
    itmPropForm: TMenuItem;
    itmDecreeTypes: TMenuItem;
    itmWindowClose: TMenuItem;
    itmOfficesDocs: TMenuItem;
    itmLetters: TMenuItem;
    itmPeople: TMenuItem;
    itmDocTypes: TMenuItem;
    itmConfig: TMenuItem;
    ImageList: TImageList;
    ActionList: TActionList;
    WindowClose: TWindowClose;
    WindowArrange: TWindowArrange;
    WindowCascade: TWindowCascade;
    WindowMinimizeAll: TWindowMinimizeAll;
    WindowTileHorizontal: TWindowTileHorizontal;
    WindowTileVertical: TWindowTileVertical;
    itmTileVertically: TMenuItem;
    itmArrange: TMenuItem;
    itmEdit: TMenuItem;
    EditCopy: TEditCopy;
    EditCut: TEditCut;
    EditDelete: TEditDelete;
    EditPaste: TEditPaste;
    EditSelectAll: TEditSelectAll;
    EditUndo: TEditUndo;
    itmEditCut: TMenuItem;
    itmEditCopy: TMenuItem;
    itmEditPaste: TMenuItem;
    N7: TMenuItem;
    itmEditUndo: TMenuItem;
    itmEditDelete: TMenuItem;
    N10: TMenuItem;
    itmEditSelectAll: TMenuItem;
    StatusBar: TStatusBar;
    N1: TMenuItem;
    itmDecrees: TMenuItem;
    FormStorage: TJvFormStorage;
    itmOffices: TMenuItem;
    itmAllotments: TMenuItem;
    itmAllotmentsReg: TMenuItem;
    itmAllotmentsAll: TMenuItem;
    itmSignatures: TMenuItem;
    Transaction: TIBTransaction;
    itmPPDTypes: TMenuItem;
    N2: TMenuItem;
    itmNomen: TMenuItem;
    itmAddressWorks: TMenuItem;
    itmAddresses: TMenuItem;
    itmAccounts: TMenuItem;
    itmSoglas: TMenuItem;
    itmExport: TMenuItem;
    N8: TMenuItem;
    N6: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    miOutcomingLetters: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    miINNCheck: TMenuItem;
    N15: TMenuItem;
    miMaps500: TMenuItem;
    miDecrees: TMenuItem;
    N17: TMenuItem;
    miArchivalDocs: TMenuItem;
    N5: TMenuItem;
    N19: TMenuItem;
    miMapTracings: TMenuItem;
    N21: TMenuItem;
    miKiosks: TMenuItem;
    N23: TMenuItem;
    miMap: TMenuItem;
    miLoadKiosks: TMenuItem;
    OpenDialog1: TOpenDialog;
    miLoad1C: TMenuItem;
    miScans: TMenuItem;
    N26: TMenuItem;
    miScanOrders: TMenuItem;
    JvDesktopAlert1: TJvDesktopAlert;
    miScansView: TMenuItem;
    procedure AboutItemClick(Sender: TObject);
    procedure itmWindowNextClick(Sender: TObject);
    procedure WindowCloseItemClick(Sender: TObject);
    procedure itmDecreeTypesClick(Sender: TObject);
    procedure itmRegionsClick(Sender: TObject);
    procedure itmVillagesClick(Sender: TObject);
    procedure itmDecreesClick(Sender: TObject);
    procedure itmFirmsClick(Sender: TObject);
    procedure itmOfficesClick(Sender: TObject);
    procedure itmPeopleClick(Sender: TObject);
    procedure itmDocTypesClick(Sender: TObject);
    procedure itmPropFormClick(Sender: TObject);
    procedure itmAllotmentsRegClick(Sender: TObject);
    procedure itmAllotmentsAllClick(Sender: TObject);
    procedure itmSignaturesClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure itmPPDTypesClick(Sender: TObject);
    procedure itmOfficesDocsClick(Sender: TObject);
    procedure itmNomenClick(Sender: TObject);
    procedure itmAddressWorksClick(Sender: TObject);
    procedure itmAddressesClick(Sender: TObject);
    procedure itmStreetsClick(Sender: TObject);
    procedure itmBFirmTypesClick(Sender: TObject);
    procedure itmBuildingObjectTypesClick(Sender: TObject);
    procedure itmAccountsClick(Sender: TObject);
    procedure itmSoglasClick(Sender: TObject);
    procedure itmLetterClick(Sender: TObject);
    procedure itmExportClick(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure miOutcomingLettersClick(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure miINNCheckClick(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure miArchivalDocsClick(Sender: TObject);
    procedure miMaps500Click(Sender: TObject);
    procedure miMapTracingsClick(Sender: TObject);
    procedure miMapClick(Sender: TObject);
    procedure miLoad1CClick(Sender: TObject);
    procedure miScansClick(Sender: TObject);
    procedure miScanOrdersClick(Sender: TObject);
    procedure miScansViewClick(Sender: TObject);
  private
    FMode: Byte;
    FMenuCounter: Integer;
    function AddMenuItem(ParentItem: TMenuItem;
       Tag: Integer; const Caption, Name: string): TMenuItem;
    procedure ShowAlertMessage(Sender: TObject; const MessageText: String);
    procedure ShowAllotments(Registration: Boolean);
    procedure ShowChildForm(var ChildForm: TIBChildForm; ChildClass: TIBChildClass;
      ShowNow: Boolean = True);
    procedure ShowLetters(DocTypeId, OwnerOrgId: Integer);
    procedure UpdateByMode;
  public
    procedure CloseAllWindows;
    procedure FillLettersMenu;
    procedure UncheckSubitems(MenuItem: TMenuItem);
    procedure UpdateData;
    procedure UpdateCntrls;
  end;

var
  KisMainView: TKisMainView;

implementation

{$R *.DFM}
uses
  // Project
  AGrids6, AFile6, uKisAbout, Regions, Villages, Decrees, FindDlg, Sort6,
  Offices, People, DocTypes, PropForms, Allotments, Signatures, uKisUtils,
  PPDTypes, uKisNomenclatureCalc, DecreeTypes, AddressWorks, Addresses,
  Streets, BFirmTypes, BObjectTypes, Soglass, Accounts, uKisINNCheck, uKisIntf,
  ExportToText, uKisClasses, uKisConsts, uKisAppModule, uKisSQLClasses, uKisOrders, uKisOrdersImport1CView;

resourcestring
  SQ_SELECT_ORGS = 'SELECT ID, SHORTNAME FROM ORGS ORDER BY 2';
  SQ_SELECT_DOC_TYPES = 'SELECT ID, NAME FROM DOC_TYPES WHERE ORGS_ID=%d AND INCOMING=1 ORDER BY 2';
  SQ_SELECT_B_OBJECT_TYPES = 'SELECT ID, NAME FROM B_OBJECT_TYPES ORDER BY 1';

procedure TKisMainView.FormShow(Sender: TObject);
begin
  UpdateData;
end;

procedure TKisMainView.itmWindowNextClick(Sender: TObject);
begin
  Next;
end;

procedure TKisMainView.AboutItemClick(Sender: TObject);
begin
  with TAboutForm.Create(Application) do
  	ShowModal;
end;

procedure TKisMainView.WindowCloseItemClick(Sender: TObject);
begin
  if ActiveMDIChild <> nil then ActiveMDIChild.Close;
end;

procedure TKisMainView.CloseAllWindows;
var
  I: Integer;
begin
  for I := N_ZERO to Pred(MDIChildCount) do
    MDIChildren[I].Close;
  Application.ProcessMessages;
end;

procedure TKisMainView.ShowChildForm(var ChildForm: TIBChildForm; ChildClass: TIBChildClass;
  ShowNow: Boolean = True);
begin
  if not Assigned(ChildForm) then
  begin
    ChildForm := ChildClass.Create(Application);
    if ShowNow then
      ChildForm.ShowForm;
  end
  else
    ChildForm.BringToFront;
end;

//районы
procedure TKisMainView.itmRegionsClick(Sender: TObject);
begin
  ShowChildForm(TIBChildForm(RegionsForm),TRegionsForm);
end;

//органы власти
procedure TKisMainView.itmDecreeTypesClick(Sender: TObject);
begin
  ShowChildForm(TIBChildForm(DecreeTypesForm),TDecreeTypesForm);
end;

//поселки
procedure TKisMainView.itmVillagesClick(Sender: TObject);
begin
  ShowChildForm(TIBChildForm(VillagesForm),TVillagesForm);
end;

//нормативные акты
procedure TKisMainView.itmDecreesClick(Sender: TObject);
begin
  ShowChildForm(TIBChildForm(DecreesForm),TDecreesForm);
end;

//организации
procedure TKisMainView.itmFirmsClick(Sender: TObject);
begin
  AppModule.SQLMngrs[kmFirms].ShowEntities;
end;

//отделы
procedure TKisMainView.itmOfficesClick(Sender: TObject);
begin
  ShowChildForm(TIBChildForm(OfficesForm),TOfficesForm);
end;

//сотрудники
procedure TKisMainView.itmPeopleClick(Sender: TObject);
begin
  ShowChildForm(TIBChildForm(PeopleForm),TPeopleForm);
end;

//типы документов
procedure TKisMainView.itmDocTypesClick(Sender: TObject);
begin
  ShowChildForm(TIBChildForm(DocTypesForm),TDocTypesForm);
end;

procedure TKisMainView.itmPropFormClick(Sender: TObject);
begin
  ShowChildForm(TIBChildForm(PropFormsForm),TPropFormsForm);
end;

procedure TKisMainView.itmAllotmentsRegClick(Sender: TObject);
begin
  ShowAllotments(True);
end;

procedure TKisMainView.itmAllotmentsAllClick(Sender: TObject);
begin
  ShowAllotments(False);
end;

procedure TKisMainView.ShowAlertMessage(Sender: TObject;
  const MessageText: String);
begin
  JvDesktopAlert1.MessageText := MessageText;
  JvDesktopAlert1.Execute;
end;

procedure TKisMainView.ShowAllotments(Registration: Boolean);
var
  Created: Boolean;
begin
  if Assigned(AllotmentsForm) and (AllotmentsForm.Registration <> Registration) then
  begin
    AllotmentsForm.Close;
    Application.ProcessMessages;
  end;
  Created:=(AllotmentsForm = nil);
  ShowChildForm(TIBCHildForm(AllotmentsForm), TAllotmentsForm,False);
  if Created then
  begin
    AllotmentsForm.Registration:=Registration;
    if Registration then
      AllotmentsForm.Query.AsSQL.AddWhereCondition('CHECKED=0');
    AllotmentsForm.ShowForm;
  end;
end;

procedure TKisMainView.itmSignaturesClick(Sender: TObject);
begin
  ShowChildForm(TIBChildForm(SignaturesForm),TSignaturesForm);
end;

procedure TKisMainView.itmLetterClick(Sender: TObject);
var
  I: Integer;
begin
  if (Sender is TMenuItem) and Assigned(TMenuItem(Sender).Parent) then
  begin
    I := TMenuItem(Sender).Parent.Tag;
    ShowLetters(TMenuItem(Sender).Tag - I * N_TEN, I);
  end;
end;

procedure TKisMainView.ShowLetters(DocTypeId, OwnerOrgId: Integer);
var
  AOfficeId: Integer;
  Filters: IKisFilters;
begin
  with AppModule.User do
    if IsAdministrator or (RoleName = S_ROLE_CHANCELLERY)
       or (RoleName = S_ROLE_MP_CHANCELLERY) or (RoleName = S_ROLE_EXECUTION_CONTROL) then
      AOfficeId := 0
    else
      AOfficeId := OfficeId;
  with TFilterFactory do
  begin
    Filters := CreateList();
    Filters.Add(CreateFilter(SF_DOC_TYPES_ID, DocTypeId));
    Filters.Add(CreateFilter(SF_ORGS_ID, OwnerOrgId));
    Filters.Add(CreateFilter(FF_OFFICE_PASSING, AOfficeId, frNone));
  end;
  AppModule.SQLMngrs[kmLetters].ShowEntities(Filters);
end;

procedure TKisMainView.UncheckSubitems(MenuItem: TMenuItem);
var
  I: Integer;
begin
  for I := 0 to Pred(MenuItem.Count) do
  begin
    if MenuItem[I].Count > 0 then
      UncheckSubitems(MenuItem[I]);
    MenuItem[I].Checked := False;
  end;
end;

procedure TKisMainView.itmPPDTypesClick(Sender: TObject);
begin
  ShowChildForm(TIBChildForm(PPDTypesForm), TPPDTypesForm);
end;

procedure TKisMainView.itmOfficesDocsClick(Sender: TObject);
var
  Filter: IKisFilter;
begin
  if AppModule.User.IsAdministrator then
    Filter := nil
  else
    Filter := TFilterFactory.CreateFilter(SF_OFFICES_ID, AppModule.User.OfficeID);
  AppModule.SQLMngrs[kmOfficeDocs].ShowEntities(TFilterFactory.CreateList(Filter));
end;

procedure TKisMainView.itmNomenClick(Sender: TObject);
begin
  ShowNomenclatureCalculator;
end;

procedure TKisMainView.itmAddressWorksClick(Sender: TObject);
begin
  ShowChildForm(TIBChildForm(AddressWorksForm),TAddressWorksForm);
end;

procedure TKisMainView.itmAddressesClick(Sender: TObject);
begin
  ShowChildForm(TIBChildForm(AddressesForm), TAddressesForm);
end;

procedure TKisMainView.itmStreetsClick(Sender: TObject);
begin
  ShowChildForm(TIBChildForm(StreetsForm), TStreetsForm);
end;

procedure TKisMainView.itmBFirmTypesClick(Sender: TObject);
begin
  ShowChildForm(TIBChildForm(BFirmTypesForm),TBFirmTypesForm);
end;

procedure TKisMainView.itmBuildingObjectTypesClick(Sender: TObject);
begin
  ShowChildForm(TIBChildForm(BObjectTypesForm),TBObjectTypesForm);
end;

procedure TKisMainView.itmAccountsClick(Sender: TObject);
begin
  ShowChildForm(TIBChildForm(AccountsForm), TAccountsForm);
end;

procedure TKisMainView.itmSoglasClick(Sender: TObject);
begin
  ShowChildForm(TIBChildForm(SoglassForm),TSoglassForm);
end;

procedure TKisMainView.itmExportClick(Sender: TObject);
begin
  ExportToText.ExportAllotmentsToFile;
end;

procedure TKisMainView.N8Click(Sender: TObject);
begin
  AppModule.Config;
end;

procedure TKisMainView.FillLettersMenu;
var
  qOrgs, qDocTypes: TIBQuery;
  ItmAll, Itm, SubItm, Separator: TMenuItem;
  I: Integer;
  NeedCommit: Boolean;
begin
  itmLetters.Clear;
  if not AppModule.Database.Connected then Exit;
  NeedCommit := not Transaction.Active;
  if not Transaction.Active then
    Transaction.StartTransaction;
  // Заполняем организации
  qOrgs := TIBQuery.Create(nil);
  qOrgs.Forget;
  qDocTypes := TIBQuery.Create(nil);
  qDocTypes.Forget;
  try
    with qOrgs do
    begin
      Transaction := Self.Transaction;
      SQL.Text := SQ_SELECT_ORGS;
      Open;
    end;
    qDocTypes.Transaction := Self.Transaction;
    while not qOrgs.Eof do
    begin
      I := qOrgs.FieldByName(SF_ID).AsInteger;
      Itm := AddMenuItem(itmLetters, I, qOrgs.Fields[1].AsString, 'itmLetterByOrg');
      ItmAll := AddMenuItem(Itm, I * N_TEN, 'Все документы', 'itmLettersByDocType');
      ItmAll.OnClick := itmLetterClick;
      ItmAll.GroupIndex := I;
      ItmAll.RadioItem := True;
      Separator := TMenuItem.Create(Self);
      Separator.Caption := '-';
      Itm.Add(Separator);
      qDocTypes.SQL.Text := Format(SQ_SELECT_DOC_TYPES, [I]);
      qDocTypes.Open;
      if qDocTypes.RecordCount = 0 then
        Itm.Free
      else
      begin
        while not qDocTypes.Eof do
        begin
          SubItm := AddMenuItem(Itm, qDocTypes.Fields[0].AsInteger + I * N_TEN,
            qDocTypes.Fields[1].AsString, 'itmLettersByDocType');
          SubItm.OnClick := itmLetterClick;
          SubItm.GroupIndex := I;
          SubItm.RadioItem := True;
          qDocTypes.Next;
        end;
        qDocTypes.Close;
      end;
      qOrgs.Next;
    end;
    qOrgs.Close;
  finally
    if NeedCommit then
      Transaction.Commit;
  end;
end;

function TKisMainView.AddMenuItem(ParentItem: TMenuItem;
  Tag: Integer; const Caption, Name: String): TMenuItem;
begin
  Inc(FMenuCounter);
  Result := TMenuItem.Create(Self);
  Result.Name := Name + IntToStr(Tag) + '_' + IntToStr(FMenuCounter);
  Result.Tag := Tag;
  Result.Caption := Caption;
  ParentItem.Add(Result);
end;

procedure TKisMainView.N6Click(Sender: TObject);
begin
  AppModule.SQLMngrs[kmBanks].ShowEntities;
end;

procedure TKisMainView.miLoad1CClick(Sender: TObject);
var
  ErrorLogForm: TOrderImport1CForm;
  OrderMngr: TKisOrderMngr;
  Trans: TIBTransaction;
  DoCommit: Boolean;
begin
  if not AppModule.User.IsAdministrator then
    ShowMessage('У вас нет доступа к данной операции!')
  else
  begin
    OrderMngr := AppModule[kmOrders] as TKisOrderMngr;
    Trans := OrderMngr.DefaultTransaction;
    OrderMngr.DefaultTransaction := Self.Transaction;
    DoCommit := not Self.Transaction.Active;
    if DoCommit then
      Self.Transaction.StartTransaction;
    ErrorLogForm := TOrderImport1CForm.Create(Application);
    try
      ErrorLogForm.ShowModal;
    finally
      if DoCommit then
        if Self.Transaction.Active then
          Self.Transaction.Rollback;
      FreeAndNil(ErrorLogForm);
      OrderMngr.DefaultTransaction := Trans;
    end;
  end;
end;

procedure TKisMainView.N11Click(Sender: TObject);
begin
  AppModule.SQLMngrs[kmContragents].ShowEntities;
end;

procedure TKisMainView.FormClose(Sender: TObject; var Action: TCloseAction);
var
  I: Integer;
begin
  AppModule.WriteFormPosition(Self, Self);
  for I := 0 to Pred(Screen.FormCount) do
  if Screen.Forms[I] <> Self then
    Screen.Forms[I].Close;
  //
  AppModule.ClearTempFiles;
end;

procedure TKisMainView.UpdateData;
begin
  itmConfig.Enabled := AppModule.User.IsAdministrator;
  miINNCheck.Enabled := itmConfig.Enabled;
  itmExport.Visible := (AppModule.User.UserName = S_ADMIN1) or (AppModule.User.UserName = S_ADMIN2);
  FillLettersMenu;
  uCommonUtils.SetLayout(loRus);
end;

procedure TKisMainView.FormCreate(Sender: TObject);
begin
  Transaction.DefaultDatabase := AppModule.Database;
  itmLetters.OnClick := nil;
  {$IFDEF LOCAL_MODE}
  FMode := 1;
  {$ELSE}
  FMode := 0;
  {$ENDIF}
  UpdateByMode;
  //
  AppModule.ReadFormPosition(Self, Self);
  //
  AppModule.OnAlert := ShowAlertMessage;
end;

procedure TKisMainView.UpdateByMode;
var
  B: Boolean;
begin
  if FMode = 0 then
  begin
    {$IFDEF INCOMING_LETTERS}
    B := True;
    {$ELSE}
    B := False;
    {$ENDIF}
    itmLetters.Visible := itmLetters.Visible and B;
    {$IFDEF OUTCOMING_LETTERS}
    B := True;
    {$ELSE}
    B := False;
    {$ENDIF}
    miOutcomingLetters.Visible := miOutcomingLetters.Visible and B;
    {$IFDEF OFFICE_DOCS}
    B := True;
    {$ELSE}
    B := False;
    {$ENDIF}
    itmOfficesDocs.Visible := itmOfficesDocs.Visible and B;
    {$IFDEF GUIDE}
    B := True;
    {$ELSE}
    B := False;
    {$ENDIF}
    GuideMenu.Visible := GuideMenu.Visible and B;
    {$IFDEF ORDERS}
    B := True;
    {$ELSE}
    B := False;
    {$ENDIF}
    itmAccounts.Visible := itmAccounts.Visible and B;
    {$IFDEF SOGLAS}
    B := True;
    {$ELSE}
    B := False;
    {$ENDIF}
    itmSoglas.Visible := itmSoglas.Visible and B;
    {$IFDEF DECREES}
    B := True;
    {$ELSE}
    B := False;
    {$ENDIF}
    miDecrees.Visible := miDecrees.Visible and B;
    {$IFDEF ARCHIVE}
    B := True;
    {$ELSE}
    B := False;
    {$ENDIF}
    miArchivalDocs.Visible := miArchivalDocs.Visible and B;
    {$IFDEF KIOSKS}
    B := True;
    {$ELSE}
    B := False;
    {$ENDIF}
    miKiosks.Visible := miKiosks.Visible and B;
    {$IFDEF MAP_500}
    B := True;
    {$ELSE}
    B := False;
    {$ENDIF}
    miMaps500.Visible := miMaps500.Visible and B;
    {$IFDEF MAP_TRACINGS}
    B := True;
    {$ELSE}
    B := False;
    {$ENDIF}
    miMapTracings.Visible := miMapTracings.Visible and B;
    {$IFDEF SCAN_ORDERS}
    B := True;
    {$ELSE}
    B := False;
    {$ENDIF}
    miScanOrders.Visible := miScanOrders.Visible and B;
    {$IFDEF SCANS}
    B := True;
    {$ELSE}
    B := False;
    {$ENDIF}
    miScans.Visible := miScans.Visible and B;
    {$IFDEF SCANS_VIEW}
    B := True;
    {$ELSE}
    B := False;
    {$ENDIF}
    miScansView.Visible := miScansView.Visible and B;
    {$IFDEF GIS}
    B := True;
    {$ELSE}
    B := False;
    {$ENDIF}
    miMap.Visible := miMap.Visible and B;
    {$IFDEF LOAD_KIOSKS}
    B := True;
    {$ELSE}
    B := False;
    {$ENDIF}
    miLoadKiosks.Visible := miLoadKiosks.Visible and B;
    {$IFDEF LOAD_1C}
    B := True;
    {$ELSE}
    B := False;
    {$ENDIF}
    miLoad1C.Visible := miLoad1C.Visible and B;
    {$IFDEF GEODESY}
    B := True;
    {$ELSE}
    B := False;
    {$ENDIF}
    itmAllotments.Visible := itmAllotments.Visible and B;
  end
  else
  begin
    itmLetters.Visible := False;
    miOutcomingLetters.Visible := False;
    itmOfficesDocs.Visible := False;
    GuideMenu.Visible := False;
    itmAddresses.Visible := False;
    itmStreets.Visible := False;
    itmOffices.Visible := False;
    itmPeople.Visible := False;
    N12.Visible := False;
    N6.Visible := False;
    N11.Visible := False;
    itmFirms.Visible := False;
    N14.Visible := False;
    N3.Visible := False;
    itmAddressWorks.Visible := False;
    N17.Visible := False;
    itmSignatures.Visible := False;
    itmVillages.Visible := False;
    itmRegions.Visible := False;
    itmDocTypes.Visible := False;
    itmPPDTypes.Visible := False;
    itmDecreeTypes.Visible := False;
    itmPropForm.Visible := False;
    itmAccounts.Visible := False;
    itmSoglas.Visible := False;
    miDecrees.Visible := False;
    N15.Visible := False;
    itmDecrees.Visible := False;
    miArchivalDocs.Visible := False;
    miKiosks.Visible := False;
    miMaps500.Visible := False;
    miMapTracings.Visible := False;
  end;
end;

procedure TKisMainView.UpdateCntrls;
var
  I: Integer;
begin
  for I := 0 to Pred(ControlCount) do
  begin
    if (Controls[i] <> TControl(itmHelp)) or (Controls[i] <> TControl(AboutItem)) then
    Controls[i].Enabled := false;
  end;
end;

procedure TKisMainView.miOutcomingLettersClick(Sender: TObject);
var
  Filter: IKisFilter;
begin
  Filter := TFilterFactory.CreateFilter(SF_ORGS_ID, AppModule.User.OrgId);
  AppModule.SQLMngrs[kmOutcomingLetters].ShowEntities(TFilterFactory.CreateList(Filter));
end;

procedure TKisMainView.N4Click(Sender: TObject);
begin
  AppModule.SQLMngrs[kmGeoPunkts].ShowEntities;
end;

procedure TKisMainView.miINNCheckClick(Sender: TObject);
var
  S: String;
begin
  with TIBQuery.Create(nil) do
  begin
    Forget;
    BufferChunks := 10;
    Transaction := Self.Transaction;
    SQL.Text := 'SELECT C.ID, C.INN FROM CONTRAGENTS_ACTUAL CA, CONTRAGENTS C WHERE CA.CONTRAGENTS_ID=C.ID AND C.INN <> '''' ORDER BY 1';
    Open;
    FetchAll;
    with TKisCheckForm.Create(Self) do
    begin
      Caption := 'Проверка ИНН';
      mResult.Clear;
      ProgressBar.Min := 0;
      ProgressBar.Max := RecordCount;
//      Show;
//      Enabled := False;
      while not Eof do
      begin
        S := FieldByName(SF_ID).AsString + #9 + FieldByName(SF_INN).AsString;
        if CheckINN(FieldByName(SF_INN).AsString) then
          S := S + #9 + 'OK!'
        else
          S := S + #9 + 'Error!';
        mResult.Lines.Add(S);
        ProgressBar.Position := RecNo;
        ProgressBar.Update;
        MoveBy(1);
      end;
      ProgressBar.Position := 0;

//      Enabled := True;
//      Release;
    end;
  end;
end;

procedure TKisMainView.miMapClick(Sender: TObject);
begin
  {$IFDEF MAP}
  ShowMap;
  {$ENDIF}
end;

procedure TKisMainView.N15Click(Sender: TObject);
var
  Filter: IKisFilter;
begin
  if AppModule.User.IsAdministrator or (AppModule.User.UserName = 'IGNATIEVA')
     or (AppModule.User.UserName = 'LOBZOVAIR')
     or (AppModule.User.RoleID = ID_ROLE_DECREE_CONTROL)
  then
    Filter := nil
  else
    Filter := TFilterFactory.CreateFilter(SF_OFFICES_ID, AppModule.User.OfficeID);
  AppModule.SQLMngrs[kmDecreeProjects].ShowEntities(TFilterFactory.CreateList(Filter));
end;

procedure TKisMainView.N17Click(Sender: TObject);
begin
  AppModule.SQLMngrs[kmLicensedOrgs].ShowEntities;
end;

procedure TKisMainView.miArchivalDocsClick(Sender: TObject);
begin
  AppModule.SQLMngrs[kmArchivalDocs].ShowEntities;
end;

procedure TKisMainView.miMaps500Click(Sender: TObject);
begin
  AppModule.SQLMngrs[kmMapCases500].ShowEntities;
end;

procedure TKisMainView.miMapTracingsClick(Sender: TObject);
begin
  AppModule.SQLMngrs[kmMapTracings].ShowEntities;
end;

procedure TKisMainView.miScansClick(Sender: TObject);
begin
  AppModule.SQLMngrs[kmMapScans].ShowEntities;
end;

procedure TKisMainView.miScanOrdersClick(Sender: TObject);
begin
  AppModule.SQLMngrs[kmScanOrders].ShowEntities;
end;

procedure TKisMainView.miScansViewClick(Sender: TObject);
begin
  AppModule.SQLMngrs[kmMapScanViewGiveOuts].ShowEntities;
end;

end.
