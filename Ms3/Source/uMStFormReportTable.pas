unit uMStFormReportTable;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DBCtrls, Grids, DBGrids, DB;

type
  TmstFormReportTable = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    DataSource: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    procedure DBGrid1Exit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  mstFormReportTable: TmstFormReportTable;

implementation

{$R *.dfm}

procedure TmstFormReportTable.DBGrid1Exit(Sender: TObject);
begin
  if Assigned(DataSource.DataSet) then
    if DataSource.DataSet.State in [dsEdit, dsInsert] then
      DataSource.DataSet.Post;
end;

end.
