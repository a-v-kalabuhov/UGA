unit uMStKernelAppSettings;

interface

uses
  Classes, Forms, DBGrids;

type
  ImstAppSettings = interface
    ['{CD6043D7-C106-4B26-B579-C645B1A3A751}']
    procedure ReadFormPosition(AOwner: TComponent; Form: TForm);
    procedure WriteFormPosition(AOwner: TComponent; Form: TForm);
    procedure ReadGridProperties(AOwner: TComponent; Grid: TDBGrid);
    procedure WriteGridProperties(AOwner: TComponent; Grid: TDBGrid);
    function  ReadAppParam(AOwner, Component: TComponent;
      const PropertyName: String; DataType: Integer; UseComponentName: Boolean = False): Variant;
    procedure SaveAppParam(AOwner, Component: TComponent; const PropertyName: String;
      const Value: Variant; UseComponentName: Boolean = False);
    function SessionDir: string;
  end;

  TGetAppSettingsEvent = procedure (Sender: TObject; out AppSettings: ImstAppSettings) of object;

implementation

end.
