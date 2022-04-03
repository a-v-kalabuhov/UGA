unit CoordProp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  StdCtrls, ExtCtrls, Dialogs;

type
  TCoordPropForm = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    gbShow: TGroupBox;
    cbLatinNumber: TCheckBox;
    cbLength: TCheckBox;
    cbAzimuth: TCheckBox;
    btnFont: TButton;
    FontDialog: TFontDialog;
    cbOnPoint: TCheckBox;
    rgView: TRadioGroup;
    cbInformation: TCheckBox;
    chbNeighbours: TCheckBox;
    procedure btnFontClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ShowCoordProp(var LatinNumber,ShowLength,ShowAzimuth,ShowOnPoint,ShowInformation, ShowNeighbours: Boolean;
  CoordFont: TFont; var View: Integer): Boolean;

implementation

{$R *.DFM}

function ShowCoordProp(var LatinNumber, ShowLength, ShowAzimuth, ShowOnPoint,
                           ShowInformation, ShowNeighbours: Boolean; CoordFont: TFont;
                       var View: Integer): Boolean;
begin
  with TCoordPropForm.Create(Application) do
  try
    cbLatinNumber.Checked := LatinNumber;
    cbLength.Checked := ShowLength;
    cbAzimuth.Checked := ShowAzimuth;
    cbOnPoint.Checked := ShowOnPoint;
    cbInformation.Checked := ShowInformation;
    chbNeighbours.Checked := ShowNeighbours;
    rgView.ItemIndex := View - 1;
    FontDialog.Font.Assign(CoordFont);
    Result := (ShowModal = mrOk);
    if Result then
    begin
      LatinNumber := cbLatinNumber.Checked;
      ShowLength := cbLength.Checked;
      ShowAzimuth := cbAzimuth.Checked;
      ShowOnPoint := cbOnPoint.Checked;
      ShowInformation := cbInformation.Checked;
      ShowNeighbours := chbNeighbours.Checked;
      View := rgView.ItemIndex + 1;
      CoordFont.Assign(FontDialog.Font);
    end;
  finally
    Free;
  end;
end;

procedure TCoordPropForm.btnFontClick(Sender: TObject);
begin
  FontDialog.Execute;
end;

end.
