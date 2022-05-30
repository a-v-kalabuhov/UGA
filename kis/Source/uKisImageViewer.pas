unit uKisImageViewer;

interface

uses
  Forms,
  uKisIntf, uKisMapScanIntf,
  uKisTakeBackFileCompareEditor,
  uKisComparedImageForm, uKisComparedImageListForm, uKisScanTakeBackImageViewForm;

type
  TKisImageViewerFactory = class
  private
    class var fSingleForm: TKisComparedImageForm;
    class var fListForm: TKisComparedImageListForm;
  public
    // Устарело
    class function CreateImageViewer(): IKisImageViewer;
    // Устарело
    class function CreateImageCompareViewer(): IKisImageCompareViewer;
    // Актуально
    class function CreateTakeBackFileCompareEditor(): IKisTakeBackFileCompareEditor;
  end;

implementation

{ TKisImageViewerFactory }

class function TKisImageViewerFactory.CreateImageCompareViewer: IKisImageCompareViewer;
begin
  if not Assigned(fListForm) then
    fListForm := TKisComparedImageListForm.Create(Application);
  Result := fListForm as IKisImageCompareViewer;
end;

class function TKisImageViewerFactory.CreateImageViewer: IKisImageViewer;
begin
  if not Assigned(fSingleForm) then
    fSingleForm := TKisComparedImageForm.Create(Application);
  Result := fSingleForm as IKisImageViewer;
end;

class function TKisImageViewerFactory.CreateTakeBackFileCompareEditor: IKisTakeBackFileCompareEditor;
begin
  Result := TKisTakeBackFileCompareEditor.Create();
end;

end.
