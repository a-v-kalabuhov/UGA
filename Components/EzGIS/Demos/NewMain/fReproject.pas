unit fReproject;
                      
{$I EZ_FLAG.PAS}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, EzBasegis, 
  CheckLst, EzEntities, EzProjections, EzCtrls;

type
  TfrmReproject = class(TForm)
    DestinGis: TEzGis;
    Projector1: TEzProjector;
    Projector2: TEzProjector;
    Panel1: TPanel;
    BtnNext: TButton;
    BtnPrevious: TButton;
    BtnConvert: TButton;
    Button6: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label3: TLabel;
    Label4: TLabel;
    LblProjName: TLabel;
    Label5: TLabel;
    LblProjEllipsoid: TLabel;
    Label6: TLabel;
    LblProjUnits: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    Label1: TLabel;
    Memo1: TMemo;
    Button1: TButton;
    CboCoordSystem: TComboBox;
    CboCoordsUnits: TComboBox;
    CheckListBox1: TCheckListBox;
    TabSheet2: TTabSheet;
    Label7: TLabel;
    SpeedButton1: TSpeedButton;
    Label8: TLabel;
    Label9: TLabel;
    DestLblProjName: TLabel;
    Label11: TLabel;
    DestLblProjEllipsoid: TLabel;
    Label13: TLabel;
    DestLblProjUnits: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Edit2: TEdit;
    Memo2: TMemo;
    Button2: TButton;
    CboDestCoordSystem: TComboBox;
    CboDestCoordsUnits: TComboBox;
    TabSheet3: TTabSheet;
    Label15: TLabel;
    ProgressBar1: TProgressBar;
    procedure BtnExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnNextClick(Sender: TObject);
    procedure BtnPreviousClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure BtnConvertClick(Sender: TObject);
    procedure CboCoordSystemClick(Sender: TObject);
    procedure CboDestCoordSystemClick(Sender: TObject);
  private
    { Private declarations }
    FSourceGis: TEzGis;
    FSourceProjector: TEzProjector;
    FDestinProjector: TEzProjector;
    procedure ShowParams;
  public
    { Public declarations }
    function Enter(Gis: TEzGis):Word;
  end;

implementation

{$R *.DFM}
uses
  fproj, ezimpl, ezlib, FileCtrl, ezbase, ezsystem, EzSHPImport, ezbasicctrls;

function TfrmReproject.Enter(Gis: TEzGis): Word;
var
  I: Integer;
begin
  FSourceGis:=Gis;
  checkListBox1.Items.Clear;
  for I:= 0 to FSourceGis.Layers.Count-1 do
    checkListBox1.Items.add(FSourceGis.Layers[i].Name);
  CboCoordSystem.ItemIndex:= Ord(FSourceGis.MapInfo.CoordSystem);
  CboCoordSystem.OnClick(nil);
  CboCoordsUnits.ItemIndex:= Ord(FSourceGis.MapInfo.CoordsUnits);
  FSourceProjector.Params.assign( FSourceGis.ProjectionParams );
  Memo1.Lines.Assign(FSourceGis.ProjectionParams);
  Result:=showmodal;
end;

procedure TfrmReproject.BtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmReproject.FormCreate(Sender: TObject);
var
  I: TEzCoordsUnits;
begin
  FSourceProjector:= TEzProjector.create(self);
  FSourceProjector.InitDefault;
  FDestinProjector:= TEzProjector.Create(self);
  FDestinProjector.InitDefault;
  CboCoordSystem.ItemIndex:= 0;
  CboDestCoordSystem.ItemIndex:= 0;
  { fill the units combo box }
  for I:= Low(pj_units) to High(pj_units) do
  begin
    CboCoordsUnits.Items.Add(pj_units[I].name);
    CboDestCoordsUnits.Items.Add(pj_units[I].name);
  end;
  CboCoordsUnits.ItemIndex:= 0;
  CboDestCoordsUnits.ItemIndex:= 0;
  ShowParams;
end;

