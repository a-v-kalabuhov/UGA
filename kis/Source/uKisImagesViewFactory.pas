unit uKisImagesViewFactory;

interface

uses
  Forms,
  uKisIntf;

type
  TKisImagesViewFactory = class
  public
    class function CreateViewer: IKisImagesView;
  end;

implementation

uses
  uKisScanImagesViewForm;

{ TKisImagesViewFactory }

class function TKisImagesViewFactory.CreateViewer: IKisImagesView;
begin
  Result := TKisImagesViewEzGIS.Create();
end;

end.
