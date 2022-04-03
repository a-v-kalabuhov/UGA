unit fSymbEd;

{$I EZ_FLAG.PAS}
interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Menus, ComCtrls, Messages,
  EzLib, EzCmdLine, EzSystem, Dialogs, EzBaseGIS, EzEntities,
  EzBasicCtrls, Mask, EzMiscelCtrls, ActnList, ActnMan, ActnCtrls,
  ActnMenus, ImgList, ToolWin, fAccuDraw, fAccuSnap, XPStyleActnCtrls;

type
  TfrmSymbols = class(TForm)
    StatusBar1: TStatusBar;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Panel1: TPanel;
    Label1: TLabel;
    EdName: TEdit;
    Bevel2: TBevel;
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
    N22: TMenuItem;
    Osnap2: TMenuItem;
    SymbolsBox1: TEzSymbolsBox;
    CmdLine1: TEzCmdLine;
    cboSymbols: TEzSymbolsGridBox;
    ActionManager1: TActionManager;
    ActionMainMenuBar1: TActionMainMenuBar;
    actNew: TAction;
    actLoad: TAction;
    actSaveAs: TAction;
    Action4: TAction;
    Action5: TAction;
    Action6: TAction;
    Action7: TAction;
    Action8: TAction;
    Action9: TAction;
    Action10: TAction;
    Action11: TAction;
    Action12: TAction;
    Action13: TAction;
    Action14: TAction;
    Action15: TAction;
    actNewSymbol: TAction;
    Action17: TAction;
    actSave: TAction;
    Action19: TAction;
    Action20: TAction;
    Action21: TAction;
    Action22: TAction;
    Action23: TAction;
    actOrto: TAction;
    actSnap: TAction;
    actGrid: TAction;
    actScrollbars: TAction;
    ImageList1: TImageList;
    ActionToolBar1: TActionToolBar;
    ActionToolBar2: TActionToolBar;
    ActionToolBar3: TActionToolBar;
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
    actFirst: TAction;
    Action26: TAction;
    Action38: TAction;
    Action39: TAction;
    Action1: TAction;
    actAccuDraw: TAction;
    actAccuSnapShow: TAction;
    procedure SymbolsBox1GridError(Sender: TObject);
    procedure SymbolsBox1MouseMove2D(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; const WX, WY: Double);
    procedure EdNameChange(Sender: TObject);
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
    procedure cboSymbolsChange(Sender: TObject);
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
    procedure actSaveExecute(Sender: TObject);
    procedure Action4Execute(Sender: TObject);
    procedure actNewExecute(Sender: TObject);
    procedure actLoadExecute(Sender: TObject);
    procedure Action5Execute(Sender: TObject);
    procedure Action6Execute(Sender: TObject);
    procedure Action7Execute(Sender: TObject);
    procedure Action8Execute(Sender: TObject);
    procedure Action9Execute(Sender: TObject);
    procedure Action10Execute(Sender: TObject);
    procedure Action11Execute(Sender: TObject);
    procedure Action12Execute(Sender: TObject);
    procedure Action13Execute(Sender: TObject);
    procedure Action14Execute(Sender: TObject);
    procedure Action15Execute(Sender: TObject);
    procedure actNewSymbolExecute(Sender: TObject);
    procedure Action17Execute(Sender: TObject);
    procedure Action19Execute(Sender: TObject);
    procedure Action20Execute(Sender: TObject);
    procedure Action21Execute(Sender: TObject);
    procedure Action22Execute(Sender: TObject);
    procedure Action23Execute(Sender: TObject);
    procedure actOrtoExecute(Sender: TObject);
    procedure actSnapExecute(Sender: TObject);
    procedure actGridExecute(Sender: TObject);
    procedure actScrollbarsExecute(Sender: TObject);
    procedure Action40Execute(Sender: TObject);
    procedure Action41Execute(Sender: TObject);
    procedure Action42Execute(Sender: TObject);
    procedure Action43Execute(Sender: TObject);
    procedure Action44Execute(Sender: TObject);
    procedure Action45Execute(Sender: TObject);
    procedure Action46Execute(Sender: TObject);
    procedure Action47Execute(Sender: TObject);
    procedure Action48Execute(Sender: TObject);
    procedure Action49Execute(Sender: TObject);
    procedure Action50Execute(Sender: TObject);
    procedure Action51Execute(Sender: TObject);
    procedure Action52Execute(Sender: TObject);
    procedure Action53Execute(Sender: TObject);
    procedure Action54Execute(Sender: TObject);
    procedure Action55Execute(Sender: TObject);
    procedure Action56Execute(Sender: TObject);
    procedure Action57Execute(Sender: TObject);
    procedure Action58Execute(Sender: TObject);
    procedure Action59Execute(Sender: TObject);
    procedure Action9Update(Sender: TObject);
    procedure Action14Update(Sender: TObject);
    procedure actGridUpdate(Sender: TObject);
    procedure actFirstExecute(Sender: TObject);
    procedure Action26Execute(Sender: TObject);
    procedure Action38Execute(Sender: TObject);
    procedure Action39Execute(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure actAccuDrawExecute(Sender: TObject);
    procedure actAccuDrawConfigExecute(Sender: TObject);
    procedure actAccuDrawRotateExecute(Sender: TObject);
    procedure actAccuDrawUnrotateExecute(Sender: TObject);
    procedure actAccuDrawChangeOrigExecute(Sender: TObject);
    procedure actAccuSnapShowExecute(Sender: TObject);
    procedure actAccuSnapConfigExecute(Sender: TObject);
    procedure CmdLine1AccuSnapChange(Sender: TObject);
    procedure CmdLine1AccuDrawChange(Sender: TObject);
  private
    { Private declarations }
    FCurrent: Integer;
    FModified, FWasPainted: Boolean;
    FSkipChanges: Boolean;
    FfrmAccuDraw: TfrmAccuDraw;
    FfrmAccuSnap: TfrmAccuSnap;
    procedure AccuDrawFormClose(Sender: TObject);
    procedure AccusnapClose(Sender: TObject);
    procedure UpdateSymbol;
    procedure SaveFromMapToSymbol;
    procedure ResetViewport;
    function SaveIfModified: Boolean;
    procedure MyBeforePaintEntity( Sender: TObject;
                                   Layer: TEzBaseLayer;
                                   Recno: Integer;
                                   Entity: TEzEntity;
                                   Grapher: TEzGrapher;
                                   Canvas: TCanvas;
                                   const Clip: TEzRect;
                                   DrawMode: TEzDrawMode;
                                   var CanShow: Boolean;
                                   Var EntList: TEzEntityList;
                                   Var AutoFree: Boolean );
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

uses
  Math, Inifiles, EzConsts, fImpTT, fLineType, fBrushStyle, fFontStyle,
  fAccuDrawSetts, fAccuSnapSetts;

resourcestring
  SSymbolsEditorTitle='Symbols editor [%s] - Editing [%d]';
  SSymbolsWereModified= 'Symbols have changed !' + CrLf +
                        'Do you want to save ?';
  SImportTitle= 'Import';
  SFormatPosition= '%.8n ; %.8n';
  SSymbolWrong= 'Symbol No. %d has 0 entities and must have at least one.';

procedure TfrmSymbols.ResetViewport;
var
   Extents: TEzRect;
begin
   with SymbolsBox1 do
   begin
      PopulateFrom(Ez_Symbols[FCurrent]);
      Extents := Ez_Symbols[FCurrent].Extension;
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
   actFirst.OnExecute(actFirst);
   Caption := Format(SSymbolsEditorTitle, [Ez_Symbols.FileName, FCurrent]);
end;

function TfrmSymbols.SaveIfModified: Boolean;
var
  TmpWord : Word;
begin
  Result := True;
  if FModified then
  begin
     TmpWord := Application.MessageBox(pchar(SSymbolsWereModified),pchar(SMsgConfirm),
        MB_YESNO or MB_ICONQUESTION);
     if TmpWord = IDYES then actSave.OnExecute(actSave);
     FModified := False;
  end;
end;

procedure TfrmSymbols.SymbolsBox1GridError(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := SGridTooDense;
end;

procedure TfrmSymbols.SymbolsBox1MouseMove2D(Sender: TObject;
  Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
begin
  StatusBar1.Panels[1].Text := Format(SFormatPosition, [WX, WY]);
end;

procedure TfrmSymbols.UpdateSymbol;
begin
  with SymbolsBox1 do
  begin
     Selection.Clear;
     PopulateFrom(Ez_Symbols[FCurrent]);
     EdName.Text:= Ez_Symbols[FCurrent].Name;
  end;
  Caption := Format(SSymbolsEditorTitle, [Ez_Symbols.FileName, FCurrent]);
  SymbolsBox1.ZoomToExtension;
end;

procedure TfrmSymbols.SaveFromMapToSymbol;
begin
   SymbolsBox1.PopulateTo(Ez_Symbols[FCurrent]);
end;

procedure TfrmSymbols.EdNameChange(Sender: TObject);
begin
   if FSkipChanges then Exit;
   Ez_Symbols[FCurrent].Name := EdName.Text;
end;

procedure TfrmSymbols.FormClose(Sender: TObject; var Action: TCloseAction);
var
  temp: TEzSymbol;
  i: Integer;
  IniFile: TIniFile;
begin
  SaveFromMapToSymbol;
  IniFile:= TIniFile.Create(ExtractFilePath(Application.ExeName)+'Active.Ini');
  try
    with CmdLine1 do
    begin
       IniFile.WriteBool('Symbols','UseOrto',UseOrto);
       IniFile.WriteBool('Symbols','SnapToGrid',SymbolsBox1.GridInfo.SnapToGrid);
    end;
    IniFile.WriteBool('Symbols','ScrollBars',SymbolsBox1.ScrollBars=ssBoth);
    IniFile.WriteInteger('Symbols','Color',SymbolsBox1.Color);
    Inifile.WriteInteger('Symbols','RubberPenColor',SymbolsBox1.RubberPen.Color);;
  finally
    IniFile.Free;
  end;
  { check that all symbols have at least one entity }
  for i:= 0 to Ez_Symbols.Count - 1 do
  begin
     temp := Ez_Symbols[i];
     if temp.Count = 0 then
     begin
        MessageToUser(Format(SSymbolWrong,[i]), smsgerror,MB_ICONERROR);
        Action:= caNone;
        Break;
     end;
  end;

  CmdLine1.Clear;
  if not SaveIfModified then
  begin
     Action := caNone;
     Exit;
  end;
  //Action := caFree;
end;

procedure TfrmSymbols.FormPaint(Sender: TObject);
begin
  if not FWasPainted then
  begin
     FWasPainted := True;
     ResetViewport;
     //SymbolsBox1.ZoomToExtension;
  end;
end;

procedure TfrmSymbols.btnTextClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdText,'');
end;

procedure TfrmSymbols.btnJustifTextClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdJustifText,'');
end;

procedure TfrmSymbols.SymbolsBox1BeginRepaint(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := '';
end;

procedure TfrmSymbols.CmdLine1StatusMessage(Sender: TObject;
  const AMessage: String);
begin
   StatusBar1.Panels[0].Text := AMessage;
end;

procedure TfrmSymbols.FormCreate(Sender: TObject);
var
  tm: TTextMetric;
  IniFile: TIniFile;
begin
  cboSymbols.Color:= clWindow;
  SymbolsBox1.GIS.OnBeforePaintEntity:= MyBeforePaintEntity;

  ResetViewport;
  IniFile:= TIniFile.Create(ExtractFilePath(Application.ExeName)+'EzGIS.Ini');
  try
    with CmdLine1 do
    begin
       UseOrto := IniFile.ReadBool('Symbols','UseOrto',False);
       actOrto.Checked := UseOrto;
       SymbolsBox1.GridInfo.SnapToGrid:= IniFile.ReadBool('Symbols','SnapToGrid',False);
       actSnap.Checked:=SymbolsBox1.GridInfo.SnapToGrid;
    end;
    if IniFile.ReadBool('Symbols','ScrollBars',True) then
      SymbolsBox1.ScrollBars:= ssBoth
    else
      SymbolsBox1.ScrollBars:= ssNone;
    SymbolsBox1.Color:= Inifile.ReadInteger('Symbols','Color',clWindow);
    SymbolsBox1.RubberPen.Color:=clblack;
  finally
   IniFile.Free;
  end;

  with CmdLine1 do
  begin
     GetTextMetrics(Canvas.Handle, tm);
     Height := Round((tm.tmHeight + tm.tmInternalLeading)*1.5);
  end;
  //cboSymbols.Populate;
end;

procedure TfrmSymbols.SymbolsBox1AfterInsert(Sender: TObject;
  Layer: TEzBaseLayer; RecNo: Integer);
begin
  SymbolsBox1.GIS.UpdateExtension;
  SymbolsBox1.Repaint;
end;

procedure TfrmSymbols.MyBeforePaintEntity( Sender: TObject;
                                           Layer: TEzBaseLayer;
                                           Recno: Integer;
                                           Entity: TEzEntity;
                                           Grapher: TEzGrapher;
                                           Canvas: TCanvas;
                                           const Clip: TEzRect;
                                           DrawMode: TEzDrawMode;
                                           var CanShow: Boolean;
                                           Var EntList: TEzEntityList;
                                           Var AutoFree: Boolean );
begin
  //if Entity is TEzOpenedEntity then
  //  TEzOpenedEntity(Entity).PenTool.Style:=2;
end;

procedure TfrmSymbols.cboSymbolsChange(Sender: TObject);
begin
  if cboSymbols.ItemIndex < 0 then Exit;
  SaveFromMapToSymbol;
  FCurrent:=cboSymbols.ItemIndex;
  UpdateSymbol;
end;

procedure TfrmSymbols.Action28Execute(Sender: TObject);
begin
  CmdLine1.Clear;
  SymbolsBox1.Cursor:= crDefault;
end;

procedure TfrmSymbols.Action29Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdSelect,'');

end;

procedure TfrmSymbols.Action30Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdPolygonSelect,'');
end;

