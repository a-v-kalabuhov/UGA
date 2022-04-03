unit fBlockEd;

{$I EZ_FLAG.PAS}
interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Menus, ComCtrls, Messages,
  EzLib, EzCmdLine, EzSystem, Dialogs, EzBaseGIS, EzEntities,
  EzBasicCtrls;

type
  TfrmBlocks = class(TForm)
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    New1: TMenuItem;
    Save1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Edit1: TMenuItem;
    Clear1: TMenuItem;
    Delete1: TMenuItem;
    Options1: TMenuItem;
    LineStyle1: TMenuItem;
    MenuItem1: TMenuItem;
    Orto1: TMenuItem;
    Snap1: TMenuItem;
    Scrollbars1: TMenuItem;
    Grid1: TMenuItem;
    N2: TMenuItem;
    SelectAll1: TMenuItem;
    N3: TMenuItem;
    Front1: TMenuItem;
    Back1: TMenuItem;
    N5: TMenuItem;
    FillStyle1: TMenuItem;
    Currentsymbol1: TMenuItem;
    Textstyle1: TMenuItem;
    Import1: TMenuItem;
    Panel1: TPanel;
    Label1: TLabel;
    btnSelect: TSpeedButton;
    btnRectSelect: TSpeedButton;
    btnPolyselect: TSpeedButton;
    btnCircleSelect: TSpeedButton;
    Bevel4: TBevel;
    btnPan: TSpeedButton;
    btnRealTimeZoom: TSpeedButton;
    btnZoomW: TSpeedButton;
    btnZoomAll: TSpeedButton;
    btnZoomPrev: TSpeedButton;
    btnZoomIn: TSpeedButton;
    btnZoomOut: TSpeedButton;
    Bevel5: TBevel;
    btnTofront: TSpeedButton;
    btnToback: TSpeedButton;
    Bevel6: TBevel;
    btnSave: TSpeedButton;
    Bevel7: TBevel;
    btnClose: TSpeedButton;
    Panel2: TPanel;
    btnLine: TSpeedButton;
    btnPLine: TSpeedButton;
    btnPolygon: TSpeedButton;
    btnRect: TSpeedButton;
    btnArc: TSpeedButton;
    btnEllipse: TSpeedButton;
    btnSpline: TSpeedButton;
    btnBmp: TSpeedButton;
    btnMove: TSpeedButton;
    btnScale: TSpeedButton;
    btnRotate: TSpeedButton;
    btnReshape: TSpeedButton;
    Refresh1: TMenuItem;
    Undo1: TMenuItem;
    N9: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    PopupMenu1: TPopupMenu;
    Pan2: TMenuItem;
    ZoomWindow1: TMenuItem;
    Zoom1: TMenuItem;
    ZoomAll1: TMenuItem;
    ZoomPrevious1: TMenuItem;
    ZoomIn2: TMenuItem;
    ZoomOut2: TMenuItem;
    Select2: TMenuItem;
    SelectRectangle1: TMenuItem;
    SelectCircle1: TMenuItem;
    N19: TMenuItem;
    SnapModes1: TMenuItem;
    EndOf2: TMenuItem;
    Midpoint2: TMenuItem;
    Centerpoint2: TMenuItem;
    Intersection2: TMenuItem;
    Perpend2: TMenuItem;
    ObjectStyle1: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    N27: TMenuItem;
    btnFittedText: TSpeedButton;
    SymbolsBox1: TEzSymbolsBox;
    CmdLine1: TEzCmdLine;
    HGuides: TSpeedButton;
    VGuides: TSpeedButton;
    BtnInsVertex: TSpeedButton;
    BtnDelVertex: TSpeedButton;
    btnBanner: TSpeedButton;
    btnCallout: TSpeedButton;
    btnBullet: TSpeedButton;
    BtnCircleCR: TSpeedButton;
    BtnCircle3P: TSpeedButton;
    SaveAs1: TMenuItem;
    LblBlockname: TLabel;
    Open1: TMenuItem;
    procedure Save1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Orto1Click(Sender: TObject);
    procedure Snap1Click(Sender: TObject);
    procedure Scrollbars1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure SymbolsBox1GridError(Sender: TObject);
    procedure Grid1Click(Sender: TObject);
    procedure SelectAll1Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure SymbolsBox1MouseMove2D(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; const WX, WY: Double);
    procedure Import1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormPaint(Sender: TObject);
    procedure btnLineClick(Sender: TObject);
    procedure btnPLineClick(Sender: TObject);
    procedure btnPolygonClick(Sender: TObject);
    procedure btnRectClick(Sender: TObject);
    procedure btnArcClick(Sender: TObject);
    procedure btnEllipseClick(Sender: TObject);
    procedure btnSplineClick(Sender: TObject);
    procedure btnBmpClick(Sender: TObject);
    procedure btnTextClick(Sender: TObject);
    procedure btnMoveClick(Sender: TObject);
    procedure btnScaleClick(Sender: TObject);
    procedure btnRotateClick(Sender: TObject);
    procedure btnReshapeClick(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
    procedure btnRectSelectClick(Sender: TObject);
    procedure btnPolyselectClick(Sender: TObject);
    procedure btnCircleSelectClick(Sender: TObject);
    procedure btnPanClick(Sender: TObject);
    procedure btnRealTimeZoomClick(Sender: TObject);
    procedure btnZoomWClick(Sender: TObject);
    procedure btnZoomAllClick(Sender: TObject);
    procedure btnZoomPrevClick(Sender: TObject);
    procedure btnZoomInClick(Sender: TObject);
    procedure btnZoomOutClick(Sender: TObject);
    procedure btnTofrontClick(Sender: TObject);
    procedure btnTobackClick(Sender: TObject);
    procedure btnJustifTextClick(Sender: TObject);
    procedure btnFittedTextClick(Sender: TObject);
    procedure SymbolsBox1BeginRepaint(Sender: TObject);
    procedure CmdLine1StatusMessage(Sender: TObject;
      const AMessage: String);
    procedure FormCreate(Sender: TObject);
    procedure SymbolsBox1AfterInsert(Sender: TObject; Layer: TEzBaseLayer;
      RecNo: Integer);
    procedure Refresh1Click(Sender: TObject);
    procedure Undo1Click(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure Front1Click(Sender: TObject);
    procedure Back1Click(Sender: TObject);
    procedure LineStyle1Click(Sender: TObject);
    procedure BtnInsVertexClick(Sender: TObject);
    procedure BtnDelVertexClick(Sender: TObject);
    procedure HGuidesClick(Sender: TObject);
    procedure VGuidesClick(Sender: TObject);
    procedure btnBannerClick(Sender: TObject);
    procedure btnCalloutClick(Sender: TObject);
    procedure btnBulletClick(Sender: TObject);
    procedure FillStyle1Click(Sender: TObject);
    procedure Textstyle1Click(Sender: TObject);
    procedure BtnCircle3PClick(Sender: TObject);
    procedure BtnCircleCRClick(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
  private
    { Private declarations }
    FBlock: TEzSymbol;
    FModified, FWasPainted: Boolean;
    FFileName: string;
    procedure UpdateBlock;
    procedure SaveFromMapToBlock;
    procedure ResetViewport;
    function SaveIfModified: Boolean;
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

uses
  Math, Inifiles, EzConsts, fImpTT, fLineType, fBrushStyle, fFontStyle, ezactions;

resourcestring
  SBlockEditorTitle='Block editor - [%s]';
  SBlockWereModified= 'Block have changed !' + CrLf +
                        'Do you want to save ?';
  SImportTitle= 'Import';
  SFormatPosition= '%.8n ; %.8n';
  SBlockWrong= 'Block has 0 entities and must have at least one.';

procedure TfrmBlocks.ResetViewport;
var
   Extents: TEzRect;
begin
   with SymbolsBox1 do
   begin
      PopulateFrom(FBlock);
      Extents := FBlock.Extension;
      Grapher.SetViewport(0, 0, ClientWidth, ClientHeight);
      if EqualRect2D(Extents, INVALID_EXTENSION) then
      begin
         Grapher.SetWindow(0, 100, 0, 100);
         ZoomWindow(Rect2D(0, 0, 100, 100));
      end
      else
      begin
         Grapher.SetViewport(0, 0, ClientWidth, ClientHeight);
         Grapher.SetWindow(Extents.Emin.X, Extents.Emax.X, Extents.Emin.Y, Extents.Emax.Y);
         ZoomToExtension;
      end;
   end;
   UpdateBlock;
   Caption := Format(SBlockEditorTitle, [FFileName]);
end;

procedure TfrmBlocks.Save1Click(Sender: TObject);
var
  Stream: TStream;
begin
  {*******My changes******}
  SaveFromMapToBlock;
  FBlock.Name:= 'Block';
  {*******End of my changes******}

  if (Length(FFileName) = 0) or not FileExists(AddSlash(Ez_Preferences.CommonSubDir)+FFileName) then
  begin
    SaveAs1.OnClick(nil);
    Exit;
  end;
  {SaveFromMapToBlock;
  FBlock.Name:= 'Block'; }
  Stream:= TFileStream.Create(AddSlash(Ez_Preferences.CommonSubDir)+FFileName, fmCreate);
  try
    FBlock.SaveToStream(Stream);
  finally
    Stream.Free;
  end;

  FModified := False;
end;

procedure TfrmBlocks.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmBlocks.New1Click(Sender: TObject);
begin
  FBlock.Clear;
  FBlock.Name:= 'Block';
  with SymbolsBox1 do
  begin
     CreateNewEditor;
     ZoomWindow(Rect2D(0, 0, 100, 100));
  end;
  FFileName:= '';
  LblBlockName.Caption:= '';
end;

procedure TfrmBlocks.Orto1Click(Sender: TObject);
begin
  Orto1.Checked := not Orto1.Checked;
  CmdLine1.UseOrto := Orto1.Checked;
end;

procedure TfrmBlocks.Snap1Click(Sender: TObject);
begin
  Snap1.Checked := not Snap1.Checked;
  SymbolsBox1.GridInfo.SnapToGrid:=Snap1.Checked;
end;

procedure TfrmBlocks.Scrollbars1Click(Sender: TObject);
begin
  Scrollbars1.Checked := not Scrollbars1.Checked;
  if Scrollbars1.Checked then
     SymbolsBox1.ScrollBars := ssBoth
  else
     SymbolsBox1.ScrollBars := ssNone;
end;

procedure TfrmBlocks.Delete1Click(Sender: TObject);
begin
  SymbolsBox1.DeleteSelection;
  SymbolsBox1.GIS.UpdateExtension;
  SymbolsBox1.Repaint;
end;

procedure TfrmBlocks.Clear1Click(Sender: TObject);
begin
  with SymbolsBox1 do
  begin
     Selection.Clear;
     Repaint;
  end;
end;

function TfrmBlocks.SaveIfModified: Boolean;
var
  TmpWord : Word;
begin
  Result := True;
  if FModified then
  begin
     TmpWord := Application.MessageBox(pchar(SBlockWereModified),pchar(SMsgConfirm),
        MB_YESNO or MB_ICONQUESTION);
     if TmpWord = IDYES then Save1.OnClick(Self);
     FModified := False;
  end;
end;

procedure TfrmBlocks.SymbolsBox1GridError(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := SGridTooDense;
end;

procedure TfrmBlocks.Grid1Click(Sender: TObject);
begin
  Grid1.Checked := not Grid1.Checked;
  SymbolsBox1.GridInfo.ShowGrid := Grid1.Checked;
  SymbolsBox1.Repaint;
end;

procedure TfrmBlocks.SelectAll1Click(Sender: TObject);
begin
  SymbolsBox1.SelectAll;
end;

procedure TfrmBlocks.Edit1Click(Sender: TObject);
var
  cnt: integer;
begin
  cnt := SymbolsBox1.Selection.NumSelected;
  Delete1.Enabled := cnt > 0;
  Front1.Enabled := (cnt = 1);
  Back1.Enabled := (cnt = 1);
end;

procedure TfrmBlocks.MenuItem1Click(Sender: TObject);
begin
  Grid1.Checked := SymbolsBox1.GridInfo.ShowGrid;
end;

procedure TfrmBlocks.SymbolsBox1MouseMove2D(Sender: TObject;
  Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
begin
  StatusBar1.Panels[1].Text := Format(SFormatPosition, [WX, WY]);
end;

procedure TfrmBlocks.UpdateBlock;
begin
  with SymbolsBox1 do
  begin
     Selection.Clear;
     PopulateFrom(FBlock);
     LblBlockname.Caption:= FFileName;
  end;
  Caption := Format(SBlockEditorTitle, [FFileName]);
  SymbolsBox1.ZoomToExtension;
end;

procedure TfrmBlocks.SaveFromMapToBlock;
begin
   SymbolsBox1.PopulateTo(FBlock);
end;

procedure TfrmBlocks.Import1Click(Sender: TObject);
begin
  SaveFromMapToBlock;
  with TFmImportTT.Create(Nil) do
     try
        Enter(SymbolsBox1, false);
     finally
        free;
     end;
end;

procedure TfrmBlocks.FormClose(Sender: TObject; var Action: TCloseAction);
var
  IniFile: TIniFile;
begin
  SaveFromMapToBlock;
  IniFile:= TIniFile.Create(ExtractFilePath(Application.ExeName)+'BlocksConfig.Ini');
  try
    with CmdLine1 do
    begin
       IniFile.WriteBool('Blocks','UseOrto',UseOrto);
       IniFile.WriteBool('Blocks','SnapToGrid',SymbolsBox1.GridInfo.SnapToGrid);
    end;
    IniFile.WriteBool('Blocks','ScrollBars',SymbolsBox1.ScrollBars=ssBoth);
    IniFile.WriteInteger('Blocks','Color',SymbolsBox1.Color);
    Inifile.WriteInteger('Blocks','RubberPenColor',SymbolsBox1.RubberPen.Color);;
  finally
    IniFile.Free;
  end;
  { check that the block has at least one entity }
  if FBlock.Count = 0 then
  begin
     MessageToUser(SBlockWrong, smsgerror,MB_ICONERROR);
     Action:= caNone;
     Exit;
  end;

  CmdLine1.Clear;
  if not SaveIfModified then
  begin
     Action := caNone;
     Exit;
  end;

  FBlock.Free;
end;

procedure TfrmBlocks.FormPaint(Sender: TObject);
begin
  if not FWasPainted then
  begin
     FWasPainted := True;
     ResetViewport;
  end;
end;

procedure TfrmBlocks.btnLineClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdLine,'');
end;

procedure TfrmBlocks.btnPLineClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdPolyline,'');
end;

procedure TfrmBlocks.btnPolygonClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdPolygon,'');
end;

procedure TfrmBlocks.btnRectClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdRectangle,'');
end;

procedure TfrmBlocks.btnArcClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdArc,'');
end;

