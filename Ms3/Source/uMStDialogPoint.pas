unit uMStDialogPoint;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Clipbrd,
  EzLib,
  uStringUtils,
  uMStKernelUtils;

const
  sDefaultCheckBoxCaption = 'Мелкий масштаб';

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
  private
    FX, FY: Double;
    procedure ReadXYFromText(S: string);
  public
    class function ShowTargetPoint(var Point: TEzPoint; var SmallScale: Boolean): Boolean;
    class function EditPoint(var aGeoPoint: TEzPoint): Boolean;
    class function NewPoint(var aGeoPoint: TEzPoint): Boolean;
    class function ShowPointDlg(
      const aCaption: string;
      var X: Double; var Y: Double;
      var CheckBoxValue: Boolean;
      const EmptyPoint: Boolean = False;
      const CheckClipBoard: Boolean = True;
      const ShowCheckBox: Boolean = False;
      const CheckBoxCaption: string = sDefaultCheckBoxCaption): Boolean;
  end;

implementation

{$R *.DFM}

class function TmstPointForm.ShowPointDlg(const aCaption: string; var X: Double; var Y: Double;
  var CheckBoxValue: Boolean; const EmptyPoint, CheckClipBoard, ShowCheckBox: Boolean;
  const CheckBoxCaption: string): Boolean;
begin
  with TmstPointForm.Create(Application) do
  try
    Caption := aCaption;
    if CheckClipBoard then
    begin
      Clipboard.Open;
      try
        try
          ReadXYFromText(Clipboard.AsText);
        finally
          Clipboard.Close;
        end;
      except
        FX := 0;
        FY := 0;
      end;
    end;
    if EmptyPoint then
    begin
      edtX.Text := '';
      edtY.Text := '';
    end
    else
    begin
      edtX.Text := Format('%0.2f', [FX]);
      edtY.Text := Format('%0.2f', [FY]);
    end;
    CheckBox1.Visible := ShowCheckBox;
    CheckBox1.Checked := CheckBoxValue;
    if ShowCheckBox then
      CheckBox1.Caption := CheckBoxCaption;
    Result := ShowModal = mrOk;
    if Result then
    begin
      X := FX;
      Y := FY;
      CheckBoxValue := CheckBox1.Checked;
    end;
  finally
    Release;
  end;
end;

class function TmstPointForm.ShowTargetPoint(var Point: TEzPoint; var SmallScale: Boolean): Boolean;
begin
  Result := ShowPointDlg(
    'Точка перехода',
    Point.X,
    Point.Y,
    SmallScale,
    True,
    True,
    True
  );
//  with TmstPointForm.Create(Application) do
//  try
//    Caption := 'Точка перехода';
//    CheckBox1.Visible := True;
//    Result := (ShowModal = mrOk);
//    if Result then
//    begin
//      Point.X := FX;
//      Point.Y := FY;
//      SmallScale := CheckBox1.Checked;
//    end;
//  finally
//    Release;
//  end;
end;

class function TmstPointForm.EditPoint(var aGeoPoint: TEzPoint): Boolean;
var
  Dummy: Boolean;
begin
  Result := ShowPointDlg(
    'Изменяем точку',
    aGeoPoint.X, aGeoPoint.Y,
    Dummy,
    False,
    False
  );
//  with TmstPointForm.Create(Application) do
//  try
//    Caption := 'Изменяем точку';
//    CheckBox1.Visible := False;
//    edtX.Text := FloatToStr(Point.x);
//    edtY.Text := FloatToStr(Point.y);
//    Result := ShowModal = mrOk;
//    if Result then
//    begin
//      Point.X := FX;
//      Point.Y := FY;
//    end;
//  finally
//    Release;
//  end;
end;

procedure TmstPointForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = []) then
    case Key of
      VK_DOWN: FindNextControl(ActiveControl, True,  True, True).SetFocus;
      VK_UP:   FindNextControl(ActiveControl, False, True, True).SetFocus;
    end;
end;

class function TmstPointForm.NewPoint(var aGeoPoint: TEzPoint): Boolean;
var
  Dummy: Boolean;
begin
  Result := ShowPointDlg(
    'Добавляем точку',
    aGeoPoint.X, aGeoPoint.Y,
    Dummy,
    False,
    False,
    False
  );
end;

procedure TmstPointForm.ReadXYFromText(S: string);
var
  MSK36: Boolean;
begin
  TPointUtils.PointFromClipboard(FX, FY, MSK36);
end;

procedure TmstPointForm.btnOkClick(Sender: TObject);
begin
  if not TStringConverter.StrToFloat(edtX.Text) then
  begin
    FX := TStringConverter.FloatValue;
    MessageBox(Handle, PChar('Проверте координату Х!'), PChar('Внимание!'), MB_OK);
    edtX.SetFocus;
    Exit;
  end;
  if not TStringConverter.StrToFloat(edtY.Text) then
  begin
    FY := TStringConverter.FloatValue;
    MessageBox(Handle, PChar('Проверте координату Y!'), PChar('Внимание!'), MB_OK);
    edtY.SetFocus;
    Exit;
  end;
  ModalResult := mrOK;
end;

end.