procedure TfrmSymbols.Action31Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdCircleSelect,'');
end;

procedure TfrmSymbols.Action32Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdHandScroll,'');
end;

procedure TfrmSymbols.Action33Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdZoomWindow,'');
end;

procedure TfrmSymbols.Action60Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdRealTimeZoom,'');
end;

procedure TfrmSymbols.Action34Execute(Sender: TObject);
begin
  SymbolsBox1.ZoomToExtension;
end;

procedure TfrmSymbols.Action35Execute(Sender: TObject);
begin
  SymbolsBox1.ZoomPrevious;
end;

procedure TfrmSymbols.Action36Execute(Sender: TObject);
begin
  SymbolsBox1.ZoomIn(85);
end;

procedure TfrmSymbols.Action37Execute(Sender: TObject);
begin
  SymbolsBox1.ZoomOut(85);
end;

procedure TfrmSymbols.actSaveExecute(Sender: TObject);
begin
  SaveFromMapToSymbol;
  Ez_Symbols.SaveAs(Ez_Symbols.FileName);

  FModified := False;
end;

procedure TfrmSymbols.Action4Execute(Sender: TObject);
begin
  Close;
end;

procedure TfrmSymbols.actNewExecute(Sender: TObject);
var
   S: TEzSymbol;
begin
   SaveFromMapToSymbol;
   if Sender = actNew then SaveIfModified;
   with Ez_Symbols do
     if Sender = actSaveAs then
     begin
        if not SaveDialog1.Execute then exit;
        SaveAs(SaveDialog1.Filename);
        Caption := Format(SSymbolsEditorTitle, [SaveDialog1.Filename,FCurrent]);
     end
     else if Sender = actNew then
     begin
        Clear;
        S:= TEzSymbol.Create(Ez_Symbols);
        S.Add(TEzRectangle.CreateEntity(Point2D(0,0),Point2D(10,10)));
        Add(S);
        FCurrent := 0;
        ResetViewport;
        actFirst.OnExecute(actFirst);
        { save new symbols file }
        if not SaveDialog1.Execute then exit;
        SaveAs(SaveDialog1.Filename);
     end;
   //cboSymbols.Populate;
