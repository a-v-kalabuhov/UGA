unit fBlockEd;

{$I EZ_FLAG.PAS}
interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Menus, ComCtrls, Messages,
  EzLib, EzCmdLine, EzSystem, Dialogs, EzBaseGIS, EzEntities,
  EzBasicCtrls, ActnCtrls, ToolWin, ActnMan, ActnMenus, ImgList, ActnList,
  fAccuDraw, fAccuSnap, XPStyleActnCtrls;

type
  TfrmBlocks = class(TForm)
    StatusBar1: TStatusBar;
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
    SymbolsBox1: TEzSymbolsBox;
    CmdLine1: TEzCmdLine;
    ActionManager1: TActionManager;
    actNew: TAction;
    actLoad: TAction;
    actSave: TAction;
    Action4: TAction;
    Action5: TAction;
    Action6: TAction;
    Action7: TAction;
    Action8: TAction;
    Action9: TAction;
    Action10: TAction;
    Action11: TAction;
    Action14: TAction;
    Action15: TAction;
    Action20: TAction;
    Action21: TAction;
    Action22: TAction;
    Action23: TAction;
    actOrto: TAction;
    actSnap: TAction;
    actGrid: TAction;
    actScrollbars: TAction;
    Action28: TAction;
    Action29: TAction;
    Action30: TAction;
    Action31: TAction;
    Action32: TAction;
    Action33: TAction;
    Action34: TAction;
    Action35: TAction;
    Action36: TAction;
    Action37: TAction;
    Action40: TAction;
    Action41: TAction;
    Action42: TAction;
    Action43: TAction;
    Action44: TAction;
    Action45: TAction;
    Action46: TAction;
    Action47: TAction;
    Action48: TAction;
    Action49: TAction;
    Action50: TAction;
    Action51: TAction;
    Action52: TAction;
    Action53: TAction;
    Action54: TAction;
    Action55: TAction;
    Action56: TAction;
    Action57: TAction;
    Action58: TAction;
    Action59: TAction;
    Action60: TAction;
    Action1: TAction;
    actAccuSnapShow: TAction;
    actAccuSnapConfig: TAction;
    actAccuDraw: TAction;
    actAccuDrawConfig: TAction;
    actAccuDrawRotate: TAction;
    actAccuDrawUnrotate: TAction;
    actAccuDrawChangeOrig: TAction;
    ImageList1: TImageList;
    ActionMainMenuBar1: TActionMainMenuBar;
    ActionToolBar1: TActionToolBar;
    ActionToolBar2: TActionToolBar;
    ActionToolBar3: TActionToolBar;
    actSaveAs: TAction;
    Action3: TAction;
    procedure Orto1Click(Sender: TObject);
    procedure Snap1Click(Sender: TObject);
    procedure Scrollbars1Click(Sender: TObject);
    procedure SymbolsBox1GridError(Sender: TObject);
    procedure Grid1Click(Sender: TObject);
    procedure SymbolsBox1MouseMove2D(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; const WX, WY: Double);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormPaint(Sender: TObject);
    procedure btnTextClick(Sender: TObject);
    procedure btnJustifTextClick(Sender: TObject);
    procedure SymbolsBox1BeginRepaint(Sender: TObject);
    procedure CmdLine1StatusMessage(Sender: TObject;
      const AMessage: String);
    procedure FormCreate(Sender: TObject);
    procedure SymbolsBox1AfterInsert(Sender: TObject; Layer: TEzBaseLayer;
      RecNo: Integer);
    procedure Refresh1Click(Sender: TObject);
    procedure btnBannerClick(Sender: TObject);
    procedure btnCalloutClick(Sender: TObject);
    procedure btnBulletClick(Sender: TObject);
    procedure actNewExecute(Sender: TObject);
    procedure actLoadExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actSaveAsExecute(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
    procedure Action4Execute(Sender: TObject);
    procedure Action5Execute(Sender: TObject);
    procedure Action6Execute(Sender: TObject);
    procedure Action7Execute(Sender: TObject);
    procedure Action8Execute(Sender: TObject);
    procedure Action9Execute(Sender: TObject);
    procedure Action10Execute(Sender: TObject);
    procedure Action11Execute(Sender: TObject);
    procedure Action14Execute(Sender: TObject);
    procedure Action15Execute(Sender: TObject);
    procedure Action20Execute(Sender: TObject);
    procedure Action21Execute(Sender: TObject);
    procedure Action22Execute(Sender: TObject);
    procedure Action28Execute(Sender: TObject);
    procedure Action29Execute(Sender: TObject);
    procedure Action30Execute(Sender: TObject);
    procedure Action31Execute(Sender: TObject);
    procedure Action32Execute(Sender: TObject);
    procedure Action33Execute(Sender: TObject);
    procedure Action60Execute(Sender: TObject);
    procedure Action34Execute(Sender: TObject);
    procedure Action35Execute(Sender: TObject);
    procedure Action36Execute(Sender: TObject);
    procedure Action37Execute(Sender: TObject);
    procedure Action40Execute(Sender: TObject);
    procedure Action41Execute(Sender: TObject);
    procedure Action42Execute(Sender: TObject);
    procedure Action43Execute(Sender: TObject);
    procedure Action44Execute(Sender: TObject);
    procedure Action45Execute(Sender: TObject);
    procedure Action46Execute(Sender: TObject);
    procedure Action48Execute(Sender: TObject);
    procedure Action57Execute(Sender: TObject);
    procedure Action58Execute(Sender: TObject);
    procedure Action59Execute(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure Action49Execute(Sender: TObject);
    procedure Action50Execute(Sender: TObject);
    procedure Action51Execute(Sender: TObject);
    procedure Action52Execute(Sender: TObject);
    procedure Action53Execute(Sender: TObject);
    procedure Action54Execute(Sender: TObject);
    procedure Action55Execute(Sender: TObject);
    procedure Action56Execute(Sender: TObject);
    procedure actAccuDrawExecute(Sender: TObject);
    procedure actAccuDrawConfigExecute(Sender: TObject);
    procedure actAccuDrawRotateExecute(Sender: TObject);
    procedure actAccuDrawUnrotateExecute(Sender: TObject);
    procedure actAccuDrawChangeOrigExecute(Sender: TObject);
    procedure actAccuSnapShowExecute(Sender: TObject);
    procedure actAccuSnapConfigExecute(Sender: TObject);
    procedure CmdLine1AccuDrawChange(Sender: TObject);
    procedure CmdLine1AccuSnapChange(Sender: TObject);
    procedure Action9Update(Sender: TObject);
    procedure Action14Update(Sender: TObject);
    procedure Action15Update(Sender: TObject);
    procedure actGridUpdate(Sender: TObject);
  private
    { Private declarations }
    FBlock: TEzSymbol;
    FModified, FWasPainted: Boolean;
    FFileName: string;
    FfrmAccuDraw: TfrmAccuDraw;
    FfrmAccuSnap: TfrmAccuSnap;
    procedure AccuDrawFormClose(Sender: TObject);
    procedure AccusnapClose(Sender: TObject);
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
  Math, Inifiles, EzActions, EzConsts, fImpTT, fLineType, fBrushStyle, fFontStyle,
  fAccuDrawSetts, fAccuSnapSetts;

resourcestring
  SBlockEditorTitle='Block editor - [%s]';
  SBlockWereModified= 'Block has changed !' + CrLf +
                        'Do you want to save ?';
  SImportTitle= 'Import';
  SFormatPosition= '%.8n ; %.8n';
  SBlockWrong= 'Block have 0 entities and must have at least one.';

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

procedure TfrmBlocks.Orto1Click(Sender: TObject);
begin
  CmdLine1.UseOrto := actOrto.Checked;
end;

procedure TfrmBlocks.Snap1Click(Sender: TObject);
begin
  SymbolsBox1.GridInfo.SnapToGrid:=actSnap.Checked;
end;

procedure TfrmBlocks.Scrollbars1Click(Sender: TObject);
begin
  if actScrollbars.Checked then
     SymbolsBox1.ScrollBars := ssBoth
  else
     SymbolsBox1.ScrollBars := ssNone;
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
     if TmpWord = IDYES then actSave.OnExecute(actSave);
     FModified := False;
  end;
end;

procedure TfrmBlocks.SymbolsBox1GridError(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := SGridTooDense;
end;

procedure TfrmBlocks.Grid1Click(Sender: TObject);
begin
  SymbolsBox1.GridInfo.ShowGrid := actGrid.Checked;
  SymbolsBox1.Repaint;
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
  end;
  Caption := Format(SBlockEditorTitle, [FFileName]);
  SymbolsBox1.ZoomToExtension;
end;

procedure TfrmBlocks.SaveFromMapToBlock;
begin
   SymbolsBox1.PopulateTo(FBlock);
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
  if (FBlock.Count = 0) And (Length(FFileName)>0) then
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

procedure TfrmBlocks.btnTextClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdText,'');
end;

procedure TfrmBlocks.btnJustifTextClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdJustifText,'');
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
       actOrto.Checked := UseOrto;
       SymbolsBox1.GridInfo.SnapToGrid:= IniFile.ReadBool('Blocks','SnapToGrid',False);
       actSnap.Checked:=SymbolsBox1.GridInfo.SnapToGrid;
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

procedure TfrmBlocks.actNewExecute(Sender: TObject);
begin
  FBlock.Clear;
  FBlock.Name:= 'Block';
  with SymbolsBox1 do
  begin
     CreateNewEditor;
     ZoomWindow(Rect2D(0, 0, 100, 100));
  end;
  FFileName:= '';
end;

procedure TfrmBlocks.actLoadExecute(Sender: TObject);
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

procedure TfrmBlocks.actSaveExecute(Sender: TObject);
var
  Stream: TStream;
begin
  SaveFromMapToBlock;
  FBlock.Name:= 'Block';
  if (Length(FFileName) = 0) or not FileExists(AddSlash(Ez_Preferences.CommonSubDir)+FFileName) then
  begin
    actSaveAs.OnExecute(actSaveAs);
    Exit;
  end;
  Stream:= TFileStream.Create(AddSlash(Ez_Preferences.CommonSubDir)+FFileName, fmCreate);
  try
    FBlock.SaveToStream(Stream);
  finally
    Stream.Free;
  end;

  FModified := False;
end;

procedure TfrmBlocks.actSaveAsExecute(Sender: TObject);
var
  TmpFileName: string;
  stream: TStream;
begin
  TmpFileName:= InputBox('Name of block', 'Define block name :', ChangeFileExt(ExtractFileName(FFileName),''));
  if Length(TmpFileName)=0 then Exit;
  FFileName:= ExtractFileName(TmpFileName);
  stream:= TFileStream.Create(ChangeFileExt(AddSlash(Ez_Preferences.CommonSubDir)+FFileName,'.edb'), fmCreate);
  try
    FBlock.SaveToStream(stream);
  finally
    stream.free;
  end;
end;

procedure TfrmBlocks.Action3Execute(Sender: TObject);
begin
  SaveFromMapToBlock;
  with TFmImportTT.Create(Nil) do
     try
        Enter(SymbolsBox1, false);
     finally
        free;
     end;
end;

procedure TfrmBlocks.Action4Execute(Sender: TObject);
begin
  Close;
end;

procedure TfrmBlocks.Action5Execute(Sender: TObject);
begin
  SymbolsBox1.Undo.Undo;
  SymbolsBox1.Repaint;
end;

procedure TfrmBlocks.Action6Execute(Sender: TObject);
begin
  SymbolsBox1.Undo.CopyToClipboardFromSelection;
  SymbolsBox1.DeleteSelection;
  SymbolsBox1.Repaint;
end;

procedure TfrmBlocks.Action7Execute(Sender: TObject);
begin
  SymbolsBox1.Undo.CopyToClipboardFromSelection;
end;

procedure TfrmBlocks.Action8Execute(Sender: TObject);
begin
  SymbolsBox1.Undo.PasteFromClipboardTo;
end;

procedure TfrmBlocks.Action9Execute(Sender: TObject);
begin
  SymbolsBox1.DeleteSelection;
  SymbolsBox1.GIS.UpdateExtension;
  SymbolsBox1.Repaint;
end;

procedure TfrmBlocks.Action10Execute(Sender: TObject);
begin
  SymbolsBox1.SelectAll;
end;

procedure TfrmBlocks.Action11Execute(Sender: TObject);
begin
  with SymbolsBox1 do
  begin
     Selection.Clear;
     Repaint;
  end;
end;

procedure TfrmBlocks.Action14Execute(Sender: TObject);
begin
  SymbolsBox1.BringToFront;
end;

procedure TfrmBlocks.Action15Execute(Sender: TObject);
begin
  SymbolsBox1.SendToBack;
end;

procedure TfrmBlocks.Action20Execute(Sender: TObject);
begin
  with TfrmLineType.create(Nil) do
    try
      Enter(SymbolsBox1);
    finally
      free;
    end;
end;

procedure TfrmBlocks.Action21Execute(Sender: TObject);
begin
  with TfrmBrushStyle.create(Nil) do
    try
      Enter(SymbolsBox1);
    finally
      free;
    end;
end;

procedure TfrmBlocks.Action22Execute(Sender: TObject);
begin
  with TfrmFontStyle.create(Nil) do
    try
      Enter(self.SymbolsBox1);
    finally
      free;
    end;
end;

procedure TfrmBlocks.Action28Execute(Sender: TObject);
begin
  CmdLine1.Clear;
  SymbolsBox1.Cursor:= crDefault;
end;

procedure TfrmBlocks.Action29Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdSelect,'');
end;

