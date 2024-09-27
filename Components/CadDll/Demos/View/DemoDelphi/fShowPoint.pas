unit fShowPoint;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sgConsts;

type
  TfrmShowPoint = class(TForm)
    Label8: TLabel;
    edtX: TEdit;
    Label9: TLabel;
    edtY: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    Label11: TLabel;
    edtScale: TEdit;
    chkShowMarker: TCheckBox;
    GroupBox1: TGroupBox;
    Label10: TLabel;
    Label12: TLabel;
    lblLeft: TLabel;
    lblTop: TLabel;
    Label1: TLabel;
    lblZ1: TLabel;
    Label4: TLabel;
    lblBottom: TLabel;
    Label3: TLabel;
    lblRight: TLabel;
    Label5: TLabel;
    lblZ2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmShowPoint: TfrmShowPoint;
  function GetPointParams(CADRect: TFRect; var AScale: Double;
    var CADPoint: TFPoint; var ShowMarker: Boolean): Integer;

implementation

{$R *.dfm}

{ TfrmShowPoint }

function GetPointParams(CADRect: TFRect; var AScale: Double;
  var CADPoint: TFPoint; var ShowMarker: Boolean): Integer;
begin
  Result := 0;
  frmShowPoint := TfrmShowPoint.Create(Application);
  try
    frmShowPoint.lblTop.Caption := FloatToStr(CADRect.Top);
    frmShowPoint.lblLeft.Caption := FloatToStr(CADRect.Left);
    frmShowPoint.lblBottom.Caption := FloatToStr(CADRect.Bottom);
    frmShowPoint.lblRight.Caption := FloatToStr(CADRect.Right);
    frmShowPoint.lblZ1.Caption := FloatToStr(CADRect.Z1);
    frmShowPoint.lblZ2.Caption := FloatToStr(CADRect.Z2);
    frmShowPoint.edtScale.Text := FloatToStr(AScale);
    frmShowPoint.chkShowMarker.Checked := ShowMarker;
    if frmShowPoint.ShowModal = mrOK then
    begin

      AScale := StrToFloatDef(frmShowPoint.edtScale.Text, 100.0);
      CADPoint.X := StrToFloatDef(frmShowPoint.edtX.Text, 100.0);
      CADPoint.Y := StrToFloatDef(frmShowPoint.edtY.Text, 100.0);
      ShowMarker := frmShowPoint.chkShowMarker.Checked;

      Result := 1;
    end;
  finally
    frmShowPoint.Free;
  end;
end;

end.
