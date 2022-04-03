unit uMstDialogFactory;

interface

uses
  SysUtils, Forms,
  uMstImport;

type
  TmstDialogFactory = class
  public
    class function NewImportLayerDialog(): ImstImportLayerDialog; 
  end;

implementation

uses
  uMstDialogImportLayer;

{ TmstDialogFactory }

class function TmstDialogFactory.NewImportLayerDialog: ImstImportLayerDialog;
begin
  Result := TMstDialogImportLayerForm.Create(Application);
end;

end.