procedure TfrmReproject.ShowParams;
var
  projcode: TEzProjectionCode;
  ellpscode: TEzEllipsoidCode;
  unitcode: TEzCoordsUnits;
  found:boolean;
begin
  { Prepare for calculating with the current parameters defined }
  FSourceProjector.CoordSysInit;
  Memo1.Lines.Assign(FSourceProjector.Params);
  if FSourceProjector.GC.pj_param.Defined('proj') then
  begin
    projcode:= ezprojections.ProjCodeFromID(FSourceProjector.GC.pj_param.AsString('proj'),found);
    LblProjName.Caption:= pj_list[projcode].Descr ;
  end;
  if FSourceProjector.GC.pj_param.Defined('ellps') then
  begin
    ellpscode:= ezprojections.EllpsCodeFromID(FSourceProjector.GC.pj_param.AsString('ellps'));
    LblProjEllipsoid.Caption:= pj_ellps[ellpscode].Name;
  end;
  if FSourceProjector.GC.pj_param.Defined('units') then
  begin
    unitcode:= ezbase.UnitCodeFromID(FSourceProjector.GC.pj_param.AsString('units'));
    LblProjUnits.Caption:= pj_units[unitcode].name ;
  end;

  { the destination }
  FDestinProjector.CoordSysInit;
  Memo2.Lines.Assign(FDestinProjector.Params);
  if FDestinProjector.GC.pj_param.Defined('proj') then
  begin
    projcode:= ezprojections.ProjCodeFromID(FDestinProjector.GC.pj_param.AsString('proj'),found);
    DestLblProjName.Caption:= pj_list[projcode].Descr ;
  end;
  if FDestinProjector.GC.pj_param.Defined('ellps') then
  begin
    ellpscode:= ezprojections.EllpsCodeFromID(FDestinProjector.GC.pj_param.AsString('ellps'));
    DestLblProjEllipsoid.Caption:= pj_ellps[ellpscode].Name;
  end;
  if FDestinProjector.GC.pj_param.Defined('units') then
  begin
    unitcode:= ezbase.UnitCodeFromID(FDestinProjector.GC.pj_param.AsString('units'));
    DestLblProjUnits.Caption:= pj_units[unitcode].name ;
  end;
end;

procedure TfrmReproject.BtnNextClick(Sender: TObject);
var
  i,n: integer;
begin
  case PageControl1.ActivePage.PageIndex of
    0: begin
         // count the layers to convert
         n:= 0;
         for i:= 0 to FSourceGis.Layers.count-1 do
           if checkListBox1.Checked[I] then Inc(n);
         if (FSourceGis.Layers.Count=0) or (n=0) then
           raise Exception.Create('Map not defined or layers not selected to convert');
         PageControl1.ActivePage:= TabSheet2;
         BtnPrevious.Enabled:= true;
       end;
    1: begin
         if (Length(Trim(Edit2.Text))=0) or not DirectoryExists(Edit2.Text) or
            ( AnsiCompareText(AddSlash(ExtractFilePath(FSourceGis.FileName)),
              AddSlash(Edit2.Text) )=0 ) then
          raise Exception.Create('The destination path does not exists or is same as source');
         PageControl1.ActivePage:= TabSheet3;
         BtnNext.Enabled:= false;
         BtnConvert.Enabled:= true;
       end;
  end;
  PageControl1Change(nil);
end;

procedure TfrmReproject.BtnPreviousClick(Sender: TObject);
begin
{$IFDEF LEVEL4}      // Delphi 4
  case PageControl1.ActivePage.PageIndex of
{$ELSE}
  case PageControl1.ActivePageIndex of
{$ENDIF}
    1: begin
{$IFDEF LEVEL4}      // Delphi 4
         PageControl1.ActivePage.PageIndex:= 0;
{$ELSE}
         PageControl1.ActivePageIndex:= 0;
{$ENDIF}
         BtnNext.Enabled:= true;
         btnPrevious.Enabled:=false;
         BtnConvert.Enabled:= false;
       end;
    2: begin
{$IFDEF LEVEL4}      // Delphi 4
         PageControl1.ActivePage.PageIndex:= 1;
{$ELSE}
         PageControl1.ActivePageIndex:= 1;
{$ENDIF}
         btnConvert.Enabled:=false;
         btnPrevious.Enabled:=true;
         btnNext.Enabled:= true;
       end;
  end;
  PageControl1Change(nil);