end;

procedure TfrmSymbols.actLoadExecute(Sender: TObject);
begin
   SaveFromMapToSymbol;
   SaveIfModified;
   if not OpenDialog1.Execute then exit;
   Ez_Symbols.FileName:= OpenDialog1.FileName;
   Ez_Symbols.Open;
   FCurrent := 0;
   ResetViewport;
   actFirst.OnExecute(actFirst);
   //cboSymbols.Populate;
end;

procedure TfrmSymbols.Action5Execute(Sender: TObject);
begin
  SymbolsBox1.Undo.Undo;
  SymbolsBox1.Repaint;
end;

procedure TfrmSymbols.Action6Execute(Sender: TObject);
begin
  SymbolsBox1.Undo.CopyToClipboardFromSelection;
  SymbolsBox1.DeleteSelection;
  SymbolsBox1.Repaint;
end;

procedure TfrmSymbols.Action7Execute(Sender: TObject);
begin
  SymbolsBox1.Undo.CopyToClipboardFromSelection;
end;

procedure TfrmSymbols.Action8Execute(Sender: TObject);
begin
  SymbolsBox1.Undo.PasteFromClipboardTo;
end;

procedure TfrmSymbols.Action9Execute(Sender: TObject);
begin
  SymbolsBox1.DeleteSelection;
  SymbolsBox1.GIS.UpdateExtension;
  SymbolsBox1.Repaint;
