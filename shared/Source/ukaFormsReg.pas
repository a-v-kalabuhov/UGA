unit ukaFormsReg;

interface

uses
  Forms, uAppForm;

implementation

uses
  DesignIntf, DesignEditors;

procedure RegisterAll;
begin
  RegisterCustomModule(TkaAppForm, TCustomModule);
end;

initialization
  RegisterAll;
end.