procedure TfrmBlocks.Action30Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdPolygonSelect,'');
end;

procedure TfrmBlocks.Action31Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdCircleSelect,'');
end;

procedure TfrmBlocks.Action32Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdHandScroll,'');
end;

procedure TfrmBlocks.Action33Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdZoomWindow,'');
end;

procedure TfrmBlocks.Action60Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdRealTimeZoom,'');
end;

procedure TfrmBlocks.Action34Execute(Sender: TObject);
begin
  SymbolsBox1.ZoomToExtension;
end;

procedure TfrmBlocks.Action35Execute(Sender: TObject);
begin
  SymbolsBox1.ZoomPrevious;
end;

procedure TfrmBlocks.Action36Execute(Sender: TObject);
begin
  SymbolsBox1.ZoomIn(85);
end;

procedure TfrmBlocks.Action37Execute(Sender: TObject);
begin
  SymbolsBox1.ZoomOut(85);
end;

procedure TfrmBlocks.Action40Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdLine,'');
end;

procedure TfrmBlocks.Action41Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdPolyline,'');
end;

procedure TfrmBlocks.Action42Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdPolygon,'');
end;

procedure TfrmBlocks.Action43Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdRectangle,'');
end;

procedure TfrmBlocks.Action44Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdArc,'');
end;

procedure TfrmBlocks.Action45Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdSpline,'');
end;

