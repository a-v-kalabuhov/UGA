unit uMStFormMPClassSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IBSQL, IBCustomDataSet, IBUpdateSQL, DB, IBQuery, IBDatabase, ExtCtrls, Grids, DBGrids, uDBGrid, StdCtrls,
  ActnList;

type
  TmstMPClassSettingsForm = class(TForm)
    DataSource1: TDataSource;
    IBTransaction1: TIBTransaction;
    ibqProjectLayerClass: TIBQuery;
    updProjectLayerClass: TIBUpdateSQL;
    gridClassif: TkaDBGrid;
    Panel1: TPanel;
    btnEdit: TButton;
    btnDelete: TButton;
    btnClose: TButton;
    ActionList1: TActionList;
    acMPClassAdd: TAction;
    acMPClassEdit: TAction;
    acMPClassDelete: TAction;
    edSearch: TEdit;
    Label1: TLabel;
    ibsqlLineColor: TIBSQL;
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure acMPClassEditExecute(Sender: TObject);
    procedure edSearchChange(Sender: TObject);
  private
    FNetTypes: TStrings;
    FMPNetTypes: TStrings;
    FLayerNames: TStrings;
    procedure PrepareDataSet();
    function GetNetTypes(): TStrings;
    function GetMPNetTypes(): TStrings;
    procedure LoadLayerNames();
    procedure LoadMPNetTypes();
    procedure LoadNetTypes();
  public
    procedure Display();
  end;

var
  mstMPClassSettingsForm: TmstMPClassSettingsForm;

implementation

uses
  uMStKernelConsts, uMStConsts,
  uMStDialogMPClass;

{$R *.dfm}

const
  SQL_SELECT_PROJECT_LAYER_CLASSES =
    'SELECT PL.ID, PL.NAME, PL.REQUIRED, PL.DESTROYED, PL.OBJECT_TYPE, PL.NET_TYPES_ID, PL.ACTUAL, '
    + ' PNT.NAME AS NET_NAME, PL.MP_NET_TYPES_ID, '
    + ' MPNT.NAME AS MP_NET_NAME '
    + ' FROM PROJECT_LAYERS PL '
    + '      LEFT JOIN '
    + '      PROJECT_NET_TYPES PNT ON (PL.NET_TYPES_ID = PNT.ID) '
    + '      LEFT JOIN '
    + '      MASTER_PLAN_LAYERS MPNT ON (PL.MP_NET_TYPES_ID = MPNT.ID) '
    + ' ORDER BY PL.NAME ';

  SQL_UPDATE_PROJECT_LAYER_CLASSES =
    'UPDATE PROJECT_LAYERS '
    + ' SET NAME=:NAME, NET_TYPES_ID=:NET_TYPES_ID, MP_NET_TYPES_ID=:MP_NET_TYPES_ID '
    + ' WHERE ID=:ID ';
  SQL_REFRESH_PROJECT_LAYER_CLASSES =
    'SELECT PL.ID, PL.NAME, PL.REQUIRED, PL.DESTROYED, PL.OBJECT_TYPE, PL.NET_TYPES_ID, PL.ACTUAL, '
    + ' PNT.NAME AS NET_NAME, PL.MP_NET_TYPES_ID, '
    + ' MPNT.NAME AS MP_NET_NAME '
    + ' FROM PROJECT_LAYERS PL '
    + '      LEFT JOIN '
    + '      PROJECT_NET_TYPES PNT ON (PL.NET_TYPES_ID = PNT.ID) '
    + '      LEFT JOIN '
    + '      MASTER_PLAN_LAYERS MPNT ON (PL.MP_NET_TYPES_ID = MPNT.ID) '
    + ' WHERE PL.ID=:ID ';

  SQL_SELECT_MP_NET_TYPES =
    'SELECT '
    + 'CASE '
    + 'WHEN (MPL2.NAME IS NULL) THEN MPL1.NAME '
    + 'ELSE MPL2.NAME || '' - '' || MPL1.NAME '
    + 'END AS NAME, '
    + 'MPL1.ID '
    + 'FROM MASTER_PLAN_LAYERS MPL1 '
    + 'LEFT JOIN MASTER_PLAN_LAYERS MPL2 ON (MPL1.GROUP_ID=MPL2.ID) '
    + 'ORDER BY 1';

  SQL_SELECT_NET_TYPES =
    'SELECT ID, NAME FROM PROJECT_NET_TYPES ORDER BY NAME';

{ TmstMPClassSettingsForm }

procedure TmstMPClassSettingsForm.acMPClassEditExecute(Sender: TObject);
var
  LayerName: string;
  Id, NetId: Integer;
  MPNetId: Integer;
  Dlg: TmstMPClassDialog;
