unit uKisSelectMainWork;

{$I KisFlags.pas}

interface

uses
  // System
  Controls, Forms, StdCtrls, Classes, Buttons;

type
  TKisConnectWorkForm = class(TForm)
    lbWorks: TListBox;
    btnCancel: TButton;
    btnOK: TBitBtn;
    procedure FormResize(Sender: TObject);
  end;

implementation

{$R *.dfm}

procedure TKisConnectWorkForm.FormResize(Sender: TObject);
begin
  lbWorks.Height := ClientHeight - btnOK.Height - 8;
  btnOK.Top := lbWorks.Height + 4;
  btnCancel.Top := btnOK.Top;
  btnCancel.Left := ClientWidth - btnCancel.Width;
  btnOK.Left := btnCancel.Left - 8 - btnOK.Width; 
end;

end.
