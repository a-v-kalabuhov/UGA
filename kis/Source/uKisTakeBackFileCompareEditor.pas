unit uKisTakeBackFileCompareEditor;

interface

uses
  SysUtils,
  Forms,
  uMapScanFiles,
  uKisIntf,
  uKisMapScanIntf,
  uKisTakeBackFiles,
  //
  uKisDwgTakeBackViewForm, uKisScanTakeBackImageViewForm;

type
  TKisTakeBackFileCompareEditor = class(TInterfacedObject, IKisTakeBackFileCompareEditor)
  private
    { IKisTakeBackFileCompareEditor }
    function Execute(Folders: IKisFolders; var aFile: TTakeBackFileInfo): Boolean;
  public
    destructor Destroy; override;
  end;

implementation

{ TKisTakeBackFileCompareEditor }

destructor TKisTakeBackFileCompareEditor.Destroy;
begin

  inherited;
end;

function TKisTakeBackFileCompareEditor.Execute(Folders: IKisFolders; var aFile: TTakeBackFileInfo): Boolean;
var
  Frm: TKisScanTakeBackImageViewForm;
  Frm2: TKisDwgTakeBackViewForm;
begin
  if theMapScansStorage.FileIsVector(aFile.FileName) then
  begin
    Frm2 := TKisDwgTakeBackViewForm.Create(Application);
    try
      Result := Frm2.Execute(Folders, aFile);
    finally
      FreeAndNil(Frm2);
    end;
  end
  else
  begin
    Frm := TKisScanTakeBackImageViewForm.Create(Application);
    try
      Result := Frm.Execute(Folders, aFile);
    finally
      FreeAndNil(Frm);
    end;
  end;
end;

end.
