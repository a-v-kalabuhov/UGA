unit uMStDialogBufferZoneWidth;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, EzNumEd;

type
  TmstZoneWidthDialog = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    ListBox1: TListBox;
    Label2: TLabel;
    procedure ListBox1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FWidth: Double;
  public
    function Execute(var aWidth: Double): Boolean;
  end;

var
  mstZoneWidthDialog: TmstZoneWidthDialog;

implementation

{$R *.dfm}

{ TmstZoneWidthDialog }

procedure TmstZoneWidthDialog.Button1Click(Sender: TObject);
var
  S: string;
  DecDiv: string;
begin
  if DecimalSeparator = '.' then
    DecDiv := ','
  else
    DecDiv := '.';
  S := StringReplace(Trim(Edit1.Text), DecDiv, DecimalSeparator, []);
  if TryStrToFloat(S, FWidth) and (FWidth > 0) then
    ModalResult := mrOK
  else
  begin
    ShowMessage('Неверное значение ширины!');
    Edit1.SetFocus;
  end;
end;

function TmstZoneWidthDialog.Execute(var aWidth: Double): Boolean;
begin
  FWidth := aWidth;
  Edit1.Text := FloatToStr(FWidth);
  Result := ShowModal = mrOK;
  if Result then
  begin
    aWidth := FWidth;
  end;
end;

procedure TmstZoneWidthDialog.ListBox1Click(Sender: TObject);
var
  S: string;
  I: Integer;
begin
  if ListBox1.ItemIndex >= 0 then
  begin
    S := ListBox1.Items[ListBox1.ItemIndex];
    I := Pos(' - ', S);
    if I > 0 then
    begin
      S := Copy(S, I + 2, Length(S));
      SetLength(S, Length(S) - 2);
      if TryStrToInt(S, I) then
      begin
        Edit1.Text := IntToStr(I);
      end;
    end;
  end;
end;

end.
