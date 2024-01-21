// JCL_DEBUG_EXPERT_INSERTJDBG ON
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
// JCL_DEBUG_EXPERT_GENERATEJDBG ON
program Kis;

uses
  Windows,
  Forms,
  SysUtils,
  uKisSQLClasses in 'Source\uKisSQLClasses.pas' {KisSQLMngr: TDataModule},
  uKisMainView in 'Source\uKisMainView.pas' {KisMainView},
  uKisAbout in 'Source\uKisAbout.pas' {AboutForm},
  uKisAppModule in 'Source\uKisAppModule.pas' {KisAppModule: TDataModule},
  Config in 'Source\Config.pas' {ConfigForm},
  uKisPasswordDlg in 'Source\uKisPasswordDlg.pas' {RegForm},
  Decree in 'Source\Decree.pas' {DecreeForm},
  DecImprt in 'Source\DecImprt.pas' {DecreeImportForm},
  Allotment in 'Source\Allotment.pas' {AllotmentForm},
  AllotmentOwner in 'Source\AllotmentOwner.pas' {AllotmentOwnerForm},
  Contour in 'Source\Contour.pas' {ContourForm},
  Point in 'Source\Point.pas' {PointForm},
  ReNum in 'Source\ReNum.pas' {RenumForm},
  Draw in 'Source\Draw.pas',
  PrintOtvod in 'Source\PrintOtvod.pas' {OtvodPrintForm},
  CoordProp in 'Source\CoordProp.pas' {CoordPropForm},
  Regions in 'Source\Regions.pas' {RegionsForm},
  Allotments in 'Source\Allotments.pas' {AllotmentsForm},
  DecreeTypes in 'Source\DecreeTypes.pas' {DecreeTypesForm},
  Villages in 'Source\Villages.pas' {VillagesForm},
  Decrees in 'Source\Decrees.pas' {DecreesForm},
  Offices in 'Source\Offices.pas' {OfficesForm},
  People in 'Source\People.pas' {PeopleForm},
  DocTypes in 'Source\DocTypes.pas' {DocTypesForm},
  PropForms in 'Source\PropForms.pas' {PropFormsForm},
  Signatures in 'Source\Signatures.pas' {SignaturesForm},
  PPDTypes in 'Source\PPDTypes.pas' {PPDTypesForm},
  uKisNomenclatureCalc in 'Source\uKisNomenclatureCalc.pas' {KisNomenclatureCalc},
  DecReplace in 'Source\DecReplace.pas' {DecReplaceForm},
  PrintSel in 'Source\PrintSel.pas' {PrintSelForm},
  FindDlg in 'Source\FindDlg.pas' {FindForm},
  Addresses in 'Source\Addresses.pas' {AddressesForm},
  AddressWorks in 'Source\AddressWorks.pas' {AddressWorksForm},
  Streets in 'Source\Streets.pas' {StreetsForm},
  Street in 'Source\Street.pas' {StreetForm},
  Buildings in 'Source\Buildings.pas' {BuildingsForm},
  FirmName in 'Source\FirmName.pas' {FirmNameForm},
  BFirmTypes in 'Source\BFirmTypes.pas' {BFirmTypesForm},
  BObjectTypes in 'Source\BObjectTypes.pas' {BObjectTypesForm},
  Account in 'Source\Account.pas' {AccountForm},
  Office in 'Source\Office.pas' {OfficeForm},
  WorkTypes in 'Source\WorkTypes.pas' {WorkTypesForm},
  Reports in 'Source\Reports.pas' {ReportsForm},
  Report in 'Source\Report.pas' {ReportForm},
  Soglass in 'Source\Soglass.pas' {Soglass1Form},
  SoglassDoc in 'Source\SoglassDoc.pas' {SoglassDocForm},
  SoglassDocAdd in 'Source\SoglassDocAdd.pas' {SoglassDocAddForm},
  PrintSelAdd in 'Source\PrintSelAdd.pas' {PrintSelAddForm},
  ExportToText in 'Source\ExportToText.pas',
  SelectAddress in 'Source\SelectAddress.pas' {frmSelectAddress},
  uKisConsts in 'Source\uKisConsts.pas',
  IBCHILD in 'Source\IBCHILD.pas' {IBChildForm},
  uKisBanks in 'Source\uKisBanks.pas' {KisBankMngr: TDataModule},
  uKisEntityEditor in 'Source\uKisEntityEditor.pas' {KisEntityEditor},
  uKisContragents in 'Source\uKisContragents.pas' {KisContragentMngr: TDataModule},
  uKisMngrView in 'Source\uKisMngrView.pas' {KisMngrView},
  uKisContragentDocuments in 'Source\uKisContragentDocuments.pas' {KisContragentDocumentMngr: TDataModule},
  uKisContragentCertificates in 'Source\uKisContragentCertificates.pas' {KisContragentCertificateMngr: TDataModule},
  uKisContragentTypeDialog in 'Source\uKisContragentTypeDialog.pas' {KisContragentTypeDialog},
  uKisContragentEditor in 'Source\uKisContragentEditor.pas' {KisContragentEditor},
  uKisAddressEditor in 'Source\uKisAddressEditor.pas' {KisAddressEditor},
  uKisUtils in 'Source\uKisUtils.pas',
  uKisContragentPersonEditor in 'Source\uKisContragentPersonEditor.pas' {KisContragentPersonEditor},
  Address in 'Source\Address.pas' {AddressForm},
  uKisContragentOrgEditor in 'Source\uKisContragentOrgEditor.pas' {KisContragentOrgEditor},
  uKisSearchDialog in 'Source\uKisSearchDialog.pas' {KisSearchDialog},
  uKisSortDialog in 'Source\uKisSortDialog.pas' {KisSortDialog},
  uKisContragentPrivateEditor in 'Source\uKisContragentPrivateEditor.pas' {KisContragentPrivateEditor},
  uKisOrders in 'Source\uKisOrders.pas' {KisOrderMngr: TDataModule},
  uKisOrderEditor in 'Source\uKisOrderEditor.pas' {KisOrderEditor},
  uKisLetters in 'Source\uKisLetters.pas' {KisLetterMngr: TDataModule},
  uKisLetterEditor in 'Source\uKisLetterEditor.pas' {KisLetterEditor},
  uKisOffices in 'Source\uKisOffices.pas' {KisOfficeMngr: TDataModule},
  uKisOrgs in 'Source\uKisOrgs.pas' {KisOrgMngr: TDataModule},
  uKisClasses in 'Source\uKisClasses.pas' {KisMngr: TDataModule},
  uKisPeople in 'Source\uKisPeople.pas' {KisPeopleMngr: TDataModule},
  uKisDocTypes in 'Source\uKisDocTypes.pas' {KisDocTypeMngr: TDataModule},
  uKisFirms in 'Source\uKisFirms.pas' {KisFirmMngr: TDataModule},
  uKisFirmEditor in 'Source\uKisFirmEditor.pas' {KisFirmEditor},
  uKisLetterVisaEditor in 'Source\uKisLetterVisaEditor.pas' {KisLetterVisaEditor},
  uKisLetterPassingEditor in 'Source\uKisLetterPassingEditor.pas' {KisLetterPassingEditor},
  uKisLettersView in 'Source\uKisLettersView.pas' {KisLettersView},
  uKisOfficeDocs in 'Source\uKisOfficeDocs.pas' {KisOfficeDocMngr: TDataModule},
  uKisOfficeDocEditor in 'Source\uKisOfficeDocEditor.pas' {KisOfficeDocEditor},
  AllotmentPrintEdit in 'Source\AllotmentPrintEdit.pas' {AddEditForm},
  uKisFactory in 'Source\uKisFactory.pas',
  uKisOutcomingLetters in 'Source\uKisOutcomingLetters.pas' {kisOutcomingLetterMngr: TDataModule},
  uKisStreets in 'Source\uKisStreets.pas' {KisStreetMngr: TDataModule},
  uKisOutcomingLetterEditor in 'Source\uKisOutcomingLetterEditor.pas' {KisOutcomingLetterEditor},
  uKisContragentsComparison in 'Source\uKisContragentsComparison.pas' {FmContragentsComparison},
  AllotmentReportLibrary in 'Source\AllotmentReportLibrary.pas',
  Accounts in 'Source\Accounts.pas' {AccountsForm},
  uKisGeoPunktsEditor in 'Source\uKisGeoPunktsEditor.pas' {KisGeoPunktsEditor},
  uKisGeoPunkts in 'Source\uKisGeoPunkts.pas' {KisGeoPunktsMngr: TDataModule},
  uKisINNCheck in 'Source\uKisINNCheck.pas' {KisCheckForm},
  uKisDecreeProjects in 'Source\uKisDecreeProjects.pas' {KisDecreeProjectMngr: TDataModule},
  uKisDecreeProjectEditor in 'Source\uKisDecreeProjectEditor.pas' {KisDecreeProjectEditor},
  uKisLicensedOrgs in 'Source\uKisLicensedOrgs.pas' {KisLicensedOrgMngr: TDataModule},
  uKisLicensedOrgEditor in 'Source\uKisLicensedOrgEditor.pas' {KisLicensedOrgEditor},
  uKisPrintModule in 'Source\uKisPrintModule.pas' {KisPrintModule: TDataModule},
  uKisArchivalDocsMngr in 'Source\uKisArchivalDocsMngr.pas' {KisArchivalDocsMngr: TDataModule},
  uKisArchivalDocsEditor in 'Source\uKisArchivalDocsEditor.pas' {KisArchivalDocsEditor},
  uKisGivenDocListEditor in 'Source\uKisGivenDocListEditor.pas' {KisArchDocMoveEditor},
  uKisContragentAddresses in 'Source\uKisContragentAddresses.pas' {KisContragentAddressMngr: TDataModule},
  uKisIntf in 'Source\uKisIntf.pas',
  uKisSelectMainWork in 'Source\uKisSelectMainWork.pas' {KisConnectWorkForm},
  uKisStreetSelectorForm in 'Source\uKisStreetSelectorForm.pas' {KisStreetSelectorForm},
  uKisMap500Graphics in 'Source\uKisMap500Graphics.pas' {KisMap500Graphics},
  uKisScanningListEditor in 'Source\uKisScanningListEditor.pas' {KisScanningListEditor},
  uKisAccounts in 'Source\uKisAccounts.pas' {KisAccountsMngr: TDataModule},
  uKisBankAccountsForm in 'Source\uKisBankAccountsForm.pas' {KisBankAccountsForm},
  uKisAccontForm in 'Source\uKisAccontForm.pas' {KisAccountForm},
  uKisMapTracings in 'Source\uKisMapTracings.pas' {KisMapTracingMngr: TDataModule},
  uKisExceptions in 'Source\uKisExceptions.pas',
  uKisMapsMngrView in 'Source\uKisMapsMngrView.pas' {KisMapsMngrView},
  uKisDecrees in 'Source\uKisDecrees.pas' {KisDecreeMngr: TDataModule},
  uKisDecreeProjectsView in 'Source\uKisDecreeProjectsView.pas' {KisDecreeProjectsView},
  uKisDecreeHeaderForm in 'Source\uKisDecreeHeaderForm.pas' {KisDecreeHeaderForm},
  AFile6 in 'Libs\AFile6.pas',
  ADBActns6 in 'Libs\ADBActns6.pas',
  AConnect6 in 'Libs\AConnect6.pas' {ConnectForm},
  AGraph6 in 'Libs\AGraph6.pas',
  AGrids6 in 'Libs\AGrids6.pas',
  APrinter6 in 'Libs\APrinter6.pas',
  AProc6 in 'Libs\AProc6.pas',
  AString6 in 'Libs\AString6.pas',
  ComUtil in 'Libs\ComUtil.pas',
  Geodesy in 'Libs\Geodesy.pas',
  GeoObjects in 'Libs\GeoObjects.pas',
  GrphUtil in 'Libs\GrphUtil.pas',
  ImageBox in 'Libs\ImageBox.pas',
  KavUtils in 'Libs\KavUtils.pas',
  Sort6 in 'Libs\Sort6.pas' {SortForm},
  StrUtil in 'Libs\StrUtil.pas',
  uKisMapTracingEditor in 'Source\uKisMapTracingEditor.pas' {KisMapTracingEditor},
  uKisMapTracingGivingEditor in 'Source\uKisMapTracingGivingEditor.pas' {KisMapTracingGivingEditor},
  uKisMapClasses in 'Source\uKisMapClasses.pas',
  uKisProgressForm in 'Source\uKisProgressForm.pas' {KisProgressForm},
  uKisNomenclatureDlg in 'Source\uKisNomenclatureDlg.pas' {KisNomenclatureDlg},
  uKisAllotmentClasses in 'Source\uKisAllotmentClasses.pas',
  uMfClasses in 'Source\uMfClasses.pas',
  uKisOrdersImport1CView in 'Source\uKisOrdersImport1CView.pas' {OrderImport1CForm},
  uKisOfficeDocsView in 'Source\uKisOfficeDocsView.pas' {KisOfficeDocsView},
  uKisSearchClasses in 'Source\uKisSearchClasses.pas',
  uKisPastePointsOptionsDialog in 'Source\uKisPastePointsOptionsDialog.pas' {PastePointsOptionsDialog},
  uKisFilters in 'Source\uKisFilters.pas',
  uKisMap500 in 'Source\uKisMap500.pas' {KisMap500Mngr: TDataModule},
  uKisGivenMapListEditor in 'Source\uKisGivenMapListEditor.pas',
  uKisMap500Editor in 'Source\uKisMap500Editor.pas' {KisMap500Editor},
  uKisMapScans in 'Source\uKisMapScans.pas' {KisMapScansMngr: TDataModule},
  uKisFileReport in 'Source\uKisFileReport.pas',
  uKisFileReportForm in 'Source\uKisFileReportForm.pas' {KisFileReportForm},
  uKisMapScansView in 'Source\uKisMapScansView.pas' {KisMapScansView},
  uKisScanOrders in 'Source\uKisScanOrders.pas' {KisScanOrdersMngr: TDataModule},
  uKisMissingScansDlg in 'Source\uKisMissingScansDlg.pas' {MissingScansForm},
  uKisScanOrderEditor in 'Source\uKisScanOrderEditor.pas' {KisScanOrderEditor},
  uKisMapScanViewGiveOuts in 'Source\uKisMapScanViewGiveOuts.pas' {KisMapScanViewGiveOutMngr: TDataModule},
  uKisGivenScanEditor2 in 'Source\uKisGivenScanEditor2.pas' {KisGivenScanEditor2},
  uKisMapHistoryClasses in 'Source\uKisMapHistoryClasses.pas',
  uKisMapScanLoadForm2 in 'Source\uKisMapScanLoadForm2.pas' {KisMapScanLoadForm2},
  uKisTakeBackFiles in 'Source\uKisTakeBackFiles.pas',
  uMapScanFiles in 'Source\uMapScanFiles.pas',
  uKisComparedImageForm in 'Source\uKisComparedImageForm.pas' {KisComparedImageForm},
  uKisImageViewer in 'Source\uKisImageViewer.pas',
  uImageHistogram in 'Source\uImageHistogram.pas',
  uKisComparedImageListForm in 'Source\uKisComparedImageListForm.pas' {KisComparedImageListForm},
  uKisMapHistoryEditor in 'Source\uKisMapHistoryEditor.pas' {KisMapHistoryEditor},
  uKisScanOrdersView in 'Source\uKisScanOrdersView.pas' {KisScanOrdersView},
  uKisProjectsJournal in 'Source\uKisProjectsJournal.pas' {KisProjectsJournalMngr: TDataModule},
  uKisScanImagesViewForm in 'Source\uKisScanImagesViewForm.pas' {KisScanImagesViewForm},
  uKisTakeBackFileProcessor in 'Source\uKisTakeBackFileProcessor.pas',
  uKisMapScanIntf in 'Source\uKisMapScanIntf.pas',
  uDrawTransparent in 'Source\uDrawTransparent.pas',
  uKisScanHistoryFiles in 'Source\uKisScanHistoryFiles.pas',
  uKisMapScanEditor in 'Source\uKisMapScanEditor.pas' {KisMapScanEditor},
  uKisImagesViewFactory in 'Source\uKisImagesViewFactory.pas',
  uKisMapPrint in 'Source\uKisMapPrint.pas',
  uKisMapPrintDialog1 in 'Source\uKisMapPrintDialog1.pas' {KisMapPrintDialogForm},
  uKisDwgTakeBackViewForm in 'Source\uKisDwgTakeBackViewForm.pas' {KisDwgTakeBackViewForm},
  uKisEzActions in 'Source\uKisEzActions.pas',
  uKisGivenScanEditor in 'Source\uKisGivenScanEditor.pas',
  uKisMapScanGeometry in 'Source\uKisMapScanGeometry.pas',
  uKisScanAreaFile in 'Source\uKisScanAreaFile.pas',
  uKisDlgSelectAreaLayer in 'Source\uKisDlgSelectAreaLayer.pas' {KisSelectAleaLayerDialog},
  uEzAutoCADImport in '..\EzShared\uEzAutoCADImport.pas' {EzAutoCADImport: TDataModule},
  uKisTakeBackFileCompareEditor in 'Source\uKisTakeBackFileCompareEditor.pas',
  uKisScanTakeBackImageViewForm in 'Source\uKisScanTakeBackImageViewForm.pas' {KisScanTakeBackImageViewForm},
  uKisLicnsedOrgSROPeriodEditor in 'Source\uKisLicnsedOrgSROPeriodEditor.pas' {KisLicensedOrgSROPeriodEditor};

