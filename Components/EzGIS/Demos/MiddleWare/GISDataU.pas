unit GISDataU;

interface

uses
  SysUtils, Classes, EzBaseGIS, EzCtrls;

type
  TGISData = class(TDataModule)
    GIS1: TEzGIS;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
