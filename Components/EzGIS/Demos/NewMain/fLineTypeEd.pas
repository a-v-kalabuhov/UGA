unit fLineTypeEd;

{$I EZ_FLAG.PAS}
interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Menus, ComCtrls, Messages,
  EzLib, EzCmdLine, EzSystem, Dialogs, EzBaseGIS, EzEntities,
  EzBasicCtrls, ActnCtrls, ActnMan, ActnMenus, ImgList, ActnList, ToolWin,
  fAccuDraw, fAccuSnap, XPStyleActnCtrls;

type
  TfrmLinetypes = class(TForm)
    StatusBar1: TStatusBar;
    CmdLine1: TEzCmdLine;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    SymbolsBox1: TEzSymbolsBox;
    Panel1: TPanel;
    Label1: TLabel;
    EdName: TEdit;
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
    Preferences2: TMenuItem;
    OpenDialog2: TOpenDialog;
    ActionManager1: TActionManager;
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
    Action28: TAction;
    Action29: TAction;
    Action30: TAction;
    Action31: TAction;
    Action32: TAction;
    Action33: TAction;
    actZoomAll: TAction;
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
    ImageList1: TImageList;
    ActionMainMenuBar1: TActionMainMenuBar;
    ActionToolBar1: TActionToolBar;
    ActionToolBar2: TActionToolBar;
    ActionToolBar3: TActionToolBar;
    actVisible: TAction;
    actInvisible: TAction;
    Action16: TAction;
    actAccuDraw: TAction;
    actAccuSnapShow: TAction;
    procedure SymbolsBox1GridError(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure Preferences1Click(Sender: TObject);
    procedure SymbolsBox1MouseMove2D(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; const WX, WY: Double);
    procedure EdNameChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CmdLine1StatusMessage(Sender: TObject; const Message: String);
    procedure Options1Click(Sender: TObject);
    procedure Palettemanager1Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure SymbolsBox1BeginRepaint(Sender: TObject);
    procedure Osnap2Click(Sender: TObject);
    procedure Preferences2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actNewExecute(Sender: TObject);
    procedure actLoadExecute(Sender: TObject);
    procedure Action4Execute(Sender: TObject);
    procedure Action9Execute(Sender: TObject);
    procedure Action10Execute(Sender: TObject);
    procedure Action11Execute(Sender: TObject);
    procedure Action5Execute(Sender: TObject);
    procedure Action6Execute(Sender: TObject);
    procedure Action7Execute(Sender: TObject);
    procedure Action8Execute(Sender: TObject);
    procedure Action12Execute(Sender: TObject);
    procedure Action14Execute(Sender: TObject);
    procedure Action15Execute(Sender: TObject);
    procedure Action13Execute(Sender: TObject);
    procedure actNewSymbolExecute(Sender: TObject);
    procedure Action17Execute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure Action19Execute(Sender: TObject);
    procedure actFirstExecute(Sender: TObject);
    procedure Action26Execute(Sender: TObject);
    procedure Action38Execute(Sender: TObject);
    procedure Action39Execute(Sender: TObject);
    procedure Action20Execute(Sender: TObject);
    procedure Action21Execute(Sender: TObject);
    procedure Action22Execute(Sender: TObject);
    procedure actOrtoExecute(Sender: TObject);
    procedure actSnapExecute(Sender: TObject);
    procedure actGridExecute(Sender: TObject);
    procedure actScrollbarsExecute(Sender: TObject);
    procedure Action23Execute(Sender: TObject);
    procedure Action28Execute(Sender: TObject);
    procedure Action29Execute(Sender: TObject);
    procedure Action30Execute(Sender: TObject);
    procedure Action31Execute(Sender: TObject);
    procedure Action32Execute(Sender: TObject);
    procedure Action33Execute(Sender: TObject);
    procedure Action60Execute(Sender: TObject);
    procedure actZoomAllExecute(Sender: TObject);
    procedure Action35Execute(Sender: TObject);
    procedure Action36Execute(Sender: TObject);
    procedure Action37Execute(Sender: TObject);
    procedure actVisibleExecute(Sender: TObject);
    procedure Action16Execute(Sender: TObject);
    procedure Action40Execute(Sender: TObject);
    procedure Action41Execute(Sender: TObject);
    procedure Action42Execute(Sender: TObject);
    procedure Action43Execute(Sender: TObject);
    procedure Action44Execute(Sender: TObject);
    procedure Action45Execute(Sender: TObject);
    procedure Action46Execute(Sender: TObject);
    procedure Action57Execute(Sender: TObject);
    procedure Action58Execute(Sender: TObject);
    procedure Action59Execute(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure Action48Execute(Sender: TObject);
    procedure Action49Execute(Sender: TObject);
    procedure Action50Execute(Sender: TObject);
    procedure Action51Execute(Sender: TObject);
    procedure Action52Execute(Sender: TObject);
    procedure Action53Execute(Sender: TObject);
    procedure Action54Execute(Sender: TObject);
    procedure Action55Execute(Sender: TObject);
    procedure Action56Execute(Sender: TObject);
    procedure Action9Update(Sender: TObject);
    procedure Action14Update(Sender: TObject);
    procedure actAccuDrawExecute(Sender: TObject);
    procedure actAccuDrawConfigExecute(Sender: TObject);
    procedure actAccuDrawRotateExecute(Sender: TObject);
    procedure actAccuDrawUnrotateExecute(Sender: TObject);
    procedure actAccuDrawChangeOrigExecute(Sender: TObject);
    procedure actAccuSnapShowExecute(Sender: TObject);
    procedure actAccuSnapConfigExecute(Sender: TObject);
  private
    { Private declarations }
    FCurrent: Integer;
    FModified, FWasPainted: Boolean;
    FSkipChanges: Boolean;
    FFirstTimeHere:Boolean;

    FfrmAccuDraw: TfrmAccuDraw;
    FfrmAccuSnap: TfrmAccuSnap;
    procedure AccuDrawFormClose(Sender: TObject);
    procedure AccusnapClose(Sender: TObject);

    procedure UpdateLinetype;
    procedure SaveFromMapToLinetype;
    procedure ResetView;
    function SaveIfModified: Boolean;
    Procedure MyBeforePaintLayer( Sender: TObject;
      Layer: TEzBaseLayer;
      Grapher: TEzGrapher;
      Var CanShow: Boolean;
      Var WasFiltered: Boolean;
      Var EntList: TEzEntityList;
      Var AutoFree: Boolean );
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
  Math, Inifiles, EzConsts, ezbase, fLineType, fBrushStyle, fFontStyle,
  fAccuDrawSetts, fAccuSnapSetts;

resourcestring
  SLinetypesEditorTitle='Linetypes editor [%s] - Editing [%d]';
  SLinetypesWereModified= 'Linetypes have changed !' + CrLf +
                          'Do you want to save ?';
  SImportTitle= 'Import';
  SFormatPosition= '%.8n ; %.8n';
  SLinetypeWrong= 'Linetype No. %d has 0 entities and must have at least one.';

procedure TfrmLinetypes.ResetView;
var
   Extents: TEzRect;
begin
   with SymbolsBox1 do
   begin
      PopulateFrom(Ez_LineTypes[FCurrent]);
      Extents := Ez_LineTypes[FCurrent].Extension;
      Grapher.SetViewport(0, 0, ClientWidth, ClientHeight);
      if EqualRect2D(Extents, INVALID_EXTENSION) then
      begin
         Grapher.SetWindow(0, 10, 0, 10);
         ZoomWindow(Rect2D(0, 0, 10, 10));
      end
      else
      begin
         Grapher.SetViewport(0, 0, ClientWidth, ClientHeight);
         Grapher.SetWindow(Extents.Emin.X, Extents.Emax.X, Extents.Emin.Y, Extents.Emax.Y);
         actZoomAll.OnExecute(actZoomAll);
      end;
   end;
   actFirst.OnExecute(actFirst);
   Caption := Format(SLinetypesEditorTitle, [Ez_LineTypes.FileName, FCurrent]);
end;

function TfrmLinetypes.SaveIfModified: Boolean;
var
  TmpWord : Word;
begin
  Result := True;
  if FModified then
  begin
     TmpWord := Application.MessageBox( PChar(SLinetypesWereModified),
                                        PChar(SMsgConfirm),
                                        MB_YESNO or MB_ICONQUESTION );
     if TmpWord = IDYES then actSave.OnExecute(Self);
     FModified := False;
  end;
end;

procedure TfrmLinetypes.SymbolsBox1GridError(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := SGridTooDense;
end;

procedure TfrmLinetypes.MenuItem1Click(Sender: TObject);
begin
  actGrid.Checked := SymbolsBox1.GridInfo.ShowGrid;
end;

procedure TfrmLinetypes.Preferences1Click(Sender: TObject);
begin
{$IFDEF FALSE}
  with TfrmSymbPref.Create(Nil) do
     try
        Enter(SymbolsBox1);
     finally
        Free;
     end;
{$ENDIF}
end;

procedure TfrmLinetypes.SymbolsBox1MouseMove2D(Sender: TObject;
  Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
begin
  StatusBar1.Panels[1].Text := Format(SFormatPosition, [WX, WY]);
end;

procedure TfrmLinetypes.UpdateLinetype;
begin
  SymbolsBox1.Selection.Clear;
  SymbolsBox1.PopulateFrom(Ez_Linetypes[FCurrent]);
  EdName.Text:= Ez_Linetypes[FCurrent].Name;
  Caption := Format(SLinetypesEditorTitle, [Ez_Linetypes.FileName, FCurrent]);
  if FFirstTimeHere then
  begin
    SymbolsBox1.ZoomToExtension;
    FFirstTimeHere:=false;
  end else
    SymbolsBox1.Repaint;
end;

procedure TfrmLinetypes.SaveFromMapToLinetype;
begin
   SymbolsBox1.PopulateTo(Ez_Linetypes[FCurrent]);
end;

procedure TfrmLinetypes.EdNameChange(Sender: TObject);
begin
   if FSkipChanges then Exit;
   Ez_Linetypes[FCurrent].Name := EdName.Text;
end;

procedure TfrmLinetypes.FormClose(Sender: TObject; var Action: TCloseAction);
var
  temp: TEzSymbol;
  i: Integer;
  IniFile: TIniFile;
begin
  SaveFromMapToLinetype;
  IniFile:= TIniFile.Create(ExtractFilePath(Application.ExeName)+'Active.Ini');
  try
    with CmdLine1 do
    begin
       IniFile.WriteBool('Linetypes','UseOrto',UseOrto);
       IniFile.WriteBool('Linetypes','SnapToGrid',SymbolsBox1.GridInfo.SnapToGrid);
    end;
    IniFile.WriteBool('Linetypes','ScrollBars',SymbolsBox1.ScrollBars=ssBoth);
    IniFile.WriteInteger('Linetypes','Color',SymbolsBox1.Color);
    Inifile.WriteInteger('Linetypes','RubberPenColor',SymbolsBox1.RubberPen.Color);;
  finally
    IniFile.Free;
  end;
  { check that all symbols have at least one entity }
  for i:= 0 to Ez_Linetypes.Count - 1 do
  begin
     temp := Ez_Linetypes[i];
     if temp.Count = 0 then
     begin
        MessageToUser(Format(SLinetypeWrong,[i]), smsgerror,MB_ICONERROR);
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

procedure TfrmLinetypes.CmdLine1StatusMessage(Sender: TObject;
  const Message: String);
begin
   StatusBar1.Panels[0].Text := Message;
end;

procedure TfrmLinetypes.Options1Click(Sender: TObject);
begin
  //PaletteManager1.Checked:=BaseDialogs1.IsPaletteManagerVisible;
end;

procedure TfrmLinetypes.Palettemanager1Click(Sender: TObject);
{$IFDEF FALSE}
var
  Frm: TCustomForm;
{$ENDIF}
begin
{$IFDEF FALSE}
  Palettemanager1.Checked:= not Palettemanager1.Checked;
  if Palettemanager1.Checked then
  begin
     BaseDialogs1.ShowPaletteManager;
     Frm := nil;
     BroadcastToNotifiers(nil, CM_PALETTEMANAGERVISIBLE, Integer(@Frm), Integer(SymbolsBox1));
     if Frm <> nil then
        TfrmPalettes(Frm).btnSymbol.Enabled:=False;
  end
  else
     BaseDialogs1.ClosePaletteManager;
{$ENDIF}
end;

procedure TfrmLinetypes.FormPaint(Sender: TObject);
begin
  if not FWasPainted then
  begin
     FWasPainted := True;
     ResetView;
     actZoomAll.OnExecute(actZoomAll);
  end;
end;

procedure TfrmLinetypes.SymbolsBox1BeginRepaint(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := '';
end;

procedure TfrmLinetypes.Osnap2Click(Sender: TObject);
begin
   //BaseDialogs1.OsnapSettingsDialog;
end;

procedure TfrmLinetypes.Preferences2Click(Sender: TObject);
begin
  //BaseDialogs1.PreferencesDialog;
end;

procedure TfrmLinetypes.FormCreate(Sender: TObject);
var
   tm: TTextMetric;
   IniFile: TIniFile;
   //StartVal:Double;
begin
   SymbolsBox1.GIS.OnBeforePaintEntity:= MyBeforePaintEntity;
   SymbolsBox1.GIS.OnBeforePaintLayer:= MyBeforePaintLayer;

   SymbolsBox1.Grapher.SetViewTo(Rect2d(0,0,10,10));
   SymbolsBox1.Repaint;

   ResetView;
   IniFile:= TIniFile.Create(ExtractFilePath(Application.ExeName)+'Active.Ini');
   try
     with CmdLine1 do
     begin
        UseOrto := IniFile.ReadBool('Linetypes','UseOrto',False);
        actOrto.Checked := UseOrto;
        SymbolsBox1.GridInfo.SnapToGrid:= IniFile.ReadBool('Linetypes','SnapToGrid',False);
        actSnap.Checked:=SymbolsBox1.GridInfo.SnapToGrid;
     end;
     if IniFile.ReadBool('Linetypes','ScrollBars',True) then
       SymbolsBox1.ScrollBars:= ssBoth
     else
       SymbolsBox1.ScrollBars:= ssNone;
     SymbolsBox1.Color:= Inifile.ReadInteger('Linetypes','Color',clWindow);
     SymbolsBox1.RubberPen.Color:=clblack;
   finally
    IniFile.Free;
   end;

   with CmdLine1 do
   begin
      GetTextMetrics(Canvas.Handle, tm);
      Height := Round((tm.tmHeight + tm.tmInternalLeading)*1.5);
   end;

   FFirstTimeHere:=true;

end;

procedure TfrmLinetypes.MyBeforePaintEntity( Sender: TObject;
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
  if not (Entity is TEzOpenedEntity) then exit;
  with TEzOpenedEntity(Entity) do
  begin
    if Pentool.Style=0 then
      Pentool.Color:= clRed
    else
      Pentool.Color:= clGreen;
    if EntityID=idFittedVectText then
    begin
      //TFittedVectorText2d(Entity).FontColor:=Entity.PenStyle.Color;
    end;
    Pentool.Style:= 1;
    Pentool.Scale:= 0.05;
  end;
end;

procedure TfrmLinetypes.actNewExecute(Sender: TObject);
var
   S: TEzSymbol;
begin
   SaveFromMapToLinetype;
   if Sender = actNew then SaveIfModified;
   with Ez_Linetypes do
     if Sender = actSaveAs then
     begin
        if not SaveDialog1.Execute then exit;
        FileName:=SaveDialog1.Filename;
        Save;
        Caption := Format(SLinetypesEditorTitle, [SaveDialog1.Filename,FCurrent]);
     end
     else if Sender = actNew then
     begin
        Clear;
        S:= TEzSymbol.Create(Ez_Linetypes);
        S.Add(TEzRectangle.CreateEntity(Point2D(0,0),Point2D(10,10)));
        Add(S);
        FCurrent := 0;
        ResetView;
        actFirst.OnExecute(actFirst);
        { save new symbols file }
        if not SaveDialog1.Execute then exit;
        FileName:=SaveDialog1.Filename;
        Save;
     end;
end;

procedure TfrmLinetypes.actLoadExecute(Sender: TObject);
begin
   SaveFromMapToLinetype;
   SaveIfModified;
   if not OpenDialog1.Execute then exit;
   Ez_Linetypes.Close;
   Ez_Linetypes.FileName:=OpenDialog1.FileName;
   Ez_Linetypes.Open;
   FCurrent := 0;
   ResetView;
   actFirst.OnExecute(actFirst);
end;

procedure TfrmLinetypes.Action4Execute(Sender: TObject);
begin
  Close;
end;

procedure TfrmLinetypes.Action9Execute(Sender: TObject);
begin
  SymbolsBox1.DeleteSelection;
  SymbolsBox1.GIS.UpdateExtension;
  SymbolsBox1.Repaint;
end;

procedure TfrmLinetypes.Action10Execute(Sender: TObject);
begin
  SymbolsBox1.SelectAll;
end;

procedure TfrmLinetypes.Action11Execute(Sender: TObject);
begin
  with SymbolsBox1 do
  begin
     Selection.Clear;
     Repaint;
  end;
end;

procedure TfrmLinetypes.Action5Execute(Sender: TObject);
begin
  SymbolsBox1.Undo.Undo;
  SymbolsBox1.Repaint;
end;

procedure TfrmLinetypes.Action6Execute(Sender: TObject);
begin
  SymbolsBox1.Undo.CopyToClipboardFromSelection;
  SymbolsBox1.DeleteSelection;
  SymbolsBox1.Repaint;
end;

procedure TfrmLinetypes.Action7Execute(Sender: TObject);
begin
  SymbolsBox1.Undo.CopyToClipboardFromSelection;
end;

procedure TfrmLinetypes.Action8Execute(Sender: TObject);
begin
  SymbolsBox1.Undo.PasteFromClipboardTo;
end;

procedure TfrmLinetypes.Action12Execute(Sender: TObject);
begin
  SymbolsBox1.GroupSelection;
end;

procedure TfrmLinetypes.Action14Execute(Sender: TObject);
begin
  SymbolsBox1.BringToFront;
end;

procedure TfrmLinetypes.Action15Execute(Sender: TObject);
begin
  SymbolsBox1.SendToBack;
end;

procedure TfrmLinetypes.Action13Execute(Sender: TObject);
begin
  SymbolsBox1.UnGroupSelection;
end;

procedure TfrmLinetypes.actNewSymbolExecute(Sender: TObject);
begin
  SaveFromMapToLinetype;
  Ez_Linetypes.Add(TEzSymbol.Create(Ez_Linetypes));
  FCurrent := Ez_Linetypes.Count - 1;
  with SymbolsBox1 do
  begin
     CreateNewEditor;
     ZoomWindow(Rect2D(0, 0, 10, 10));
  end;
end;

procedure TfrmLinetypes.Action17Execute(Sender: TObject);
begin
   if MessageDlg('Are you sure you want to delete this linetype ?', mtConfirmation,
     [mbYes,mbNO], 0)<>mrOk then Exit;
  SaveFromMapToLinetype;
  if Ez_Linetypes.Count<2 then Exit;
  SymbolsBox1.Selection.Clear;
  Ez_Linetypes.Delete(FCurrent);
  if (FCurrent>0) and (FCurrent=Ez_Linetypes.Count) then Dec(FCurrent);
  UpdateLinetype;
end;

procedure TfrmLinetypes.actSaveExecute(Sender: TObject);
begin
  SaveFromMapToLinetype;
  if Length(Trim(Ez_Linetypes.FileName))=0 then exit;
  Ez_Linetypes.Save;

  FModified := False;
end;

procedure TfrmLinetypes.Action19Execute(Sender: TObject);
var
  Lines, LINElems:TStringList;
  temp: string;
  LINLinePos,n:Integer;
  NewLineType: TEzSymbol;
  Accept:Boolean;
  Value,LastVal,Offset:Double;
  code:Integer;
  ent: TEzEntity;

  function SplitElems(const temp: string): Boolean;
  var
    p:Integer;
    Work: string;
  begin
    result:=true;
    Work:= temp;
    p:=Pos(',',Work);
    if p=length(Work) then
    begin
      Work:=copy(Work,1,p-1);
      result:=false;
    end else
      while (p>0) and (length(Work)>0) do
      begin
        LINElems.Add(Trim(Copy(Work,1,p-1)));
        System.Delete(Work,1,p);
        if length(Work)>0 then
        begin
          p:=Pos(',',Work);
          if p=length(Work) then
            result:=false;
        end;
      end;
    if Length(Work)>0 then
      LINElems.Add(Work);
  end;

  function fetchLINData: Boolean;
  var
    temp: string;
  begin
    LINElems.Clear;
    repeat
      repeat
        Inc(LINLinePos);
        Result := LINLinePos < Lines.Count;
        if not Result then Exit;
        temp:= Trim(Lines[LINLinePos]);
        { this parse assume comments starts on first non blank character on the line }
        if (length(temp)>0) and (temp[1]=';') then temp:='';  // ignore comments
      until Length(temp) <> 0;
    until SplitElems(temp)=true;
  end;

begin
  if not openDialog2.Execute then exit;
  Lines:=TStringList.create;
  LINElems:= TStringList.Create;
  LINLinePos:=-1;
  try
    Lines.LoadFromFile(OpenDialog2.FileName);
    NewLineType:=nil;
    while fetchLINData do
    begin
      temp:= LINElems[0];
      if temp[1] = '*' then
      begin
        // start a new line type
        NewLineType:= TEzSymbol.Create(Ez_Linetypes);
        Ez_Linetypes.Add(NewLineType);
        NewLineType.Name:= temp;
      end else
      begin
        // add to the current line type
        Accept:= true;
        n:=0;
        Offset:= 0;
        LastVal:=0;
        while n<LINElems.Count do
        begin
          temp:= LINElems[n];
          if temp[1]='[' then Accept:= false;
          if temp[Length(temp)]=']' then Accept:= true;
          if (temp[1]<>'A') and Accept then
          begin
            val(temp,Value,code);
            if code=0 then
            begin
              LastVal:=Value;
              ent:= nil;
              if Value=0 then
                ent:= TEzPointEntity.CreateEntity(Point2d(Offset,0),clblack)
              else if Value>0 then
                ent:= TEzPolyline.CreateEntity([Point2d(Offset,0),Point2d(Offset+Value,0)]);
              if (ent<>nil) and (NewLinetype<>nil) then
              begin
                if ent is TEzOpenedEntity then
                begin
                  with TEzOpenedEntity(ent).Pentool do
                  begin
                    Style:=1;
                    Color:=0;
                    Scale:=0;
                  end;
                end;
                NewLinetype.Add(ent);
              end;
              Offset:= Offset + Abs(Value);
            end;
          end;
          Inc(n);
        end;
        if LastVal<0 then
        begin
          ent:= TEzPolyline.CreateEntity([Point2d(Offset,0),Point2d(Offset+Abs(LastVal),0)]);
          with TEzPolyline(ent) do
          begin
            Pentool.Style:=0;
            Pentool.Color:=0;
            Pentool.Scale:=0;
          end;
          NewLinetype.Add(ent);
        end;
      end;
    end;
  finally
    Lines.free;
    LINElems.free;
  end;
end;

procedure TfrmLinetypes.actFirstExecute(Sender: TObject);
begin
   if Ez_Linetypes.Count = 0 then Exit;
   SaveFromMapToLinetype;
   FCurrent := 0;
   UpdateLinetype;
end;

procedure TfrmLinetypes.Action26Execute(Sender: TObject);
begin
  if FCurrent <= 0 then Exit;
  SaveFromMapToLinetype;
  Dec(FCurrent);
  UpdateLinetype;
end;

procedure TfrmLinetypes.Action38Execute(Sender: TObject);
begin
  if FCurrent >= Ez_Linetypes.Count - 1 then Exit;
  SaveFromMapToLinetype;
  Inc(FCurrent);
  UpdateLinetype;
end;

procedure TfrmLinetypes.Action39Execute(Sender: TObject);
begin
   SaveFromMapToLinetype;
   with Ez_Linetypes do
   begin
     if Count = 0 then Exit;
     FCurrent := Count - 1;
   end;
   UpdateLinetype;
end;

procedure TfrmLinetypes.Action20Execute(Sender: TObject);
begin
  with TfrmLineType.create(Nil) do
    try
      Enter(self.SymbolsBox1);
    finally
      free;
    end;
end;

procedure TfrmLinetypes.Action21Execute(Sender: TObject);
begin
  with TfrmBrushStyle.create(Nil) do
    try
      Enter(SymbolsBox1);
    finally
      free;
    end;
end;

procedure TfrmLinetypes.Action22Execute(Sender: TObject);
begin
  with TfrmFontStyle.create(Nil) do
    try
      Enter(self.SymbolsBox1);
    finally
      free;
    end;
end;

procedure TfrmLinetypes.actOrtoExecute(Sender: TObject);
begin
  actOrto.Checked := not actOrto.Checked;
  CmdLine1.UseOrto := actOrto.Checked;
end;

procedure TfrmLinetypes.actSnapExecute(Sender: TObject);
begin
  actSnap.Checked := not actSnap.Checked;
  SymbolsBox1.GridInfo.SnapToGrid := actSnap.Checked;
end;

procedure TfrmLinetypes.actGridExecute(Sender: TObject);
begin
  actGrid.Checked := not actGrid.Checked;
  SymbolsBox1.GridInfo.ShowGrid := actGrid.Checked;
  SymbolsBox1.Repaint;
end;

procedure TfrmLinetypes.actScrollbarsExecute(Sender: TObject);
begin
  actScrollbars.Checked := not actScrollbars.Checked;
  if actScrollbars.Checked then
     SymbolsBox1.ScrollBars := ssBoth
  else
     SymbolsBox1.ScrollBars := ssNone;
end;

procedure TfrmLinetypes.Action23Execute(Sender: TObject);
begin
  SymbolsBox1.Gis.UpdateExtension;
  SymbolsBox1.Repaint;
end;

procedure TfrmLinetypes.Action28Execute(Sender: TObject);
begin
  CmdLine1.Clear;
  SymbolsBox1.Cursor:= crDefault;
end;

procedure TfrmLinetypes.Action29Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdSelect,'');
end;

procedure TfrmLinetypes.Action30Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdPolygonSelect,'');
end;

procedure TfrmLinetypes.Action31Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdCircleSelect,'');
end;

procedure TfrmLinetypes.Action32Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdHandScroll,'');
end;

procedure TfrmLinetypes.Action33Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdZoomWindow,'');
end;

procedure TfrmLinetypes.Action60Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdRealTimeZoom,'');
end;

