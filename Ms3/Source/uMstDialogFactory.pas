unit uMstDialogFactory;

interface

uses
  SysUtils, Forms,
  uMstImport;

type
  TmstDialogFactory = class
  public
    class function NewImportLayerDialog(): ImstImportLayerDialog;
    class function NewPointsImportDialog(): ImstImportPointsDialog;
  end;

implementation

uses
  uMstDialogImportLayer,
  uMStDialogPointsImport;

{ TmstDialogFactory }

class function TmstDialogFactory.NewImportLayerDialog: ImstImportLayerDialog;
begin
  Result := TMstDialogImportLayerForm.Create(Application);
end;

class function TmstDialogFactory.NewPointsImportDialog: ImstImportPointsDialog;
begin
  Result := TMstDialogImportPointsForm.Create(Application);
end;

end.
