unit Villages;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, DBGrids, ComCtrls, ToolWin,
  IBCHILD, JvFormPlacement, Db, IBCustomDataSet, IBQuery, IBUpdateSQL, IBDatabase, IBSQL, Buttons,
  Menus, DBActns, ActnList, ImgList, Grids,
  // Jedi
  JvComponentBase,
  //
  uDBGrid, uLegend,
  // shared
  uDB,
  // kis
  uKisConsts;


type
  TVillagesForm = class(TIBChildForm)
    ToolButton1: TToolButton;
    ibqRegions: TIBQuery;
    QueryID: TIntegerField;
    QueryREGIONS_ID: TIntegerField;
    QueryNAME: TIBStringField;
    QueryREGIONS_NAME: TStringField;
    procedure btnClearRegionClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  end;

var
  VillagesForm: TVillagesForm;

implementation

{$R *.DFM}

procedure TVillagesForm.btnClearRegionClick(Sender: TObject);
begin
  Query.SoftEdit();
  Query.FieldByName(SF_REGIONS_ID).Clear;
end;

procedure TVillagesForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  VillagesForm:=nil;
end;

end.