procedure TfrmLinetypes.actZoomAllExecute(Sender: TObject);
var
  Extents: TEzRect;
begin
  if (FCurrent < 0) or (FCurrent >= Ez_Linetypes.Count - 1) then Exit;
  Extents:= Ez_Linetypes[FCurrent].Extension;
  if (Extents.Y2 - Extents.Y1) < 10 then
  begin
    Extents.Y1:= -5;
    Extents.Y2:= 5;
  end;
  with Extents do
    SymbolsBox1.SetViewTo(X1,Y1,X2,Y2);
end;

procedure TfrmLinetypes.Action35Execute(Sender: TObject);
begin
  SymbolsBox1.ZoomPrevious;
end;

procedure TfrmLinetypes.Action36Execute(Sender: TObject);
begin
  SymbolsBox1.ZoomIn(85);
end;

procedure TfrmLinetypes.Action37Execute(Sender: TObject);
begin
  SymbolsBox1.ZoomOut(85);
end;

procedure TfrmLinetypes.actVisibleExecute(Sender: TObject);
var
  I:Integer;
  ent:TEzEntity;
  stl:Integer;
begin
  if Sender = actVisible then
    stl:=1
  else
    stl:=0;
  if SymbolsBox1.Selection.NumSelected=0 then exit;
  with SymbolsBox1.Selection[0] do
    for I:=0 to SelList.Count-1 do
      begin
        ent:=SymbolsBox1.GIS.Layers[0].LoadEntityWithRecno(SelList[I]);
        if ent is TEzOpenedEntity then
          with TEzOpenedEntity(ent).Pentool do
          begin
            Style:=stl;
            Width:=0;
            Color:=clBlack;
          end;
        SymbolsBox1.GIS.Layers[0].UpdateEntity(SelList[I],ent);
      end;
  SymbolsBox1.Repaint;
