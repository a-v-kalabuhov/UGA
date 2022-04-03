unit uKisMapTracingGivingEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uKisEntityEditor, StdCtrls, ComCtrls;

type
  TKisMapTracingGivingEditor = class(TKisEntityEditor)
    gbGive: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    edGiveDate: TEdit;
    edPeriod: TEdit;
    gbBack: TGroupBox;
    Label6: TLabel;
    edBackDate: TEdit;
    lRecipient: TLabel;
    cbOffices: TComboBox;
    edOrgname: TEdit;
    btnSelectOrg: TButton;
    edContacter: TEdit;
    lPersonName: TLabel;
    cbPeople: TComboBox;
    edComment: TEdit;
    Label2: TLabel;
    udPeriod: TUpDown;
  end;

implementation

{$R *.dfm}

end.
