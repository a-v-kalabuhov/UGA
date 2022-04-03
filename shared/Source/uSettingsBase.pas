unit uSettingsBase;

interface

uses
  Classes, Controls, Forms;

type
  TkaSettings = class(TComponent)
  protected
    function GetFileName: String; virtual; abstract;
    procedure SetFileName(const Value: String); virtual; abstract;
  public
    procedure CreateNewFile(const FileName: String); virtual; abstract;
    function GetValue(const SectionName, KeyName: String): Variant; virtual; abstract;
    procedure SetValue(const SectionName, KeyName: String;
      const Value: Variant); virtual; abstract;
  published
    property FileName: String read GetFileName write SetFileName;
  end;

  TkaVCLSettings = class(TkaSettings)
  public
    procedure ReadControlProperty(Control: TControl; const PropName: String;
      const SectionName: String = ''); virtual;
    procedure WriteControlProperty(Control: TControl; const PropName: String;
      const SectionName: String = ''); virtual;
  end;

implementation

uses
  TypInfo;

procedure TkaVCLSettings.ReadControlProperty(Control: TControl; 
   const PropName: String; const SectionName: String);
var
  Section: String;
begin
  if SectionName = '' then
    Section := Control.Owner.Name
  else
    Section := SectionName;
  SetPropValue(Control, PropName, GetValue(Section, PropName));
end;

procedure TkaVCLSettings.WriteControlProperty(Control: TControl;
   const PropName: String; const SectionName: String);
var
  Section: String;
begin
  if SectionName = '' then
    Section := Control.Owner.Name
  else
    Section := SectionName;
  SetValue(Section, PropName, GetPropValue(Control, PropName));
end;

end.