end;

procedure TfrmReproject.SpeedButton1Click(Sender: TObject);
var
  Directory: String;
begin
  Directory:= ExtractFileDir(Application.ExeName);
  if SelectDirectory(Directory, [sdAllowCreate, sdPerformCreate, sdPrompt], 0) then
  begin
    Edit2.Text:= AddSlash(Directory);
  end;
end;

procedure TfrmReproject.Button1Click(Sender: TObject);
var
  sl1, sl2: TStringList;
  cs: TEzCoordSystem;
  cnt: Integer;
begin
  FSourceProjector.CheckDefaultParams;
  cs := csProjection;
  sl1 := TStringList.Create;
  sl2 := TStringList.Create;
  sl1.Add(FSourceProjector.Params[0]);  { the first three lines contains the basic projection params :}
  sl1.Add(FSourceProjector.Params[1]);  { the projection, the ellipsoid and the units}
  sl1.Add(FSourceProjector.Params[2]);  { proj=  }
                                        { ellps= }
                                        { units= }

  { the rest of the line contains projection specific params, example :
    proj=utm        1st line
    ellps=WGS84     2nd line
    units=m         3d line
    zone=12         projection specific parameters follows
    south=F
  }
  for cnt := 3 to FSourceProjector.Params.Count - 1 do
    sl2.Add(FSourceProjector.Params[cnt]);
  try
    if fproj.SelectCoordSystem('Select source map coordinate system', cs, sl1, sl2, false) then
    begin
      FSourceProjector.Params.Clear;
      FSourceProjector.Params.AddStrings(sl1);  // assign the basic parameters
      FSourceProjector.Params.AddStrings(sl2);  // assign the projection specific parameters
      Memo1.Lines.Assign(FSourceProjector.Params);
      ShowParams;
    end;
  finally
    sl1.Free;
    sl2.Free;
  end;
end;

procedure TfrmReproject.Button2Click(Sender: TObject);
var
  sl1, sl2: TStringList;
  cs: TEzCoordSystem;
  cnt: Integer;
begin
  FDestinProjector.CheckDefaultParams;
  cs := csProjection;
  sl1 := TStringList.Create;
  sl2 := TStringList.Create;
  sl1.Add(FDestinProjector.Params[0]);  { the first three lines contains the basic projection params :}
  sl1.Add(FDestinProjector.Params[1]);  { the projection, the ellipsoid and the units}
  sl1.Add(FDestinProjector.Params[2]);  { proj=  }
                                        { ellps= }
                                        { units= }
  { the rest of the line contains projection specific params, example :
    proj=utm        1st line
    ellps=WGS84     2nd line
    units=m         3d line
    zone=12         projection specific parameters follows
    south=F
  }
  for cnt := 3 to FDestinProjector.Params.Count - 1 do
    sl2.Add(FDestinProjector.Params[cnt]);
  try
    if fproj.SelectCoordSystem('Select destination map coordinate system', cs, sl1, sl2, false) then
    begin
      FDestinProjector.Params.Clear;
      FDestinProjector.Params.AddStrings(sl1);  // assign the basic parameters
      FDestinProjector.Params.AddStrings(sl2);  // assign the projection specific parameters
      Memo2.Lines.Assign( FDestinProjector.Params );
      ShowParams;
    end;
  finally
    sl1.Free;
    sl2.Free;
  end;
end;

procedure TfrmReproject.PageControl1Change(Sender: TObject);
var
  I: Integer;
begin
  if PageControl1.ActivePage = TabSheet3 then
  begin
    for I:= 0 to FSourceGis.Layers.Count-1 do
      FSourceGis.Layers[I].LayerInfo.Visible:= checkListBox1.Checked[I];
  end;
end;

