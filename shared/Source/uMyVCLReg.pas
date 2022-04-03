unit uMyVCLReg;

interface

uses
  Classes,
  uDBGrid,
  uLegend,
  uDataSet,
//  PreviewLib_TLB,
  ATImageBox,
  KMAlert;

  procedure Register;

implementation


procedure Register;
begin
  RegisterComponents('”√¿',
    [TkaDBGrid, TkaLegend, TCustomDataSet, {TPreview, }TATImageBox, TKMAlert]);
end;

end.
