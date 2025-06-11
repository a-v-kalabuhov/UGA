unit uMStModuleMPImportExcel;

interface

uses
  SysUtils, Classes, Controls, Forms,
  uMStClassesMPIntf, uMStClassesProjectsMP;

type
  TmstMPImportExcelModule = class(TDataModule, ImstMPExcelImport)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FImported: TList;
    FDlg: TForm;
  private
    function DoImport(MP: ImstMPModule): Boolean;
    function GetMPObjectCount: Integer;
    function GetMPObjects(Index: Integer): TmstMPObject;
    function GetProject(const aObjState: TmstMPObjectState): TmstProjectMP;
  end;

implementation

uses
  uMStDialogImportMPfromExcel;

{$R *.dfm}

{ TmstMPImportExcelModule }

procedure TmstMPImportExcelModule.DataModuleCreate(Sender: TObject);
begin
  FImported := TList.Create;
  FDlg := nil;
end;

procedure TmstMPImportExcelModule.DataModuleDestroy(Sender: TObject);
begin
  FImported.Free;
end;

function TmstMPImportExcelModule.DoImport(MP: ImstMPModule): Boolean;
var
  Dlg: TmstMPExcelDialogForm;
  I: Integer;
begin
  if FDlg = nil then
  begin
    Dlg := TmstMPExcelDialogForm.Create(Self);
    FDlg := Dlg;
  end
  else
    Dlg := TmstMPExcelDialogForm(FDlg);
  //
  Result := Dlg.Execute(MP, Self);
  if Result then
  begin
    FImported.Clear;
    for I := 0 to Dlg.MPObjectCount - 1 do
      FImported.Add(Dlg.MPObjects[I]);
  end;
end;

function TmstMPImportExcelModule.GetMPObjectCount: Integer;
begin
  Result := FImported.Count;
end;

function TmstMPImportExcelModule.GetMPObjects(Index: Integer): TmstMPObject;
begin
  Result := FImported[Index];
end;

function TmstMPImportExcelModule.GetProject(const aObjState: TmstMPObjectState): TmstProjectMP;
var
  I: Integer;
  MpObj: TmstMPObject;
  PrjObj: TmstMPObject;
begin
  Result := TmstProjectMP.Create;
  for I := 0 to GetMPObjectCount - 1 do
  begin
    MpObj := GetMPObjects(I);
    PrjObj := Result.Objects.Add();
    PrjObj.Assign(MpObj);
    case aObjState of
      mstProjected:
        PrjObj.Projected := True;
      mstDrawn: 
        PrjObj.Drawn := True;
      mstArchived:
        PrjObj.Archived := True;
    end;
  end;
end;

end.