end;

procedure TfrmLinetypes.Action16Execute(Sender: TObject);
begin
  CmdLine1.DoCommand( SCmdPoint, '' );
end;

procedure TfrmLinetypes.Action40Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdLine,'');
end;

procedure TfrmLinetypes.Action41Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdPolyline,'');
end;

procedure TfrmLinetypes.Action42Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdPolygon,'');
end;

procedure TfrmLinetypes.Action43Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdRectangle,'');
end;

procedure TfrmLinetypes.Action44Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdArc,'');
end;

procedure TfrmLinetypes.Action45Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdSpline,'');
end;

procedure TfrmLinetypes.Action46Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdPersistBitmap,'');
end;

procedure TfrmLinetypes.Action57Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdEllipse,'');
end;

procedure TfrmLinetypes.Action58Execute(Sender: TObject);
begin
  CmdLine1.DoCommand('CIRCLE3P','');
end;

procedure TfrmLinetypes.Action59Execute(Sender: TObject);
begin
  CmdLine1.DoCommand('CIRCLECR','');
end;

procedure TfrmLinetypes.Action1Execute(Sender: TObject);
begin
  CmdLine1.DoCommand('CIRCLE2P','');
end;

procedure TfrmLinetypes.Action48Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdFittedText,'');
end;

procedure TfrmLinetypes.Action49Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdMove,'');
end;

