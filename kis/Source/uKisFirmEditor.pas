unit uKisFirmEditor;

interface

{$I KisFlags.pas}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, DB, Mask, DBCtrls,
  // Project
  uKisEntityEditor, Dialogs, JvBaseDlg, JvDesktopAlert;

type
  TKisFirmEditor = class(TKisEntityEditor)
    HighInstL: TLabel;
    JAddrL: TLabel;
    BankRecL: TLabel;
    HeadL: TLabel;
    TelL: TLabel;
    FullNameL: TLabel;
    ShNameL: TLabel;
    edOwnerFirm: TEdit;
    edAddress: TEdit;
    edBank: TEdit;
    edDirector: TEdit;
    edPhones: TEdit;
    edShortName: TEdit;
    edName: TEdit;
  end;

implementation

{$R *.dfm}

end.
