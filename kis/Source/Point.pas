unit Point;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  StdCtrls, Mask,
  uKisAllotmentClasses;

type
  TCheckPointNamFunc = procedure (Sender: TObject; const PointName: String;
    const aPoint: TKisPoint; var Exists: Boolean) of object;
  TPointForm = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    edtX: TEdit;
    Label2: TLabel;
    edtY: TEdit;
    Label3: TLabel;
    edtName: TEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FOnCheckPointName: TCheckPointNamFunc;
    FPoint: TKisPoint;
    function CheckText(var Text: String): Boolean;
    procedure SetPoint(const Value: TKisPoint);
  public
    class function ShowPoint(aPoint: TKisPoint; Cs: TCoordSystem; CheckNameCallback: TCheckPointNamFunc): Boolean;
    property Point: TKisPoint read FPoint write SetPoint;
    property OnCheckPointName: TCheckPointNamFunc read FOnCheckPointName write FOnCheckPointName;
  end;


implementation

uses
  uKisConsts;

{$R *.DFM}

procedure TPointForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = []) then
    case Key of
      VK_DOWN: FindNextControl(ActiveControl,True,True,True).SetFocus;
      VK_UP: FindNextControl(ActiveControl,False,True,True).SetFocus;
    end;
end;

procedure TPointForm.btnOkClick(Sender: TObject);
var
  X, Y: String;
  Exists: Boolean;
begin
  X := edtX.Text;
  Y := edtY.text;
  if CheckText(x) then
  begin
    if CheckText(y) then
    begin
      edtX.Text := X;
      edtY.Text := Y;
      if Assigned(FOnCheckPointName) then
      begin
        Exists := False;
        FOnCheckPointName(Self, edtName.Text, FPoint, Exists);
        if Exists then
        begin
          MessageBox(Handle, 'Точка с таким именем уже есть в контуре!'#13#10'Измените имя точки.', 'Внимание', MB_OK + MB_ICONWARNING);
          Exit;
        end;
      end;
      ModalResult := mrOK
    end
    else
      edtY.SetFocus;
  end
  else
    edtX.SetFocus;
end;

function TPointForm.CheckText(var Text: String): Boolean;
var
  Fl: Double;
begin
  Result := False;
  Text := Trim(Text);
  if Text = '' then
  begin
    MessageBox(Handle, PChar(S_PLEASE_ENTER_COORD), PChar(S_WARN), MB_ICONWARNING);
    Exit;
  end;
  if DecimalSeparator = '.' then Text := StringReplace(Text, ',', '.', [rfReplaceAll]);
  if DecimalSeparator = ',' then Text := StringReplace(Text, '.', ',', [rfReplaceAll]);
  if not TryStrToFloat(Text, Fl) then
  begin
    MessageBox(Handle, PChar(S_CHECK_COORDS), PChar(S_WARN), MB_ICONWARNING);
    Exit;
  end;
  if Pos(DecimalSeparator, Text) > 0 then
  begin
    Result := (Length(Text) - Pos(DecimalSeparator, Text)) < 3;
    if not Result then
      MessageBox(Handle, PChar(S_ONLY_TWO_SIGNS), PChar(S_WARN), MB_ICONWARNING);
  end
  else
    Result := True;
end;

procedure TPointForm.FormShow(Sender: TObject);
begin
  edtX.SetFocus;
end;

procedure TPointForm.SetPoint(const Value: TKisPoint);
begin
  FPoint := Value;
end;

class function TPointForm.ShowPoint(aPoint: TKisPoint; Cs: TCoordSystem;
  CheckNameCallback: TCheckPointNamFunc): Boolean;
var
  X, Y: Double;
begin
  with TPointForm.Create(Application) do
  try
    OnCheckPointName := CheckNameCallback;
    if Trim(aPoint.Name) = '' then
      aPoint.Name := IntToStr(aPoint.Id);
    Point := aPoint;
    edtName.Text := Point.Name;
    if Cs = csVrn then
    begin
      X := Point.X;
      Y := Point.Y;
    end
    else
    begin
      X := Point.X36;
      Y := Point.Y36;
    end;
    edtX.Text := FormatFloat('.00', X);//FloatToStr(X);
    edtY.Text := FormatFloat('.00', Y);//FloatToStr(Y);
    Result := ShowModal = mrOk;
    if Result then
    begin
      Point.Name := edtName.Text;
      X := StrToFloat(Trim(edtX.Text));
      Y := StrToFloat(Trim(edtY.Text));
      if Cs = csVrn then
      begin
        Point.X := X;
        Point.Y := Y;
      end
      else
      begin
        Point.X36 := X;
        Point.Y36 := Y;
      end;
    end;
  finally
    Free;
  end;
end;

end.