end;

procedure TfrmSymbols.Action10Execute(Sender: TObject);
begin
  SymbolsBox1.SelectAll;
end;

procedure TfrmSymbols.Action11Execute(Sender: TObject);
begin
  with SymbolsBox1 do
  begin
     Selection.Clear;
     Repaint;
  end;
end;

procedure TfrmSymbols.Action12Execute(Sender: TObject);
begin
  SymbolsBox1.GroupSelection;
end;

procedure TfrmSymbols.Action13Execute(Sender: TObject);
begin
  SymbolsBox1.UnGroupSelection;
end;

procedure TfrmSymbols.Action14Execute(Sender: TObject);
begin
  SymbolsBox1.BringToFront;
end;

procedure TfrmSymbols.Action15Execute(Sender: TObject);
begin
  SymbolsBox1.SendToBack;
end;

procedure TfrmSymbols.actNewSymbolExecute(Sender: TObject);
begin
  SaveFromMapToSymbol;
  SymbolsBox1.CreateNewEditor;
  Ez_Symbols.Add(TEzSymbol.Create(Ez_Symbols));
  FCurrent := Ez_Symbols.Count - 1;
  UpdateSymbol;
  SymbolsBox1.ZoomWindow(Rect2D(0, 0, 100, 100));
  //cboSymbols.Populate;
