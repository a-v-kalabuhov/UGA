unit fVectorialText;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TfrmVectorialText = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Memo1: TMemo;
    rgb1: TRadioGroup;
    rgb2: TRadioGroup;
    Label3: TLabel;
    Label4: TLabel;
    NumEd2: TEdit;
    NumEd1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    NumEd3: TEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TfrmVectorialText.FormCreate(Sender: TObject);
begin
  NumEd1.Text:= FloatToStr(0.02);
  NumEd2.Text:= FloatToStr(0.10);
{$IFDEF LANG_SPA}
  Caption:= 'Parametros de texto vectorial';
  OkBtn.Caption:= 'Aceptar';
  CancelBtn.Caption:= 'Cancelar';
  rgb1.Caption:= 'Aliniamiento horiz.';
  rgb1.Items[0]:= '&Izquierda';
  rgb1.Items[1]:= '&Centro';
  rgb1.Items[2]:= '&Derecha';
  rgb2.Caption:= 'Aliniamiento vert.';
  rgb2.Items[0]:= '&Arriba';
  rgb2.Items[1]:= '&Centro';
  rgb2.Items[2]:= '&Abajo';
  Label5.Caption:= 'Altura linea :';
  Label3.Caption:= 'Espaciado interlinea :';
  Label4.Caption:= 'Espaciado interCars. :';
  Label1.Caption:= 'X Altura';
  Label2.Caption:= 'X Altura';
{$ENDIF}
end;

end.
