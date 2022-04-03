unit uMStKernelClassesPropertiesViewers;

interface

uses
  uMstKernelConsts, uMStKernelClasses, uMStKernelStack, uMStKernelInterfaces;

type
  TmstObjectPropertiesView = class
  public
    procedure ShowView(aObject: TmstObject); virtual; abstract;
  end;

  TmstLotPropertiesView = class(TmstObjectPropertiesView)
  public
    procedure ShowView(aObject: TmstObject); override;
  end;

implementation

uses
  uMStFormLotProperties, uMStModuleApp, uMStClassesLots;

{ TmstLotPropertiesView }

procedure TmstLotPropertiesView.ShowView(aObject: TmstObject);
var
  aLot: TmstLot;
  View: TmstLotPropertiesForm;
  Lots: ILots;
begin
  inherited;
  if (not Assigned(aObject)) or (not (aObject is TmstLot)) then
    Exit;
  aLot := TmstLot(aObject);
  View := TmstLotPropertiesForm.Create(nil);
  Lots := mstClientAppModule.GetLots(aLot);
  try
    View.Lot := aLot;
    View.dsOwners.DataSet := Lots.GetDataSet(ldsOwners);
    View.dsDocs.DataSet := Lots.GetDataSet(ldsDocs);
    View.dsLot.DataSet := Lots.GetDataSet(ldsLot);
    View.ShowModal;
  finally
    View.Free;
    Lots.CloseLots;
  end;
end;

end.