procedure TfrmBlocks.Action46Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdPersistBitmap,'');
end;

procedure TfrmBlocks.Action48Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdFittedText,'');
end;

procedure TfrmBlocks.Action57Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdEllipse,'');
end;

procedure TfrmBlocks.Action58Execute(Sender: TObject);
begin
  CmdLine1.DoCommand('CIRCLE3P','');
end;

procedure TfrmBlocks.Action59Execute(Sender: TObject);
begin
  CmdLine1.DoCommand('CIRCLECR','');
end;

procedure TfrmBlocks.Action1Execute(Sender: TObject);
begin
  CmdLine1.DoCommand('CIRCLE2P','');
end;

procedure TfrmBlocks.Action49Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdMove,'');
end;

procedure TfrmBlocks.Action50Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdScale,'');
end;

procedure TfrmBlocks.Action51Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdRotate,'');
end;

procedure TfrmBlocks.Action52Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdReshape,'');
end;

procedure TfrmBlocks.Action53Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdHorzGLine,'');
end;

procedure TfrmBlocks.Action54Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdVertGLine,'');
end;

procedure TfrmBlocks.Action55Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdInsertVertex,'');
end;

procedure TfrmBlocks.Action56Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdDeleteVertex,'');
end;

procedure TfrmBlocks.actAccuDrawExecute(Sender: TObject);
var
  p: TPoint;
