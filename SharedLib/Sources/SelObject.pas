unit SelObject;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmObjectList = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    lbObjects: TListBox;
    procedure FormResize(Sender: TObject);
    procedure lbObjectsDblClick(Sender: TObject);
    procedure lbObjectsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    FObjList: TStringList;
    mX, mY: Integer;
  public
    { Public declarations }
  end;

  function ShowObjectList(pCaption: String; pObjects: TStringList): Integer;

implementation

{$R *.dfm}

var
  frmObjectList: TfrmObjectList;

function ShowObjectList(pCaption: String; pObjects: TStringList): Integer;
var
  i: Integer;
begin
  if frmObjectList = nil then frmObjectList := TfrmObjectList.Create(Application);
  with frmObjectList do
  begin
    FObjList := pObjects;
    lbObjects.Clear;
    for i := 0 to FObjList.Count - 1 do
      lbObjects.Items.Add(FObjList.Strings[i]);
    lbObjects.ItemIndex := 0;
    if ShowModal = mrOK then
      result := lbObjects.ItemIndex
    else
      result := -1;
  end;
end;

procedure TfrmObjectList.FormResize(Sender: TObject);
begin
  btnOK.Left := ClientWidth - btnOK.Width - 1;
  btnOK.Top := ClientHeight - btnOk.Height - 2;
  btnCancel.Top := btnOK.Top;
  lbObjects.Height := btnOK.Top - 4;
end;

procedure TfrmObjectList.lbObjectsDblClick(Sender: TObject);
begin
  if lbObjects.ItemAtPos(Point(mX, mY), True) >= 0 then
    ModalResult := mrOK;
end;

procedure TfrmObjectList.lbObjectsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  mX := X;
  mY := Y;
end;

end.