{$R *.RES}
{$SetPEFlags IMAGE_FILE_LARGE_ADDRESS_AWARE}
{$I KisFlags.pas}

var
  S, DbName: String;
begin
  Application.Initialize;
  Application.Title := 'Информационная система';
  Application.CreateForm(TKisAppModule, KisAppModule);
  Application.CreateForm(TKisMainView, KisMainView);
  //
  DbName := KisAppModule.ReadAppParam(S_CONNECTION_SECTION, PARAM_DBNAME, varString);
  if DbName = '' then
    Windows.MessageBox(0, 'Не указаны настройки подключения в базе данных в файле Kis.ini!'
      + #13#10 + 'Обратитесь к администратору!', 'Ошибка', MB_ICONSTOP + MB_OK)
  else
  with KisAppModule do
    {$IFDEF USER}
    if Logon(DbName) then
    {$ENDIF}
    begin
      {$IFNDEF USER}
        {$IFNDEF LOCALDATA}
        AppModule.Database.DatabaseName := 'srv-bd1:ugatest';
        {$ELSE}
        //AppModule.Database.DatabaseName := 'localhost:d:\data\kis\kis.fdb';
        //AppModule.Database.DatabaseName := 'localhost:' + ExtractFilePath(Application.ExeName) + 'data\uga.gdb';
        AppModule.Database.DatabaseName := ExtractFilePath(Application.ExeName) + 'data\db_local_new.fdb';
        {$ENDIF}
//        AppModule.Connect(165, 'KALABUHOVAL', 'ADMINISTRATOR', 'kas16t30s04');
        AppModule.Connect(134, 'SYSDBA', 'ADMINISTRATOR', 'masterkey');
      {$ENDIF}
      KisMainView.StatusBar.Panels[0].Text := 'Cеанс ИС: ' + KisAppModule.User.ShortName;
      KisMainView.StatusBar.Panels[1].Text := 'Cеанс Windows: ' + CurrentWindowsUserName;
      KisMainView.StatusBar.Panels[2].Text := KisAppModule.ReadAppParam(S_CONNECTION_SECTION, PARAM_DBNAME, varString);
      KisMainView.StatusBar.Panels[3].Text := KisAppModule.User.OfficeName;
  //    TKisMapTracingMngr(AppModule[kmMapTracings]).UpdateIntNumbers;
      Application.Run;
    end;
{  else
    if ReadAppParam(S_CONNECTION_SECTION, PARAM_DBNAME, varString) = '' then
     Application.MessageBox(PChar('Невозможно установить соединение с базой данных!'#13'Возможно отсутствует INI файл.'#13'Обратитесь к администратору!'),
       PChar(S_WARN));// + MB_ICONWARNING);  }
end.