begin
  If actAccuDraw.Checked then
  begin
    If FfrmAccuDraw = Nil then
    begin
      fAccuDraw.AccuDrawParent:= Self.Handle;
      FfrmAccuDraw := TfrmAccuDraw.Create(Nil);
      FfrmAccuDraw.OnThisClose:= Self.AccuDrawFormClose;
      p:= Self.ClientToScreen(Point(SymbolsBox1.Left,SymbolsBox1.Top));
      FfrmAccuDraw.Left:= p.X;
      FfrmAccuDraw.Top:= p.Y;
    end;

    If CmdLine1.AccuDraw.FrameStyle=fsPolar then
      FfrmAccuDraw.BtnPolar.Down:= true
    else If CmdLine1.AccuDraw.FrameStyle=fsRectangular then
      FfrmAccuDraw.BtnRect.Down:= true;
    with FfrmAccuDraw do
    begin
      NumEd1.NumericValue:= 0;
      NumEd2.NumericValue:= 0;
      chkX.Checked:= false;
      chkY.Checked:= false;
    end;
    FfrmAccuDraw.Enter(Self.CmdLine1);
    Windows.SetFocus( Self.Handle );
  end else If Assigned(FfrmAccuDraw) then
    FreeAndNil(FfrmAccuDraw);
