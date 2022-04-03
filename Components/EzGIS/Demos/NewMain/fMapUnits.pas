unit fMapUnits;

{$I EZ_FLAG.PAS}
interface

uses
  Windows, Classes, Forms, Controls, StdCtrls, ExtCtrls, EzBaseGis;

type
  TfrmMapOpts = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Label2: TLabel;
    CboCoords: TComboBox;
    BtnProj1: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    CboSystem: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    cboView: TComboBox;
    procedure OKBtnClick(Sender: TObject);
    procedure BtnProj1Click(Sender: TObject);
    procedure CboSystemClick(Sender: TObject);
  private
    { Private declarations }
    FDrawBox: TEzBaseDrawBox;
  public
    { Public declarations }
    function Enter(DrawBox: TEzBaseDrawBox): Word;
  end;

implementation

{$R *.DFM}

uses
  ezbase, fproj, EzProjections, ezConsts, ezSystem;

function TfrmMapOpts.Enter(DrawBox: TEzBaseDrawBox): Word;
var
  i: TEzCoordsUnits;
begin
  FDrawBox := DrawBox;
  with FDrawBox.Gis.MapInfo do
  begin
    CboSystem.ItemIndex:= Ord(CoordSystem);
    for i := Low(pj_units) to High(pj_units) do
    begin
      CboCoords.Items.Add(pj_units[i].name);
      CboView.Items.Add(pj_units[i].name);
    end;
    CboCoords.ItemIndex := Ord(CoordsUnits);
    //CboView.ItemIndex := Ord(ViewLinearUnits);
  end;
  CboSystem.OnClick(nil);
  Result := ShowModal;
end;

procedure TfrmMapOpts.OKBtnClick(Sender: TObject);
var
  cs: TEzCoordSystem;
  u: TEzCoordsUnits;
begin
  with FDrawBox.Gis do
  begin
    cs:= TEzCoordSystem(CboSystem.ItemIndex);
    MapInfo.CoordSystem:= cs;
    if cs=csLatLon then
    begin
      MapInfo.CoordsUnits:= cuDeg;
      //MapInfo.ViewLinearUnits:= cuDeg;
    end else
    begin
      u:= TEzCoordsUnits(CboCoords.ItemIndex);
      if u=cuDeg then
        MapInfo.CoordsUnits:= cuM
      else
        MapInfo.CoordsUnits:= u;

      //u:= TEzCoordsUnits(CboView.ItemIndex);
      //if u=cuDeg then
      //  MapInfo.ViewLinearUnits:= cuM
      //else
      //  MapInfo.ViewLinearUnits:= u;
    end;
    Modified := True;
  end;
end;

procedure TfrmMapOpts.BtnProj1Click(Sender: TObject);
var
  sl1, sl2: TStringList;
  cs: TEzCoordSystem;
  cnt: Integer;
begin
  with FDrawBox.Gis do
  begin
    cs := csProjection;
    sl1 := TStringList.Create;
    sl2 := TStringList.Create;
    if ProjectionParams.Count>2 then
    begin
      sl1.Add(ProjectionParams[0]);
      sl1.Add(ProjectionParams[1]);
      sl1.Add(ProjectionParams[2]);
    end;
    for cnt := 3 to ProjectionParams.Count - 1 do
      sl2.Add(ProjectionParams[cnt]);
  end;
  try
    if fProj.SelectCoordSystem('', cs, sl1, sl2, false) then
      with FDrawBox.Gis do
      begin
        ProjectionParams.Clear;
        ProjectionParams.AddStrings(sl1);
        ProjectionParams.AddStrings(sl2);
      end;
  finally
    sl1.Free;
    sl2.Free;
  end;
end;

procedure TfrmMapOpts.CboSystemClick(Sender: TObject);
begin
  BtnProj1.Enabled:= CboSystem.ItemIndex=2;
  CboCoords.Enabled:= CboSystem.ItemIndex<>1;
  if not CboCoords.Enabled then
    CboCoords.ItemIndex:=Ord(cuDeg)
  else
    CboCoords.ItemIndex:=Ord(FDrawBox.Gis.MapInfo.CoordsUnits);
  if (CboSystem.ItemIndex<>1) and (CboCoords.ItemIndex=Ord(cuDeg)) then
    CboCoords.ItemIndex:=0;
end;

end.

