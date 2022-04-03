unit uMstImportFactory;

interface

uses
  uMstImport, uMstImportMidMif;

type
  TmstImportFactory = class
  public
    class function NewLayerImport(aKind: TMstImportKind): IMstImportLayer;
  end;

implementation

{ TmstImportFactory }

class function TmstImportFactory.NewLayerImport(aKind: TMstImportKind): IMstImportLayer;
begin
  case aKind of
    importMifMid: Result := TmstMidMifImport.Create();
  end;
end;

end.