procedure TfrmLinetypes.Action50Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdScale,'');
end;

procedure TfrmLinetypes.Action51Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdRotate,'');
end;

procedure TfrmLinetypes.Action52Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdReshape,'');
end;

procedure TfrmLinetypes.Action53Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdHorzGLine,'');
end;

procedure TfrmLinetypes.Action54Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdVertGLine,'');
end;

procedure TfrmLinetypes.Action55Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdInsertVertex,'');
end;

procedure TfrmLinetypes.Action56Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdDeleteVertex,'');
end;

procedure TfrmLinetypes.Action9Update(Sender: TObject);
begin
  Action9.Enabled:= SymbolsBox1.Selection.NumSelected>0;
end;

procedure TfrmLinetypes.Action14Update(Sender: TObject);
begin
  (Sender as TAction).Enabled:= SymbolsBox1.Selection.NumSelected=1;
end;

Procedure TfrmLinetypes.MyBeforePaintLayer( Sender: TObject;
  Layer: TEzBaseLayer;
  Grapher: TEzGrapher;
  Var CanShow: Boolean;
  Var WasFiltered: Boolean;
  Var EntList: TEzEntityList;
  Var AutoFree: Boolean );
var
  p:TEzPoint;
  ent:TEzEntity;
begin
  { draw the axxis }
  EntList:= TEzEntityList.Create;
  p:=Point2d(0,0);
  ent:= TEzPolyline.CreateEntity([p,p,p,p,p,p,p,p,p,p,p,p]);
  WITH ent.Points DO
  BEGIN
    Clear;
    // build the X-axxis
    Add(Point2d(0,0));
    Add(Point2d(-10,0));
    Parts.Add(0);
    // X-axxis arrow
    Add(Point2d(-10,0));
    Add(Point2d(-9.5,0.25));
    Add(Point2d(-9.5,-0.25));
    Add(Point2d(-10,0));
    Parts.Add(2);
    // Y-axxis
    Add(Point2d(0,0));
    Add(Point2d(0,5));
    Parts.Add(6);
    // Y-axxis arrow
    Add(Point2d(0,5));
    Add(Point2d(-0.25,4.5));
    Add(Point2d(0.25,4.5));
    Add(Point2d(0,5));
    Parts.Add(8);
    // Y-axxis down
    Add(Point2d(0,0));
    Add(Point2d(0,-5));
    Parts.Add(12);
    // Y-axxis arrow down
    Add(Point2d(0,-5));
    Add(Point2d(-0.25,-4.5));
    Add(Point2d(0.25,-4.5));
    Add(Point2d(0,-5));
    Parts.Add(14);
  END;

  WITH TEzOpenedEntity(ent).Pentool DO
  BEGIN
    Style:=1;
    Color:= clSilver;
    Width:=0;

    Style:=1;
    Color:= clSilver;
    Width:=0;
  END;

  EntList.Add(ent);

  AutoFree:= True;
