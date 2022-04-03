unit uKisMapModule;

interface

uses
  SysUtils, Classes, EzBaseGIS, EzCtrls;

type
  TKisMapModule = class(TDataModule)
  private
    //procedure LoadKiosks;
    procedure LoadLayers;
  public
    //procedure AddKiosk;
    //procedure DeleteKiosk;
  end;

var
  KisMapModule: TKisMapModule;

implementation

uses
  

{$R *.dfm}

{ TKisMapModule }

procedure TKisMapModule.LoadLayers;
begin

end;

end.