end;

procedure TfrmBlocks.actAccuDrawConfigExecute(Sender: TObject);
begin
  with TfrmAccuDrawSetts.create(nil) do
    try
      if (Enter(Self.CmdLine1)=mrOk) and Self.CmdLine1.AccuDraw.Enabled then
        SymbolsBox1.Refresh;
    finally
      free;
    end;
end;

procedure TfrmBlocks.actAccuDrawRotateExecute(Sender: TObject);
var
  Code: Integer;
  S: string;
  Rot:Double;
begin
  S:= InputBox( 'Rotate AccuDraw', 'Rotation angle', FloatToStr( RadToDeg(CmdLine1.AccuDraw.Rotangle) ));
  If S='' then Exit;
  Val(S, Rot, Code);
  If Code<>0 then Exit;
  CmdLine1.AccuDraw.ChangeOrigin( CmdLine1.AccuDraw.AccuOrigin, DegToRad(Rot) );
end;

procedure TfrmBlocks.actAccuDrawUnrotateExecute(Sender: TObject);
begin
  CmdLine1.AccuDraw.ShowUnrotated;
end;

procedure TfrmBlocks.actAccuDrawChangeOrigExecute(Sender: TObject);
begin
  { the AccuDraw origin will be defined to the last position on the draw box
    ( If AccuDraw is not visible, the command will be ignored )
  }
  CmdLine1.AccuDraw.ChangeOrigin( CmdLine1.GetSnappedPoint );
  { you also can define like this in order to preserve AccuDraw current rotation angle
    (Angle is an optional parameter with default value 0 ) }
  //CmdLine1.AccuDraw.ChangeOrigin( CmdLine1.CurrentSnappedPoint, CmdLine1.AccuDraw.Rotangle );
end;

procedure TfrmBlocks.actAccuSnapShowExecute(Sender: TObject);
var
  p: TPoint;
