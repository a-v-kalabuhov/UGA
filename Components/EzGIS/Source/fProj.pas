unit fProj;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
interface

uses
  SysUtils, Classes, Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
  ezbase;

type

  TfrmGeoProj = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    GroupCombo: TComboBox;
    ProjectionCombo: TComboBox;
    DatumCombo: TComboBox;
    Label4: TLabel;
    LinearUnitsCombo: TComboBox;
    Panel1: TPanel;
    Label6: TLabel;
    cboZone: TComboBox;
    Label7: TLabel;
    Edit1: TEdit;
    Label8: TLabel;
    Edit2: TEdit;
    Button3: TButton;
    Panel2: TPanel;
    Panel3: TPanel;
    Memo1: TMemo;
    Panel4: TPanel;
    Memo2: TMemo;
    Button4: TButton;
    Button5: TButton;
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure GroupComboChange(Sender: TObject);
    procedure ProjectionComboChange(Sender: TObject);
    procedure cboZoneChange(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
    SavedProj, SavedProjSpec: TStringList;
    LocalProj, LocalProjSpec: TStringList;
    FFileName: string;
    procedure GetLocalProj;
    procedure PopulateZones;
    procedure DoSaveProjection(n: integer; add: boolean);
  public
    { Public declarations }
    Savecs: TEzCoordSystem;
    function Enter(acs: TEzCoordSystem; ProjList, ProjSpecList: TStringList): Word;
  end;

  function SelectCoordSystem( const FormCaption: string;
                              var cs: TEzCoordSystem;
                              ProjList,
                              ProjSpecList: TStringList;
                              CanSelectGroup: Boolean): Boolean;

implementation

{$R *.DFM}

uses
  Inifiles, EzSystem, EzProjections, TypInfo;

resourcestring
  STestConv= 'Test';
  SConfirmAddToProj= 'Area you sure you want to add/update this projection ?';
  SProjectionAdded= 'The projection was added/updated to the database';
  SConfirmDeleteToProj= 'Area you sure you want to delete this projection ?';
  SProjectionDeleted= 'The projection was deleted from the database';

function SelectCoordSystem( const FormCaption: string;
                            var cs:TEzCoordSystem;
                            ProjList,
                            ProjSpecList: TStringList;
                            CanSelectGroup: Boolean): Boolean;
begin
  Result:= False;
  with TfrmGeoProj.Create(Nil) do
    try
      if Length(FormCaption)>0 then
        Caption:= FormCaption;
      if not CanSelectGroup then
      begin
        GroupCombo.ItemIndex := Ord(csProjection);   (* =2 *)
        GroupCombo.Enabled := false;
      end;
      //ChkIndexed.Visible := SpatialIndexed;
      //ChkIndexed.Checked := SpatialIndexed;
      if Enter( cs, ProjList, ProjSpecList )=mrOk then
      begin
        cs := TEzCoordSystem(GroupCombo.ItemIndex);
        //SpatialIndexed:= ChkIndexed.Checked;
        Result:= True;
      end;
   finally
      Free;
   end;
end;

function TfrmGeoProj.Enter(acs: TEzCoordSystem; ProjList, ProjSpecList: TStringList): Word;
var
  gc: TEzGeoConvert;
  found:boolean;
begin
  Savecs := acs;
  SavedProj:= ProjList;
  SavedProjSpec:= ProjSpecList;

  LocalProj.Assign(ProjList);
  LocalProjSpec.Assign(ProjSpecList);

  // initialize general projection data
  gc:= TEzGeoConvert.Create;
  try
     //gc.CoordSystem:= acs;
     Memo1.Lines.Assign(ProjList);
     Memo2.Lines.Assign(ProjSpecList);
     gc.paralist.Assign(ProjList);
     GroupCombo.ItemIndex:= Ord(acs);
     if gc.pj_param.defined('proj') then
        ProjectionCombo.ItemIndex := ProjectionCombo.Items.IndexOf(pj_list[projcodefromid(gc.pj_param.asstring('proj'),found)].descr)
     else
        ProjectionCombo.ItemIndex := ProjectionCombo.Items.IndexOf(pj_list[utm].descr);
     ProjectionCombo.OnChange(nil);
     if gc.pj_param.defined('ellps') then
        DatumCombo.ItemIndex := DatumCombo.Items.IndexOf(pj_ellps[ellpscodefromid(gc.pj_param.asstring('ellps'))].name)
     else
        DatumCombo.ItemIndex := DatumCombo.Items.IndexOf(pj_ellps[ellpscodefromid('WGS84')].name);
     if gc.pj_param.defined('units') then
        LinearUnitsCombo.ItemIndex := LinearUnitsCombo.Items.IndexOf(pj_units[UnitCodeFromID(gc.pj_param.asstring('units'))].name)
     else
        LinearUnitsCombo.ItemIndex := LinearUnitsCombo.Items.IndexOf(pj_units[UnitCodeFromID('m')].name)
  finally
     gc.free;
  end;
  GroupCombo.OnChange(nil);

  result:= ShowModal;
end;

procedure TfrmGeoProj.OKBtnClick(Sender: TObject);
begin
  LocalProjSpec.Assign(Memo2.Lines);
  GetLocalProj;
  SavedProj.Assign(LocalProj);
  SavedProjSpec.Assign(LocalProjSpec);
end;

procedure TfrmGeoProj.GetLocalProj;
var
  en: string;
begin
  LocalProj.Clear;
  // the projection code
  if ProjectionCombo.ItemIndex>=0 then
    LocalProj.Add('proj='+GetEnumName(System.TypeInfo(TEzProjectionCode),ProjectionCombo.ItemIndex));
    //pj_list[TProjectionCode(ProjectionCombo.ItemIndex)].id);
  // the ellipsoid (Datum)
  if DatumCombo.ItemIndex>=0 then
  begin
    en:= GetEnumName(System.TypeInfo(TEzEllipsoidCode), DatumCombo.ItemIndex);
    LocalProj.Add('ellps='+copy(en,3,length(en)));
    //pj_ellps[DatumCombo.ItemIndex].id);
  end;
  if LinearUnitsCombo.ItemIndex>=0 then
  begin
    //en:= GetEnumName(System.TypeInfo(TEzCoordsUnits), LinearUnitsCombo.ItemIndex);
    LocalProj.Add('units='+pj_units[TEzCoordsUnits(LinearUnitsCombo.ItemIndex)].id);{copy(en,3,length(en))}
    //pj_units[TCoordsUnits(LinearUnitsCombo.ItemIndex)].id);  // the units
  end;
  Memo1.Lines.Assign(LocalProj);
end;

procedure TfrmGeoProj.FormCreate(Sender: TObject);
var
  p: TEzProjectionCode;
  i: TEzCoordsUnits;
  j: TEzEllipsoidCode;
begin
  LocalProj:= TStringList.Create;
  LocalProjSpec:= TStringList.Create;
  for p:=Low(TEzProjectionCode) to High(TEzProjectionCode) do
     ProjectionCombo.Items.Add(pj_list[p].descr);
  for j:= Low(TEzEllipsoidCode) to High(TEzEllipsoidCode) do
     DatumCombo.Items.Add(pj_ellps[j].name);
  for i:=Low(pj_units) to High(pj_units) do
     LinearUnitsCombo.Items.Add(pj_units[i].name);
  PopulateZones;

{$IFDEF LANG_SPA}
  Caption:='Elegir Sistema de Coordenadas';
  OKBtn.caption:='Aceptar';
  CancelBtn.caption:='Cancelar';
  Label1.caption:='&Grupo :';
  Label6.caption:='&Zona :';
  Label2.caption:='&Proyeccion :';
  Label3.caption:='&Elipsoide :';
  Label4.caption:='&Unidades :';
  Panel3.caption:='Parametros basicos';
  Panel4.caption:='Parametros especificos de esta proyeccion';
  Label7.caption:='Codigo de Zona (Uso futuro) :';
  Label8.caption:='Descripcion de z&ona';
  Button3.caption:='Agrega a &base de datos';
  Button4.caption:='Act&ualiza esta proyeccion';
  Button5.caption:='&Elimina esta proyeccion';
{$ENDIF}
end;

procedure TfrmGeoProj.PopulateZones;
var
  i,n: integer;
  temp,section: string;
  iniFile: TIniFile;
begin
  { populate the list of projections }
  FFilename:= ExtractFilePath(Application.ExeName)+'proj_data.ini';
  if FileExists(FFilename) then
  begin
    cboZone.Items.Clear;
    iniFile:= TIniFile.Create(FFileName);
    Screen.Cursor:= crHourglass;
    try
      n:= ReadIntFromIni( Inifile, 'General','NumProj',0);
      for i:= 1 to n do
      begin
        section:= 'proj'+inttostr(i);
        { we can use Inifile.SectionExists but Delphi 3 does not have it}
        if Length(Inifile.ReadString(section,'ydes',''))>0 then
        begin
          temp:= Inifile.ReadString(section,'ydes','');
          cboZone.Items.addobject(temp,pointer(i));
        end;
      end;
      n:= ReadIntFromIni( Inifile, 'General','CurrProj',0);
      for i:= 0 to cboZone.Items.Count-1 do
        if Longint(cboZone.Items.Objects[i])=n then
        begin
          cboZone.ItemIndex:= i;
          cboZone.OnChange(nil);
          break;
        end;
    finally
      IniFile.Free;
      Screen.Cursor:= crDefault;
    end;
  end;
end;

procedure TfrmGeoProj.FormDestroy(Sender: TObject);
begin
  LocalProj.Free;
  LocalProjSpec.Free;
end;

procedure TfrmGeoProj.GroupComboChange(Sender: TObject);
var
  Enable:boolean;
  cs: TEzCoordSystem;
begin
  cs:= TEzCoordSystem(GroupCombo.ItemIndex);
  Enable:= not(cs in [csCartesian,csLatLon]);
  ProjectionCombo.Enabled:= Enable;
  cboZone.Enabled:=Enable;
  Panel1.Enabled:=Enable;
  DatumCombo.Enabled:= Enable;
  LinearUnitsCombo.Enabled:= Enable;
  if not Enable then
  begin
     //FreeChildForm;
     LocalProjSpec.Clear;
     Memo2.Lines.Clear;
  end else
     ProjectionCombo.OnChange(nil);
end;

procedure TfrmGeoProj.ProjectionComboChange(Sender: TObject);
begin
  if (ProjectionCombo.ItemIndex<0) or (DatumCombo.ItemIndex<0)
    or (LinearUnitsCombo.ItemIndex<0) then exit;
  GetLocalProj;
end;

procedure TfrmGeoProj.cboZoneChange(Sender: TObject);
var
  IniFile: TIniFile;
  params: TStringList;
  Index: integer;
  j: TEzEllipsoidCode;
  i: TEzCoordsUnits;
  k: TEzProjectionCode;
  en,temp: string;
begin
  if not FileExists(FFileName) or (cboZone.ItemIndex<0) then exit;
  Inifile:= TInifile.create(FFileName);
  params:= TStringList.create;
  try
    Index:= Longint(cboZone.Items.Objects[cboZone.ItemIndex]);
    Inifile.ReadSectionValues('proj'+inttostr(Index),params);
    Edit1.Text:= params.values['ycode'];
    Edit2.Text:= params.values['ydes'];
    Index:= params.IndexOfName('ycode');
    if Index>=0 then
      params.Delete(Index);
    Index:= params.IndexOfName('ydes');
    if Index>=0 then
      params.Delete(Index);
    { now update the three combo boxes}
    // the projection
    Index:= params.IndexOfName('proj');
    if Index>=0 then
    begin
      temp:= params.values['proj'];
      for k:= low(TEzProjectionCode) to high(TEzProjectionCode) do
        if AnsiCompareText(temp, GetEnumName(System.TypeInfo(TEzProjectionCode),Ord(k)))=0 then  //pj_list[k].id
        begin
          ProjectionCombo.ItemIndex:=ord(k);
          break;
        end;
      params.Delete(Index);
    end;
    // the ellipsoid
    Index:= params.IndexOfName('ellps');
    if Index>=0 then
    begin
      temp:= params.values['ellps'];
      for j:= low(TEzEllipsoidCode) to high(TEzEllipsoidCode) do
      begin
        en:= GetEnumName(System.TypeInfo(TEzEllipsoidCode), Ord(j));
        if AnsiCompareText(temp, copy(en,3,length(en)))=0 then //pj_ellps[j].id
        begin
          DatumCombo.ItemIndex:=ord(j);
          break;
        end;
      end;
      params.Delete(Index);
    end;
    // the units
    Index:= params.IndexOfName('units');
    if Index>=0 then
    begin
      temp:= params.values['units'];
      for i:= low(TEzCoordsUnits) to high(TEzCoordsUnits) do
      begin
        //en:= GetEnumName(System.TypeInfo(TEzCoordsUnits), Ord(i));
        if AnsiCompareText(temp, pj_units[i].id{copy(en,3,length(en))})=0 then
        begin
          LinearUnitsCombo.ItemIndex:=Ord(i);
          break;
        end;
      end;
      params.Delete(Index);
    end;
    GetLocalProj;
    Memo2.Lines.Assign(params);
  finally
    Inifile.free;
    params.free;
  end;
end;

procedure TfrmGeoProj.Button3Click(Sender: TObject);
var
  Inifile: TInifile;
  n: integer;
begin
  if (MessageDlg(SConfirmAddToProj, mtConfirmation, [mbYes, mbNo], 0) <> mrYes) or
    not FileExists(FFileName) then exit;
  Inifile:= TInifile.create(FFileName);
  try
    n:= ReadIntFromIni( Inifile, 'General', 'NumProj',0);
    inc(n);
  finally
    Inifile.Free;
  end;
  DoSaveProjection(n, true);
end;

procedure TfrmGeoProj.DoSaveProjection(n: integer; add: boolean);
var
  Inifile: TInifile;
  i,p: integer;
  section,en,temp: string;
begin
  if not FileExists(FFileName) or (ProjectionCombo.ItemIndex<0) or
    (DatumCombo.ItemIndex<0) or (LinearUnitsCombo.ItemIndex<0) then exit;
  Inifile:= TInifile.create(FFileName);
  try
    section:='proj'+inttostr(n);
    Inifile.WriteString(section,'ycode',Edit1.Text);
    Inifile.WriteString(section,'ydes',Edit2.Text);
    Inifile.WriteString(section,'proj',GetEnumName(System.TypeInfo(TEzProjectionCode),ProjectionCombo.ItemIndex));
    //pj_list[TEzProjectionCode(ProjectionCombo.ItemIndex)].id);
    en:= GetEnumName(System.TypeInfo(TEzCoordsUnits), LinearUnitsCombo.ItemIndex);
    Inifile.WriteString(section,'ellps',copy(en,3,length(en)));
    //pj_ellps[DatumCombo.ItemIndex].id);
    //en:= GetEnumName(System.TypeInfo(TEzCoordsUnits), LinearUnitsCombo.ItemIndex);
    Inifile.WriteString(section,'units',pj_units[TEzCoordsUnits(LinearUnitsCombo.ItemIndex)].id){copy(en,3,length(en))};
    //pj_units[TEzCoordsUnits(LinearUnitsCombo.ItemIndex)].id);
    for i:= 0 to Memo2.Lines.Count-1 do
    begin
      temp:= Memo2.Lines[i];
      p:= AnsiPos('=',temp);
      if p>0 then
        Inifile.WriteString(section,copy(temp,1,p-1),copy(temp,p+1,length(temp)));
    end;
    if add then
      Inifile.WriteInteger('General', 'NumProj',n);
    Inifile.WriteInteger('General', 'CurrProj',n);
{$IFDEF LEVEL4}   // DELPHI 4 AND UP
    Inifile.UpdateFile;
{$ENDIF}
  finally
    Inifile.free;
  end;
  PopulateZones;
  ShowMessage(SProjectionAdded);
end;

procedure TfrmGeoProj.Button4Click(Sender: TObject);
var
  Inifile: TInifile;
  n: integer;
begin
  if (cboZone.ItemIndex <0) or
    (MessageDlg(SConfirmAddToProj, mtConfirmation, [mbYes, mbNo], 0) <> mrYes) or
    not FileExists(FFileName) then exit;
  Inifile:= TInifile.Create(FFileName);
  n:= Longint(cboZone.Items.Objects[cboZone.ItemIndex]);
  try
    Inifile.EraseSection('proj'+inttostr(n));
  finally
    Inifile.Free;
  end;
  DoSaveProjection(n, false);
end;

procedure TfrmGeoProj.Button5Click(Sender: TObject);
var
  Inifile: TInifile;
  n: integer;
begin
  if (cboZone.ItemIndex <0) or
    (MessageDlg(SConfirmDeleteToProj, mtConfirmation, [mbYes, mbNo], 0) <> mrYes) or
    not FileExists(FFileName) then exit;
  Inifile:= TInifile.Create(FFileName);
  n:= Longint(cboZone.Items.Objects[cboZone.ItemIndex]);
  try
    Inifile.EraseSection('proj'+inttostr(n));
    Inifile.WriteInteger('General','CurrProj',1);
  finally
    Inifile.Free;
  end;
  PopulateZones;
  ShowMessage(SProjectionDeleted);
end;

end.