procedure TfrmBlocks.btnEllipseClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdEllipse,'');
end;

procedure TfrmBlocks.btnSplineClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdSpline,'');
end;

procedure TfrmBlocks.btnBmpClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdPersistBitmap,'');
end;

procedure TfrmBlocks.btnTextClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdText,'');
end;

procedure TfrmBlocks.btnMoveClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdMove,'');
end;

procedure TfrmBlocks.btnScaleClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdScale,'');
end;

procedure TfrmBlocks.btnRotateClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdRotate,'');
end;

procedure TfrmBlocks.btnReshapeClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdReshape,'');
end;

procedure TfrmBlocks.btnSelectClick(Sender: TObject);
begin
  CmdLine1.Clear;
  SymbolsBox1.Cursor:= crDefault;
end;

procedure TfrmBlocks.btnRectSelectClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdSelect,'');
end;

procedure TfrmBlocks.btnPolyselectClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdPolygonSelect,'');
end;

procedure TfrmBlocks.btnCircleSelectClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdCircleSelect,'');
end;

procedure TfrmBlocks.btnPanClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdHandScroll,'');
end;

procedure TfrmBlocks.btnRealTimeZoomClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdRealTimeZoom,'');
end;

procedure TfrmBlocks.btnZoomWClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdZoomWindow,'');
end;