end;

procedure TfrmSymbols.Action17Execute(Sender: TObject);
begin
   if MessageDlg('Are you sure you want to delete this symbol ?', mtConfirmation,
    [mbYes,mbNO], 0)<>mrYes then Exit;
  SaveFromMapToSymbol;
  if Ez_Symbols.Count<2 then Exit;
  SymbolsBox1.Selection.Clear;
  Ez_Symbols.Delete(FCurrent);
  if (FCurrent>0) and (FCurrent=Ez_Symbols.Count) then Dec(FCurrent);
  UpdateSymbol;
  //cboSymbols.Populate;
end;

procedure TfrmSymbols.Action19Execute(Sender: TObject);
begin
  SaveFromMapToSymbol;
  with TFmImportTT.Create(Nil) do
     try
        Enter(SymbolsBox1, true);
        //cboSymbols.Populate;
     finally
        free;
     end;
end;

procedure TfrmSymbols.Action20Execute(Sender: TObject);
begin
  with TfrmLineType.create(Nil) do
    try
      Enter(SymbolsBox1);
    finally
      free;
    end;
end;

procedure TfrmSymbols.Action21Execute(Sender: TObject);
begin
  with TfrmBrushStyle.create(Nil) do
    try
      Enter(SymbolsBox1);
    finally
      free;
    end;
