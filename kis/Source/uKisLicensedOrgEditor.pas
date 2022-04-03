unit uKisLicensedOrgEditor;

interface

{$I KisFlags.pas}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uKisEntityEditor, StdCtrls, JvBaseDlg, JvDesktopAlert;

type
  TKisLicensedOrgEditor = class(TKisEntityEditor)
    Label1: TLabel;
    edName: TEdit;
    Label2: TLabel;
    edAddress: TEdit;
    Label3: TLabel;
    edStartDate: TEdit;
    edEndDate: TEdit;
    Label4: TLabel;
    edMapperFio: TEdit;
    Label5: TLabel;
  end;

implementation

{$R *.dfm}

end.