procedure TfrmBlocks.btnZoomAllClick(Sender: TObject);
begin
  SymbolsBox1.ZoomToExtension;
end;

procedure TfrmBlocks.btnZoomPrevClick(Sender: TObject);
begin
  SymbolsBox1.ZoomPrevious;
end;

procedure TfrmBlocks.btnZoomInClick(Sender: TObject);
begin
  SymbolsBox1.ZoomIn(85);
end;

procedure TfrmBlocks.btnZoomOutClick(Sender: TObject);
begin
  SymbolsBox1.ZoomOut(85);
end;

procedure TfrmBlocks.btnTofrontClick(Sender: TObject);
begin
  SymbolsBox1.BringToFront;
end;

procedure TfrmBlocks.btnTobackClick(Sender: TObject);
begin
  SymbolsBox1.SendToBack;
end;

procedure TfrmBlocks.btnJustifTextClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdJustifText,'');
end;

procedure TfrmBlocks.btnFittedTextClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdFittedText,'');
end;

procedure TfrmBlocks.SymbolsBox1BeginRepaint(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := '';
end;

procedure TfrmBlocks.CmdLine1StatusMessage(Sender: TObject;
  const AMessage: String);
begin
   StatusBar1.Panels[0].Text := AMessage;
end;

procedure TfrmBlocks.FormCreate(Sender: TObject);
var
  tm: TTextMetric;
  IniFile: TIniFile;
begin
  FBlock:= TEzSymbol.Create(Nil);

  ResetViewport;
  IniFile:= TIniFile.Create(ExtractFilePath(Application.ExeName)+'BlocksConfig.Ini');
  try
    with CmdLine1 do
    begin
       UseOrto := IniFile.ReadBool('Blocks','UseOrto',False);
       Orto1.Checked := UseOrto;
       SymbolsBox1.GridInfo.SnapToGrid:= IniFile.ReadBool('Blocks','SnapToGrid',False);
       Snap1.Checked:=SymbolsBox1.GridInfo.SnapToGrid;
    end;
    if IniFile.ReadBool('Blocks','ScrollBars',True) then
      SymbolsBox1.ScrollBars:= ssBoth
    else
      SymbolsBox1.ScrollBars:= ssNone;
    SymbolsBox1.Color:= Inifile.ReadInteger('Blocks','Color',clWindow);
    SymbolsBox1.RubberPen.Color:=clblack;
  finally
   IniFile.Free;
  end;

  with CmdLine1 do
  begin
     GetTextMetrics(Canvas.Handle, tm);
     Height := Round((tm.tmHeight + tm.tmInternalLeading)*1.5);
  end;
end;

procedure TfrmBlocks.SymbolsBox1AfterInsert(Sender: TObject;
  Layer: TEzBaseLayer; RecNo: Integer);
begin
  SymbolsBox1.GIS.UpdateExtension;
  SymbolsBox1.Repaint;
end;

procedure TfrmBlocks.Refresh1Click(Sender: TObject);
begin
  SymbolsBox1.Gis.UpdateExtension;
  SymbolsBox1.Repaint;
end;

procedure TfrmBlocks.Undo1Click(Sender: TObject);
begin
  SymbolsBox1.Undo.Undo;
  SymbolsBox1.Repaint;
end;

procedure TfrmBlocks.Cut1Click(Sender: TObject);
begin
  SymbolsBox1.Undo.CopyToClipboardFromSelection;
  SymbolsBox1.DeleteSelection;
  SymbolsBox1.Repaint;
end;

procedure TfrmBlocks.Copy1Click(Sender: TObject);
begin
  SymbolsBox1.Undo.CopyToClipboardFromSelection;
end;

procedure TfrmBlocks.Paste1Click(Sender: TObject);
begin
  SymbolsBox1.Undo.PasteFromClipboardTo;
end;

procedure TfrmBlocks.Front1Click(Sender: TObject);
begin
  SymbolsBox1.BringToFront;
end;

procedure TfrmBlocks.Back1Click(Sender: TObject);
begin
  SymbolsBox1.SendToBack;
end;


procedure TfrmBlocks.LineStyle1Click(Sender: TObject);
begin
  with TfrmLineType.create(Nil) do
    try
      Enter(SymbolsBox1);
    finally
      free;
    end;
end;

procedure TfrmBlocks.BtnInsVertexClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdInsertVertex,'');

