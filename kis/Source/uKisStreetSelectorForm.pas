unit uKisStreetSelectorForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, Grids, DBGrids, DB;

type
  TKisStreetSelectorForm = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    btnSelect: TBitBtn;
    btnClose: TBitBtn;
    DataSource1: TDataSource;
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
  end;

var
  KisStreetSelectorForm: TKisStreetSelectorForm;

implementation

{$R *.dfm}

procedure TKisStreetSelectorForm.FormResize(Sender: TObject);
begin
  btnSelect.Top := Panel1.ClientHeight - btnSelect.Height - 2;
  btnClose.Top := btnSelect.Top;
  btnClose.Left := Panel1.ClientWidth - btnClose.Width - 2;
  btnSelect.Left := btnClose.Left - 2 - btnSelect.Width;
  DBGrid1.Height := btnSelect.Top - 2;
end;

procedure TKisStreetSelectorForm.FormShow(Sender: TObject);
var
  I: Integer;
begin
  I := Trunc((DbGrid1.Width - 20) / 100);
  DBGrid1.Columns[0].Width := I * 90;
  DBGrid1.Columns[1].Width := I * 10;
end;

end.
