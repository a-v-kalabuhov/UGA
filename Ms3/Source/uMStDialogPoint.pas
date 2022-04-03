unit uMStDialogPoint;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, EzLib;

type
  TmstPointForm = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    edtX: TEdit;
    Label2: TLabel;
    edtY: TEdit;
    CheckBox1: TCheckBox;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnOkClick(Sender: TObject);
  public
    { Public declarations }
  end;

  function ShowTargetPoint(var Point: TEzPoint; var little: Boolean): Boolean;
  function EditPoint(var Point: TEzPoint): Boolean;

implementation

{$R *.DFM}

function ShowTargetPoint(var Point: TEzPoint; var little: Boolean): Boolean;
begin
  with TmstPointForm.Create(Application) do
  try
    Caption := 'Точка перехода';
    CheckBox1.Visible := True;
    Result := (ShowModal = mrOk);
    little := CheckBox1.Checked;
    if Result then
    begin
      Point.Y := StrToFloat(edtX.Text);
      Point.X := StrToFloat(edtY.Text);
    end;
  finally
    Release;
  end;
end;

function EditPoint(var Point: TEzPoint): Boolean;
begin
  with TmstPointForm.Create(Application) do
  try
    Caption := 'Изменяем точку';
    CheckBox1.Visible := False;
    edtX.Text := FloatToStr(Point.y);
    edtY.Text := FloatToStr(Point.x);
    Result := (ShowModal = mrOk);
    if Result then
    begin
      Point.Y := StrToFloat(edtX.Text);
      Point.X := StrToFloat(edtY.Text);
    end;
  finally
    Release;
  end;
end;    

procedure TmstPointForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = []) then
    case Key of
      VK_DOWN: FindNextControl(ActiveControl, True, True, True).SetFocus;
      VK_UP: FindNextControl(ActiveControl, False, True, True).SetFocus;
    end;
end;

procedure TmstPointForm.btnOkClick(Sender: TObject);
begin
  try
    StrToFloat(edtX.Text);
    ModalResult := mrOK;
  except
    on E: EConvertError do
      begin
        MessageBox(Handle, PChar('Проверте координату Х!'), PChar('Внимание!'), MB_OK);
        edtX.SetFocus;
        exit;
      end;
  end;
  try
    StrToFloat(edtY.Text);
    ModalResult := mrOK;
  except
    on E: EConvertError do
      begin
        MessageBox(Handle, PChar('Проверте координату Y!'), PChar('Внимание!'), MB_OK);
        edtY.SetFocus;
        exit;
      end;
  end;
end;

end.