end;

procedure TfrmBlocks.BtnDelVertexClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdDeleteVertex,'');
end;

procedure TfrmBlocks.HGuidesClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdHorzGLine,'');
end;

procedure TfrmBlocks.VGuidesClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdVertGLine,'');
end;

procedure TfrmBlocks.btnBannerClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdBannerText,'');
end;

procedure TfrmBlocks.btnCalloutClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdCalloutText,'');
end;

procedure TfrmBlocks.btnBulletClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdBulletLeader,'');
end;

procedure TfrmBlocks.FillStyle1Click(Sender: TObject);
begin
  with TfrmBrushStyle.create(Nil) do
    try
      Enter(SymbolsBox1);
    finally
      free;
    end;
end;

procedure TfrmBlocks.Textstyle1Click(Sender: TObject);
begin
  with TfrmFontStyle.create(Nil) do
    try
      Enter(self.SymbolsBox1);
    finally
      free;
    end;
end;

procedure TfrmBlocks.BtnCircle3PClick(Sender: TObject);
begin
  CmdLine1.DoCommand('CIRCLECR','');
end;

procedure TfrmBlocks.BtnCircleCRClick(Sender: TObject);
begin
  CmdLine1.DoCommand('CIRCLE3P','');
end;

procedure TfrmBlocks.Open1Click(Sender: TObject);
var
  stream: TStream;
begin
  Self.FFileName := SelectCommonElement(AddSlash(Ez_Preferences.CommonSubDir), '', liBlocks);
  If Length(Self.FFileName)=0 then exit;
  stream:= TFileStream.Create({AddSlash(Ez_Preferences.CommonSubDir)+}FFileName, fmOpenRead or fmShareDenyNone);
  try
    FBlock.LoadFromStream(stream);
  finally
    stream.free;
  end;
  UpdateBlock;
end;

procedure TfrmBlocks.SaveAs1Click(Sender: TObject);
var
  TmpFileName: string;
  stream: TStream;
begin
  TmpFileName:= InputBox('Name of block', 'Define block name :', FFileName);
  if Length(TmpFileName)=0 then Exit;
  FFileName:= TmpFileName;
  stream:= TFileStream.Create(ChangeFileExt(AddSlash(Ez_Preferences.CommonSubDir)+FFileName,'.edb'), fmCreate);
  try
    FBlock.SaveToStream(stream);
  finally
    stream.free;
  end;
end;

end.
