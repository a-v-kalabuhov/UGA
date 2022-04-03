// JCL_DEBUG_EXPERT_INSERTJDBG ON
// JCL_DEBUG_EXPERT_GENERATEJDBG ON
program Ms3;

uses
  SysUtils,
  Forms,
  JclDebug,
  uMStKernelConsts in 'Source\uMStKernelConsts.pas',
  uMStKernelClasses in 'Source\uMStKernelClasses.pas',
  uMStKernelClassesSearch in 'Source\uMStKernelClassesSearch.pas',
  uMStKernelClassesOptions in 'Source\uMStKernelClassesOptions.pas',
  uMStKernelClassesPropertiesViewers in 'Source\uMStKernelClassesPropertiesViewers.pas',
  uMStKernelGISUtils in 'Source\uMStKernelGISUtils.pas',
  uMStModuleFTPConnection in 'Source\uMStModuleFTPConnection.pas' {MStFTPConnection: TDataModule},
  uMStModuleApp in 'Source\uMStModuleApp.pas' {MStClientAppModule: TDataModule},
  uMStModuleLotData in 'Source\uMStModuleLotData.pas' {mstLotDataModule: TDataModule},
  uMStModulePrint in 'Source\uMStModulePrint.pas' {mstPrintModule: TDataModule},
  uMStFormMain in 'Source\uMStFormMain.pas' {mstClientMainForm},
  uMStFormLotProperties in 'Source\uMStFormLotProperties.pas' {mstLotPropertiesForm},
  uMStFormSplash in 'Source\uMStFormSplash.pas' {mstSplashForm},
  uMStDialogAddress in 'Source\uMStDialogAddress.pas' {mstAddressForm},
  uMStDialogNomenclature in 'Source\uMStDialogNomenclature.pas' {mstNomenclatureForm},
  uMStDialogScale in 'Source\uMStDialogScale.pas' {mstScaleDialogForm},
  uMStDialogPoint in 'Source\uMStDialogPoint.pas' {mstPointForm},
  uMStDialogPointSize in 'Source\uMStDialogPointSize.pas' {mstDialogPointSize},
  uMStDialogLines in 'Source\uMStDialogLines.pas' {mstDialogLines},
  uMStDialogPrint in 'Source\uMStDialogPrint.pas' {mstDialogPrint},
  uMStKernelClassesSelection in 'Source\uMStKernelClassesSelection.pas',
  uMStFormMapImages in 'Source\uMStFormMapImages.pas' {mstFormMapImages},
  uMStDialogLogin in 'Source\uMStDialogLogin.pas' {RegForm},
  uMStConsts in 'Source\uMStConsts.pas',
  uMStFormMeasureResult in 'Source\uMStFormMeasureResult.pas' {frmMeasureResult},
  uMStGISEzActionsMeasure in 'Source\uMStGISEzActionsMeasure.pas',
  uMStFormRichTextEditor in 'Source\uMStFormRichTextEditor.pas' {frmEzRichTextEditor},
  uMStFormCoordTableSettingsEditor in 'Source\uMStFormCoordTableSettingsEditor.pas' {mstCoordTableSettingsEditor},
  uMStFormReportTable in 'Source\uMStFormReportTable.pas' {mstFormReportTable},
  uMStFormPrintStats in 'Source\uMStFormPrintStats.pas' {mstPrintStatsForm},
  uMStFormLoadLotProgress in 'Source\uMStFormLoadLotProgress.pas' {mstLoadLotProgressForm},
  FindDlg in 'Source\FindDlg.pas',
  uMStModuleOrders in 'Source\uMStModuleOrders.pas' {mstOrdersDataModule: TDataModule},
  uMStKernelInterfaces in 'Source\uMStKernelInterfaces.pas',
  uMStModuleStats in 'Source\uMStModuleStats.pas' {mstStatDataModule: TDataModule},
  GdipApi in 'Source\Gdip\GdipApi.pas',
  GdipClass in 'Source\Gdip\GdipClass.pas',
  GdipUtils in 'Source\Gdip\GdipUtils.pas',
  uMStClassesWatermarkDraw in 'Source\uMStClassesWatermarkDraw.pas',
  uMStModuleGlobalParameters in 'Source\uMStModuleGlobalParameters.pas' {mstParametersModule: TDataModule},
  uMStFormOrderList in 'Source\uMStFormOrderList.pas' {mstOrderListForm},
  uMStClassesOrderArraySort in 'Source\uMStClassesOrderArraySort.pas',
  uMStModuleMapMngrIBX in 'Source\uMStModuleMapMngrIBX.pas' {MStIBXMapMngr: TDataModule},
  uMStKernelIBXLotLoader in 'Source\uMStKernelIBXLotLoader.pas',
  uMStImportEzClasses in 'Source\uMStImportEzClasses.pas',
  uMStImportEzLotLoaders in 'Source\uMStImportEzLotLoaders.pas',
  uMStKernelIBX in 'Source\uMStKernelIBX.pas',
  uMStImport in 'Source\uMStImport.pas',
  uMstImportFactory in 'Source\uMstImportFactory.pas',
  uMstDialogFactory in 'Source\uMstDialogFactory.pas',
  uMstImportMidMif in 'Source\uMstImportMidMif.pas',
  uMStDialogImportLayer in 'Source\uMStDialogImportLayer.pas' {MstDialogImportLayerForm},
  uMStImportMifEntityLoaders in 'Source\uMStImportMifEntityLoaders.pas',
  uMstImportMifBase in 'Source\uMstImportMifBase.pas',
  uMStFormLayers in 'Source\uMStFormLayers.pas' {MStFormLayers},
  uMStFormImportProgress in 'Source\uMStFormImportProgress.pas' {MStImportProgressForm},
  uMStImportDbImporter in 'Source\uMStImportDbImporter.pas',
  uMStFormLayerBrowser in 'Source\uMStFormLayerBrowser.pas' {MStLayerBrowserForm},
  uMStKernelSemantic in 'Source\uMStKernelSemantic.pas',
  uMStKernelAppModule in 'Source\uMStKernelAppModule.pas',
  uMStClassesProjects in 'Source\uMStClassesProjects.pas',
  uMStClassesLots in 'Source\uMStClassesLots.pas',
  uMStKernelStack in 'Source\uMStKernelStack.pas',
  uMStKernelStackUtils in 'Source\uMStKernelStackUtils.pas',
  uMStKernelStackConsts in 'Source\uMStKernelStackConsts.pas',
  uMStModuleProjectImport in 'Source\uMStModuleProjectImport.pas' {mstProjectImportModule: TDataModule},
  uMStDialogDxfImport in 'Source\uMStDialogDxfImport.pas' {MStDxfImportDialog},
  uMStDialogMissingLayers in 'Source\uMStDialogMissingLayers.pas' {MStMissingLayersDialog},
  uMStDialogEditProject in 'Source\uMStDialogEditProject.pas' {mstEditProjectDialog},
  uMStDialogSelectOrg in 'Source\uMStDialogSelectOrg.pas' {mstSelectOrgDialog},
  uMStFormProjectBrowser in 'Source\uMStFormProjectBrowser.pas' {MStProjectBrowserForm},
  uMStClassesProjectsSearch in 'Source\uMStClassesProjectsSearch.pas',
  uMStProjectLoaders in 'Source\uMStProjectLoaders.pas',
  uMStDialogDxfImportOptions in 'Source\uMStDialogDxfImportOptions.pas' {Form2},
  uMStKernelTypes in 'Source\uMStKernelTypes.pas',
  uMStClassesProjectsBrowser in 'Source\uMStClassesProjectsBrowser.pas',
  uMStDialogProjectsBrowserFilter in 'Source\uMStDialogProjectsBrowserFilter.pas' {mstProjectBrowserFilterDialog},
  uMStClassesBufferZone in 'Source\uMStClassesBufferZone.pas',
  uMStDialogBufferZoneWidth in 'Source\uMStDialogBufferZoneWidth.pas' {mstZoneWidthDialog},
  uMStClassesProjectsMIFExport in 'Source\uMStClassesProjectsMIFExport.pas';

{$R *.RES}

var
  B: Boolean;
begin
  Application.Initialize;
  Application.Title := 'Планшетохранилище 3.1';
  try
    Application.CreateForm(TmstClientAppModule, mstClientAppModule);
  Application.CreateForm(TmstPrintModule, mstPrintModule);
  Application.CreateForm(TmstClientMainForm, mstClientMainForm);
  except
    on E: Exception do
    begin
      E.Message := 'Ошибка при создании форм!' + sLineBreak + E.Message;
      Application.ShowException(E);
    end;
  end;
  mstClientAppModule.CreateMapMngr();
  try
    B := mstClientAppModule.Logon() and mstClientAppModule.Init();
  except
    on E: Exception do
    begin
      B := False;
      mstClientAppModule.ApplicationEventsException(mstClientAppModule, E);
    end;
  end;
  if B then
    Application.Run;
end.