end;

procedure TfrmSymbols.Action22Execute(Sender: TObject);
begin
  with TfrmFontStyle.create(Nil) do
    try
      Enter(self.SymbolsBox1);
    finally
      free;
    end;
end;

procedure TfrmSymbols.Action23Execute(Sender: TObject);
begin
  SymbolsBox1.Gis.UpdateExtension;
  SymbolsBox1.Repaint;
end;

procedure TfrmSymbols.actOrtoExecute(Sender: TObject);
begin
  actOrto.Checked := not actOrto.Checked;
  CmdLine1.UseOrto := actOrto.Checked;
end;

procedure TfrmSymbols.actSnapExecute(Sender: TObject);
begin
  actSnap.Checked := not actSnap.Checked;
  SymbolsBox1.GridInfo.SnapToGrid:=actSnap.Checked;
end;

procedure TfrmSymbols.actGridExecute(Sender: TObject);
begin
  actGrid.Checked := not actGrid.Checked;
  SymbolsBox1.GridInfo.ShowGrid := actGrid.Checked;
  SymbolsBox1.Repaint;
end;

procedure TfrmSymbols.actScrollbarsExecute(Sender: TObject);
begin
  actScrollbars.Checked := not actScrollbars.Checked;
  if actScrollbars.Checked then
     SymbolsBox1.ScrollBars := ssBoth
  else
     SymbolsBox1.ScrollBars := ssNone;
end;

procedure TfrmSymbols.Action40Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdLine,'');
end;

procedure TfrmSymbols.Action41Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdPolyline,'');
end;

procedure TfrmSymbols.Action42Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdPolygon,'');
end;

procedure TfrmSymbols.Action43Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdRectangle,'');
end;

procedure TfrmSymbols.Action44Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdArc,'');
end;

procedure TfrmSymbols.Action45Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdSpline,'');
end;

procedure TfrmSymbols.Action46Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdPersistBitmap,'');
end;

procedure TfrmSymbols.Action47Execute(Sender: TObject);
begin
  CmdLine1.DoCommand('TEXT','');
end;

procedure TfrmSymbols.Action48Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdFittedText,'');
end;

procedure TfrmSymbols.Action49Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdMove,'');
end;

procedure TfrmSymbols.Action50Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdScale,'');
end;

procedure TfrmSymbols.Action51Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdRotate,'');
end;

procedure TfrmSymbols.Action52Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdReshape,'');
end;

procedure TfrmSymbols.Action53Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdHorzGLine,'');
end;

procedure TfrmSymbols.Action54Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdVertGLine,'');
end;

procedure TfrmSymbols.Action55Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdInsertVertex,'');
end;

procedure TfrmSymbols.Action56Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdDeleteVertex,'');
end;

procedure TfrmSymbols.Action57Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdEllipse,'');
end;

procedure TfrmSymbols.Action58Execute(Sender: TObject);
begin
  CmdLine1.DoCommand('CIRCLE3P','');
end;

procedure TfrmSymbols.Action59Execute(Sender: TObject);
begin
  CmdLine1.DoCommand('CIRCLECR','');
end;

procedure TfrmSymbols.Action9Update(Sender: TObject);
begin
  (Sender as TAction).Enabled:= SymbolsBox1.Selection.NumSelected>0;
end;

procedure TfrmSymbols.Action14Update(Sender: TObject);
begin
  (Sender as TAction).Enabled:= SymbolsBox1.Selection.NumSelected=1;
end;

