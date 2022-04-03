unit SituationPoint;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  ComCtrls, StdCtrls, Mask, DBCtrls, DB;

type
  TSituationPointForm = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    Label3: TLabel;
    edtDegree: TEdit;
    edtMinute: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    dbeLength: TDBEdit;
    dbeHeight: TDBEdit;
    dbeComment: TDBEdit;
    dbeName: TDBEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnOkClick(Sender: TObject);
  private
    _DataSet: TDataSet;
  public
    { Public declarations }
  end;

function ShowPoint(DataSet: TDataSet): Boolean;

implementation

{$R *.DFM}

uses
  Situation, ADB6,
  uKisConsts;

function ShowPoint(DataSet: TDataSet): Boolean;
var
  Corner: Double;
begin
  Corner := DataSet.FieldByName(SF_POINT_CORNER).AsFloat;
  with TSituationPointForm.Create(Application) do
  try
    _DataSet := DataSet;
    SoftEdit(DataSet);
    edtDegree.Text := IntToStr(Trunc(Corner));
    edtMinute.Text := Format('%0.1f', [Frac(Corner) * 60]);
    Result := ShowModal = mrOk;
    if Result then
      SoftPost(DataSet)
    else
      SoftCancel(DataSet);
  finally
    Release;
  end;
end;

procedure TSituationPointForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift=[]) then
    case Key of
      VK_DOWN: FindNextControl(ActiveControl,True,True,False).SetFocus;
      VK_UP: FindNextControl(ActiveControl,False,True,False).SetFocus;
    end;
end;

procedure TSituationPointForm.btnOkClick(Sender: TObject);
begin
  _DataSet.FieldByName(SF_POINT_CORNER).AsFloat :=
    StrToFloat(edtDegree.Text) + StrToFloat(edtMinute.Text) / 60;
  ModalResult := mrOk;
end;

end.