end;

procedure TfrmLinetypes.actAccuDrawExecute(Sender: TObject);
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

procedure TfrmLinetypes.actAccuDrawConfigExecute(Sender: TObject);
begin
  with TfrmAccuDrawSetts.create(nil) do
    try
      if (Enter(Self.CmdLine1)=mrOk) and Self.CmdLine1.AccuDraw.Enabled then
        SymbolsBox1.Refresh;
    finally
      free;
    end;
end;

procedure TfrmLinetypes.actAccuDrawRotateExecute(Sender: TObject);
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

procedure TfrmLinetypes.actAccuDrawUnrotateExecute(Sender: TObject);
begin
  CmdLine1.AccuDraw.ShowUnrotated;
end;

procedure TfrmLinetypes.actAccuDrawChangeOrigExecute(Sender: TObject);
begin
  { the AccuDraw origin will be defined to the last position on the draw box
    ( If AccuDraw is not visible, the command will be ignored )
  }
  CmdLine1.AccuDraw.ChangeOrigin( CmdLine1.GetSnappedPoint );
  { you also can define like this in order to preserve AccuDraw current rotation angle
    (Angle is an optional parameter with default value 0 ) }
  //CmdLine1.AccuDraw.ChangeOrigin( CmdLine1.CurrentSnappedPoint, CmdLine1.AccuDraw.Rotangle );
end;

procedure TfrmLinetypes.actAccuSnapShowExecute(Sender: TObject);
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

procedure TfrmLinetypes.actAccuSnapConfigExecute(Sender: TObject);
begin
  with TfrmAccuSnapSetts.create(nil) do
    try
      If (Enter(Self.CmdLine1)=mrOk) And Assigned(FfrmAccuSnap) Then
        FfrmAccuSnap.Reset;
    finally
      free;
    end;
end;

procedure TfrmLinetypes.AccuDrawFormClose(Sender: TObject);
begin
  FfrmAccuDraw:= Nil;
  actAccuDraw.Checked:= False;
end;

procedure TfrmLinetypes.AccusnapClose(Sender: TObject);
begin
  FfrmAccuSnap:= Nil;
  actAccuSnapShow.Checked:= False;
end;


end.
