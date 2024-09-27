unit uKisLicnsedOrgSROPeriodEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uKisEntityEditor, JvBaseDlg, JvDesktopAlert, StdCtrls;

type
  TKisLicensedOrgSROPeriodEditor = class(TKisEntityEditor)
    lSROName: TLabel;
    edSROName: TEdit;
    lPeriodStartDate: TLabel;
    edPeriodStartDate: TEdit;
    edPeriodEndDate: TEdit;
    lPeriodEndDate: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
