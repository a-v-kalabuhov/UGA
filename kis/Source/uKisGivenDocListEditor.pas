unit uKisGivenDocListEditor;

interface

{$I KisFlags.pas}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uKisEntityEditor, StdCtrls, JvBaseDlg, JvDesktopAlert;

type
  TKisArchDocMoveEditor = class(TKisEntityEditor)
    edDateOfGive: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edTerm: TEdit;
    Label3: TLabel;
    edDateOfBack: TEdit;
    Label4: TLabel;
    cbOffice: TComboBox;
    Label5: TLabel;
    cbPeople: TComboBox;
    Label6: TLabel;
    edOrderNumber: TEdit;
    edOrderAccount: TEdit;
    Label7: TLabel;
    procedure edDateKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edIntegerKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  end;


implementation

{$R *.dfm}

uses
  uKisConsts;

procedure TKisArchDocMoveEditor.edDateKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if not (Key in DateEditKeys) then
    Key := 0;
end;

procedure TKisArchDocMoveEditor.edIntegerKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if not (Key in IntegerEditKeys) then
    Key := 0;
end;

end.