begin
  if actAccuSnapShow.Checked then
  begin
    { create the aerial view }
    if FfrmAccuSnap=nil then
    begin
      fAccuSnap.AccuSnapParent:= Self.Handle;
      FfrmAccuSnap:= TfrmAccuSnap.Create(Nil);
      FfrmAccuSnap.OnThisClose:= Self.AccusnapClose;
    end;
    if FFrmAccuDraw<>Nil then
    begin
      FfrmAccuSnap.Left:= FfrmAccuDraw.Left;
      FfrmAccuSnap.Top:= FfrmAccuDraw.Top + FfrmAccuDraw.Height;
    end else
    begin
      fAccuDraw.AccuDrawParent:= Self.Handle;
      FfrmAccuDraw := TfrmAccuDraw.Create(Nil);
      p:= Self.ClientToScreen(Point(SymbolsBox1.Left,SymbolsBox1.Top));
      FfrmAccuSnap.Left:= p.x;
      FfrmAccuSnap.Top:= p.y + FfrmAccuDraw.Height;
      FreeAndNil( FfrmAccuDraw  );
    end;
    FfrmAccuSnap.Enter(Self.CmdLine1);
    ActiveControl:= SymbolsBox1;
  end else if Assigned( FfrmAccuSnap ) then
    FreeAndNil( FfrmAccuSnap );
end;

procedure TfrmBlocks.actAccuSnapConfigExecute(Sender: TObject);
begin
  with TfrmAccuSnapSetts.create(nil) do
    try
      If (Enter(Self.CmdLine1)=mrOk) And Assigned(FfrmAccuSnap) Then
        FfrmAccuSnap.Reset;
    finally
      free;
    end;
end;

procedure TfrmBlocks.AccuDrawFormClose(Sender: TObject);
begin
  FfrmAccuDraw:= Nil;
  actAccuDraw.Checked:= False;
end;

procedure TfrmBlocks.AccusnapClose(Sender: TObject);
begin
  FfrmAccuSnap:= Nil;
  actAccuSnapShow.Checked:= False;
end;

procedure TfrmBlocks.CmdLine1AccuDrawChange(Sender: TObject);
var
  DX,DY: Double;
begin
  If FfrmAccuDraw=Nil Then Exit;
  FfrmAccuDraw.InUpdate:= True;
  try
    with FfrmAccuDraw, CmdLine1.AccuDraw do
    begin
      If FrameStyle = fsPolar then
      begin
        Label1.Caption:= 'Delta X: ';
        Label2.Caption:= 'Delta Y: ';
      end else
      begin
        Label1.Caption:= 'Distance: ';
        Label2.Caption:= 'Angle   : ';
      end;

      CmdLine1.AccuDraw.CurrentDimensions( DX, DY );
      NumEd1.NumericValue:= DX;   // delta x or distance
      If FrameStyle = fsRectangular Then  // delta y or angle
        NumEd2.NumericValue:= DY
      else
        NumEd2.NumericValue:= RadToDeg( DY );
      ChkX.Checked:= DeltaXLocked;
      ChkY.Checked:= DeltaYLocked;
    end;
  finally
    FfrmAccuDraw.InUpdate:= False;
  end;
end;

procedure TfrmBlocks.CmdLine1AccuSnapChange(Sender: TObject);
begin
  if FfrmAccuSnap=nil then Exit;
  FfrmAccuSnap.ResetToDefault;
end;

procedure TfrmBlocks.Action9Update(Sender: TObject);
begin
  Action9.Enabled:= SymbolsBox1.Selection.NumSelected>0;
end;

procedure TfrmBlocks.Action14Update(Sender: TObject);
begin
  Action14.Enabled:= SymbolsBox1.Selection.NumSelected=1;
end;

procedure TfrmBlocks.Action15Update(Sender: TObject);
begin
  Action15.Enabled:= SymbolsBox1.Selection.NumSelected=1;
end;

procedure TfrmBlocks.actGridUpdate(Sender: TObject);
begin
  actGrid.Checked:= SymbolsBox1.GridInfo.ShowGrid;
end;

end.
