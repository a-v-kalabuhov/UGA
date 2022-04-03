unit fLegend;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, EzThematics;

type
  TfrmLegend = class(TForm)
    Legend1: TEzLegend;
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure CreateParams(var Params: TCreateParams); override;
  end;

implementation

{$R *.DFM}

uses
  fMain;

{ TfrmLegend }

procedure TfrmLegend.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams( Params );
  with Params do
  begin
    Style := Style or WS_OVERLAPPED;
    WndParent := fMain.Form1.Handle;
  end;
end;

procedure TfrmLegend.FormResize(Sender: TObject);
begin
  Legend1.AdjustColWidths;
end;

procedure TfrmLegend.FormClose(Sender: TObject; var Action: TCloseAction);
begin
{$IFDEF GIS_CONTROLS}
  fMain.Form1.frmLegend:= Nil;
{$ENDIF}
  Action:= cafree;
end;

end.