procedure TfrmReproject.BtnConvertClick(Sender: TObject);
var
  I, J, n, NumRecs: Integer;
  DestPath, DestFileName: string;
  SrcLayer, DestLayer: TEzBaseLayer;
  FieldList: TStringList;
  Entity: TEzEntity;
  SrcPt, DestPt, Pt2: TEzPoint;
  Long, Lat: Double;
  factor: Double;
  SrcUnits, DestUnits: TEzCoordsUnits;
  SrcCoordSystem: TEzCoordSystem;
  DestCoordSystem: TEzCoordSystem;

begin
  if CboCoordSystem.ItemIndex=2 then
  begin
    Projector1.Params.Assign(Memo1.Lines);
    Projector1.CoordSysInit;
    if not Projector1.HasProjection then
      raise Exception.Create('Wrong projection parameters on source map');
  end;

  if CboDestCoordSystem.ItemIndex=2 then
  begin
    Projector2.Params.Assign(Memo2.Lines);
    Projector2.CoordSysInit;
    if not Projector2.HasProjection then
      raise Exception.Create('Wrong projection parameters on destination map');
  end;

  SrcUnits:= TEzCoordsUnits(CboCoordsUnits.ItemIndex);
  DestUnits:= TEzCoordsUnits(CboDestCoordsUnits.ItemIndex);
  SrcCoordSystem := TEzCoordSystem(CboCoordSystem.ItemIndex);
  DestCoordSystem:= TEzCoordSystem(CboDestCoordSystem.ItemIndex);

  { start the conversion process }
  ProgressBar1.visible:= true;
  DestPath:= AddSlash(Edit2.Text);
  DestFileName:= ChangeFileExt(ExtractFileName(FSourceGis.FileName),'');
  with DestinGis do
  begin
    CreateNew(DestPath + DestFileName+'_.ezm');
    MapInfo.CoordSystem:= DestCoordSystem;
    MapInfo.CoordsUnits:= DestUnits;
    ProjectionParams.Assign(Memo2.Lines);
    FieldList:= TStringList.Create;
    Screen.Cursor:=crHourglass;
    try
      for I:= 0 to checkListBox1.Items.Count-1 do
      begin
        if not checkListBox1.Checked[I] then Continue;
        SrcLayer:= FSourceGis.Layers[I];
        { extract field list from source layer }
        FieldList.Clear;
        if SrcLayer.LayerInfo.UseAttachedDB then
          SrcLayer.GetFieldList( FieldList );

        DestLayer:= Layers.CreateNewEx( DestPath + SrcLayer.Name + '_',
                                        MapInfo.CoordSystem,
                                        MapInfo.CoordsUnits,
                                        FieldList );

        { now add all entities from source layer to destination layer and
          by doing the transformation on all coordinates }
        ProgressBar1.Position:= 0;
        n:= 0;
        NumRecs:= SrcLayer.RecordCount;
        SrcLayer.First;
        while not SrcLayer.Eof do
        begin
          try
            Inc(n);
            ProgressBar1.Position:= round((n/NumRecs)*100);
            if SrcLayer.RecIsDeleted then Continue;
            Entity:= SrcLayer.RecLoadEntity;
            if Entity= nil then Continue;
            for J:= 0 to Entity.Points.Count-1 do
            begin
              SrcPt:= Entity.Points[J];
              case SrcCoordSystem of
                csCartesian:
                  case DestCoordSystem of
                    csCartesian:
                      begin
                        factor   := pj_units[SrcUnits].to_meter /
                                    pj_units[DestUnits].to_meter;
                        DestPt.X := SrcPt.X * factor;
                        DestPt.Y := SrcPt.Y * factor;
                      end;
                    csLatLon:     DestPt:= SrcPt;
                    csProjection: DestPt:= SrcPt;
                  end;
                csLatLon:
                  case DestCoordSystem of
                    csCartesian:  DestPt:= SrcPt;
                    csLatLon:     DestPt:= SrcPt;
                    csProjection:
                      Projector2.CoordSysFromLatLong(SrcPt.X, SrcPt.Y, DestPt.X, DestPt.Y);
                  end;
                csProjection:
                  case DestCoordSystem of
                    csCartesian:
                      begin
                        factor   := pj_units[SrcUnits].to_meter /
                                    pj_units[DestUnits].to_meter;
                        DestPt.X := SrcPt.X * factor;
                        DestPt.Y := SrcPt.Y * factor;
                      end;
                    csLatLon:
                      Projector2.CoordSysToLatLong(SrcPt.X, SrcPt.Y, DestPt.X, DestPt.Y);
                    csProjection:
                      begin
                        Projector1.CoordSysToLatLong(SrcPt.X, SrcPt.Y, Long, Lat);
                        Projector2.CoordSysFromLatLong(Long, Lat, DestPt.X, DestPt.Y);
                      end;
                  end;
              end;
              Entity.Points[J]:= DestPt;
            end;
            if Entity.EntityID in [idPlace] then
            begin
              SrcPt:= Entity.Points[0];
              case SrcCoordSystem of
                csCartesian:
                  case DestCoordSystem of
                    csCartesian:
                      begin
                        factor   := pj_units[SrcUnits].to_meter /
                                    pj_units[DestUnits].to_meter;
                        TEzPlace(Entity).SymbolTool.Height:= TEzPlace(Entity).Symboltool.Height * factor;
                      end;
                    csLatLon:     ;
                    csProjection: ;
                  end;
                csLatLon:
                  case DestCoordSystem of
                    csCartesian:  ;
                    csLatLon:     ;
                    csProjection:
                      TEzPlace(Entity).Symboltool.Height:=
                        Projector2.GeoDistance( SrcPt.X,
                                                  SrcPt.Y,
                                                  SrcPt.X,
                                                  SrcPt.Y + TEzPlace(Entity).Symboltool.Height);
                  end;
                csProjection:
                  case DestCoordSystem of
                    csCartesian:
                      begin
                        factor   := pj_units[SrcUnits].to_meter /
                                    pj_units[DestUnits].to_meter;
                        TEzPlace(Entity).Symboltool.Height:= TEzPlace(Entity).Symboltool.Height * factor;
                      end;
                    csLatLon:
                      begin
                        Projector2.CoordSysToLatLong(SrcPt.X, SrcPt.Y, DestPt.X, DestPt.Y);
                        Projector2.CoordSysToLatLong(SrcPt.X, SrcPt.Y + TEzPlace(Entity).Symboltool.Height, Pt2.X, Pt2.Y);
                        TEzPlace(Entity).Symboltool.Height:= Dist2D(DestPt, Pt2);
                      end;
                    csProjection:
                      begin
                        Projector1.CoordSysToLatLong(SrcPt.X, SrcPt.Y, Long, Lat);
                        Projector2.CoordSysFromLatLong(Long, Lat, DestPt.X, DestPt.Y);

                        Projector1.CoordSysToLatLong(SrcPt.X, SrcPt.Y + TEzPlace(Entity).Symboltool.Height, Long, Lat);
                        Projector2.CoordSysFromLatLong(Long, Lat, Pt2.X, Pt2.Y);
                        TEzPlace(Entity).Symboltool.Height:= Dist2D(DestPt, Pt2);
                      end;
                  end;
              end;
            end;
            DestLayer.AddEntity(Entity);
          finally
            SrcLayer.Next;
          end;
        end;
      end;
      QuickUpdateExtension;
      MapInfo.LastView:= MapInfo.Extension;
      SaveAs(DestPath + DestFileName+'.ezm');
    finally
      FieldList.Free;
      Screen.Cursor:=crDefault;
    end;
  end;
  BtnConvert.Enabled:=false;
  ProgressBar1.visible:= false;
end;

procedure TfrmReproject.CboCoordSystemClick(Sender: TObject);
begin
  Button1.Enabled:= (CboCoordSystem.ItemIndex=2);
end;

procedure TfrmReproject.CboDestCoordSystemClick(Sender: TObject);
begin
  Button2.Enabled:= (CboDestCoordSystem.ItemIndex=2);
end;

end.