begin
  // показать окно редактирования
  if mstMPClassDialog = nil then
    mstMPClassDialog := TmstMPClassDialog.Create(Self);
  Dlg := mstMPClassDialog;
  //
  Id := ibqProjectLayerClass.FieldByName(SF_ID).AsInteger;
  LayerName := ibqProjectLayerClass.FieldByName(SF_NAME).AsString;
  NetId := ibqProjectLayerClass.FieldByName(SF_NET_TYPES_ID).AsInteger;
  MPNetId := ibqProjectLayerClass.FieldByName(SF_MP_NET_TYPES_ID).AsInteger;
  //
  Dlg.Id := Id;
  Dlg.NetTypes := GetNetTypes();
  Dlg.MPNetTypes := GetMPNetTypes();
  Dlg.LayerName := LayerName;
  Dlg.NetTypeId := NetId;
  Dlg.MPNetTypeId := MPNetId;
  Dlg.LayerNames := FLayerNames;
  //
  if Dlg.EditLayer() then
  begin
    ibqProjectLayerClass.Edit;
    ibqProjectLayerClass.FieldByName(SF_NAME).AsString := Dlg.LayerName;
    ibqProjectLayerClass.FieldByName(SF_NET_TYPES_ID).AsInteger := Dlg.NetTypeId;
    ibqProjectLayerClass.FieldByName(SF_MP_NET_TYPES_ID).AsInteger := Dlg.MPNetTypeId;
    ibqProjectLayerClass.Post;
    //
    IBTransaction1.CommitRetaining;
  end;
end;

procedure TmstMPClassSettingsForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TmstMPClassSettingsForm.Display;
begin
  if not Visible then
  begin
    PrepareDataSet();
    edSearch.Text := '';
    Show();
  end;
end;

procedure TmstMPClassSettingsForm.edSearchChange(Sender: TObject);
begin
  if not ibqProjectLayerClass.Active then
    Exit;
  if edSearch.Text <> '' then
    ibqProjectLayerClass.Locate(SF_NAME, edSearch.Text, [loCaseInsensitive, loPartialKey]);
end;

procedure TmstMPClassSettingsForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  mstMPClassSettingsForm := nil;
end;

procedure TmstMPClassSettingsForm.FormCreate(Sender: TObject);
begin
  FNetTypes := TStringList.Create;
  FMPNetTypes := TStringList.Create;
  FLayerNames := TStringList.Create;
end;

procedure TmstMPClassSettingsForm.FormDestroy(Sender: TObject);
begin
  FNetTypes.Free;
  FMPNetTypes.Free;
  FLayerNames.Free;
end;

function TmstMPClassSettingsForm.GetMPNetTypes: TStrings;
begin
  LoadMPNetTypes();
  //
  Result := FMPNetTypes;
end;

function TmstMPClassSettingsForm.GetNetTypes: TStrings;
begin
  LoadNetTypes();
  //
  Result := FNetTypes;
end;

procedure TmstMPClassSettingsForm.LoadLayerNames;
var
  aLayerName: string;
  aId: Integer;
begin
  if FLayerNames = nil then
    FLayerNames := TStringList.Create;
  ibqProjectLayerClass.First;
  while not ibqProjectLayerClass.Eof do
  begin
    aLayerName := ibqProjectLayerClass.FieldByName(SF_NAME).AsString;
    aId := ibqProjectLayerClass.FieldByName(SF_ID).AsInteger;
    FLayerNames.AddObject(aLayerName, Pointer(aId));
    ibqProjectLayerClass.Next;
  end;
  ibqProjectLayerClass.First;
end;

procedure TmstMPClassSettingsForm.LoadMPNetTypes;
var
  Ds: TIBQuery;
  S: string;
  Id: Integer;
begin
  if FMPNetTypes.Count > 0 then
    Exit;
  Ds := TIBQuery.Create(Self);
  try
    Ds.Transaction := IBTransaction1;
    Ds.SQL.Text := SQL_SELECT_MP_NET_TYPES;
    Ds.Open;
    while not Ds.Eof do
    begin
      S := Ds.FieldByName(SF_NAME).AsString;
      Id := Ds.FieldByName(SF_ID).AsInteger;
      FMPNetTypes.AddObject(S, Pointer(Id));
      Ds.Next;
    end;
  finally
    Ds.Free;
  end;
end;

procedure TmstMPClassSettingsForm.LoadNetTypes;
var
  Ds: TIBQuery;
  S: string;
  Id: Integer;
begin
  if FNetTypes.Count > 0 then
    Exit;
  Ds := TIBQuery.Create(Self);
  try
    Ds.Transaction := IBTransaction1;
    Ds.SQL.Text := SQL_SELECT_NET_TYPES;
    Ds.Open;
    while not Ds.Eof do
    begin
      S := Ds.FieldByName(SF_NAME).AsString;
      Id := Ds.FieldByName(SF_ID).AsInteger;
      FNetTypes.AddObject(S, Pointer(Id));
      Ds.Next;
    end;
  finally
    Ds.Free;
  end;
end;

procedure TmstMPClassSettingsForm.PrepareDataSet;
begin
  ibqProjectLayerClass.SQL.Text := SQL_SELECT_PROJECT_LAYER_CLASSES;
  updProjectLayerClass.ModifySQL.Text := SQL_UPDATE_PROJECT_LAYER_CLASSES;
  updProjectLayerClass.RefreshSQL.Text := SQL_REFRESH_PROJECT_LAYER_CLASSES; 
  if not IBTransaction1.Active then
    IBTransaction1.StartTransaction;
  ibqProjectLayerClass.Open;
  LoadLayerNames();
end;

end.
