unit uMStKernelTypes;

interface

type
  TChangedEvent = procedure (Sender: TObject; Value: Boolean) of object;
  TProgressEvent2 = procedure (Sender: TObject; const Text: string; Current, Count: Integer) of object;

  TmstLotType = (ltActual, ltAnnuled, ltReg, ltCategorized);
  TmstPrintPermission = (ppDenied, ppWaterMark, ppFull);
  TmstMapReportErrorMode = (mreDeny = 0, mreWatermarks = 1);
  TmstImageExt = (imgGFA, imgBMP, imgJPEG);

implementation

end.