procedure TfrmSymbols.actGridUpdate(Sender: TObject);
begin
  actGrid.Checked := SymbolsBox1.GridInfo.ShowGrid;
end;

procedure TfrmSymbols.actFirstExecute(Sender: TObject);
begin
   if Ez_Symbols.Count = 0 then Exit;
   SaveFromMapToSymbol;
   FCurrent := 0;
   UpdateSymbol;
   cboSymbols.ItemIndex:= FCurrent;
end;

procedure TfrmSymbols.Action26Execute(Sender: TObject);
begin
  if FCurrent <= 0 then Exit;
  SaveFromMapToSymbol;
  Dec(FCurrent);
  UpdateSymbol;
  cboSymbols.ItemIndex:= FCurrent;
end;

procedure TfrmSymbols.Action38Execute(Sender: TObject);
begin
  if FCurrent >= Ez_Symbols.Count - 1 then Exit;
  SaveFromMapToSymbol;
  Inc(FCurrent);
  UpdateSymbol;
  cboSymbols.ItemIndex:= FCurrent;
end;

procedure TfrmSymbols.Action39Execute(Sender: TObject);
begin
   SaveFromMapToSymbol;
   with Ez_Symbols do
   begin
     if Count = 0 then Exit;
     FCurrent := Count - 1;
   end;
   UpdateSymbol;
   cboSymbols.ItemIndex:= FCurrent;
end;

procedure TfrmSymbols.Action1Execute(Sender: TObject);
begin
  CmdLine1.DoCommand('CIRCLE2P','');
end;

procedure TfrmSymbols.actAccuDrawExecute(Sender: TObject);
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

procedure TfrmSymbols.actAccuDrawConfigExecute(Sender: TObject);
begin
  with TfrmAccuDrawSetts.create(nil) do
    try
      if (Enter(Self.CmdLine1)=mrOk) and Self.CmdLine1.AccuDraw.Enabled then
        SymbolsBox1.Refresh;
    finally
      free;
    end;
end;

procedure TfrmSymbols.actAccuDrawRotateExecute(Sender: TObject);
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

procedure TfrmSymbols.actAccuDrawUnrotateExecute(Sender: TObject);
begin
  CmdLine1.AccuDraw.ShowUnrotated;
end;

procedure TfrmSymbols.actAccuDrawChangeOrigExecute(Sender: TObject);
begin
  { the AccuDraw origin will be defined to the last position on the draw box
    ( If AccuDraw is not visible, the command will be ignored )
  }
  CmdLine1.AccuDraw.ChangeOrigin( CmdLine1.GetSnappedPoint );
  { you also can define like this in order to preserve AccuDraw current rotation angle
    (Angle is an optional parameter with default value 0 ) }
  //CmdLine1.AccuDraw.ChangeOrigin( CmdLine1.CurrentSnappedPoint, CmdLine1.AccuDraw.Rotangle );
end;

procedure TfrmSymbols.actAccuSnapShowExecute(Sender: TObject);
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

procedure TfrmSymbols.actAccuSnapConfigExecute(Sender: TObject);
begin
  with TfrmAccuSnapSetts.create(nil) do
    try
      If (Enter(Self.CmdLine1)=mrOk) And Assigned(FfrmAccuSnap) Then
        FfrmAccuSnap.Reset;
    finally
      free;
    end;
end;

procedure TfrmSymbols.AccuDrawFormClose(Sender: TObject);
begin
  FfrmAccuDraw:= Nil;
  actAccuDraw.Checked:= False;
end;

procedure TfrmSymbols.AccusnapClose(Sender: TObject);
begin
  FfrmAccuSnap:= Nil;
  actAccuSnapShow.Checked:= False;
end;

procedure TfrmSymbols.CmdLine1AccuSnapChange(Sender: TObject);
begin
  if FfrmAccuSnap=nil then Exit;
  FfrmAccuSnap.ResetToDefault;
end;

procedure TfrmSymbols.CmdLine1AccuDrawChange(Sender: TObject);
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

end.
