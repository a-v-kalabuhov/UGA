unit uKisPastePointsOptionsDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TPastePointsOptionsDialog = class(TForm)
    chbReplacePoints: TCheckBox;
    chbChangeNumbers: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
  private
    { Private declarations }
  public type
    TPastePointsOption = (ppoReplacePoints, ppoChangeNumbers);
    TPastePointsOptions = set of TPastePointsOption;
  public
    class function Execute(var Options: TPastePointsOptions): Boolean;
  end;

implementation

{$R *.dfm}

{ TPastePointsOptionsDialog }

class function TPastePointsOptionsDialog.Execute(
  var Options: TPastePointsOptions): Boolean;
begin
  with TPastePointsOptionsDialog.Create(Application) do
  try
    chbReplacePoints.Checked := ppoReplacePoints in Options;
    chbChangeNumbers.Checked := not (ppoChangeNumbers in Options);
    Result := ShowModal = mrOK;
    if Result then
    begin
      if chbReplacePoints.Checked then
        Options := Options + [ppoReplacePoints]
      else
        Options := Options - [ppoReplacePoints];
      if chbChangeNumbers.Checked then
        Options := Options - [ppoChangeNumbers]
      else
        Options := Options + [ppoChangeNumbers];
    end;
  finally
    Free;
  end;
end;

end.
