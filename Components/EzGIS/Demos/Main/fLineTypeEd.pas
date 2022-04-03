unit fLineTypeEd;

{$I EZ_FLAG.PAS}
interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Menus, ComCtrls, Messages,
  EzLib, EzCmdLine, EzSystem, Dialogs, EzBaseGIS, EzEntities, 
  EzBasicCtrls;

type
  TfrmLinetypes = class(TForm)
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    DWG1: TMenuItem;
    New1: TMenuItem;
    DeleteSymbol1: TMenuItem;
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
    CmdLine1: TEzCmdLine;
    Loadsymbols1: TMenuItem;
    Saveas1: TMenuItem;
    New2: TMenuItem;
    Currentsymbol1: TMenuItem;
    Textstyle1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    SymbolsBox1: TEzSymbolsBox;
    Panel1: TPanel;
    Label1: TLabel;
    EdName: TEdit;
    btnFirst: TSpeedButton;
    Bevel2: TBevel;
    btnLast: TSpeedButton;
    btnAdd: TSpeedButton;
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
    N22: TMenuItem;
    Osnap2: TMenuItem;
    Preferences2: TMenuItem;
    btnFittedText: TSpeedButton;
    HGuides: TSpeedButton;
    VGuides: TSpeedButton;
    btnPoint: TSpeedButton;
    Bevel1: TBevel;
    btnVisible: TSpeedButton;
    btnInvisible: TSpeedButton;
    OpenDialog2: TOpenDialog;
    BtnCircle3P: TSpeedButton;
    BtnCircleCR: TSpeedButton;
    btnDelete: TSpeedButton;
    btnPrior: TSpeedButton;
    btnNext: TSpeedButton;
    procedure Save1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Orto1Click(Sender: TObject);
    procedure Snap1Click(Sender: TObject);
    procedure Scrollbars1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure DeleteSymbol1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure SymbolsBox1GridError(Sender: TObject);
    procedure Grid1Click(Sender: TObject);
    procedure SelectAll1Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure Preferences1Click(Sender: TObject);
    procedure LineStyle1Click(Sender: TObject);
    procedure FillStyle1Click(Sender: TObject);
    procedure SymbolsBox1MouseMove2D(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; const WX, WY: Double);
    procedure EdNameChange(Sender: TObject);
    procedure Loadsymbols1Click(Sender: TObject);
    procedure Saveas1Click(Sender: TObject);
    procedure Textstyle1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CmdLine1StatusMessage(Sender: TObject; const Message: String);
    procedure Options1Click(Sender: TObject);
    procedure Palettemanager1Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure SymbolsBox1BeginRepaint(Sender: TObject);
    procedure btnLineClick(Sender: TObject);
    procedure btnPLineClick(Sender: TObject);
    procedure btnPolygonClick(Sender: TObject);
    procedure btnRectClick(Sender: TObject);
    procedure btnArcClick(Sender: TObject);
    procedure btnEllipseClick(Sender: TObject);
    procedure btnSplineClick(Sender: TObject);
    procedure btnMoveClick(Sender: TObject);
    procedure btnScaleClick(Sender: TObject);
    procedure btnRotateClick(Sender: TObject);
    procedure btnReshapeClick(Sender: TObject);
    procedure btnFirstClick(Sender: TObject);
    procedure btnPriorClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnLastClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
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
    procedure Osnap2Click(Sender: TObject);
    procedure Preferences2Click(Sender: TObject);
    procedure btnFittedTextClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure HGuidesClick(Sender: TObject);
    procedure VGuidesClick(Sender: TObject);
    procedure btnPointClick(Sender: TObject);
    procedure btnVisibleClick(Sender: TObject);
    procedure DWG1Click(Sender: TObject);
  private
    { Private declarations }
    FCurrent: Integer;
    FModified, FWasPainted: Boolean;
    FSkipChanges: Boolean;
    FFirstTimeHere:Boolean;

    procedure UpdateLinetype;
    procedure SaveFromMapToLinetype;
    procedure ResetView;
    function SaveIfModified: Boolean;
    procedure CreateAxxis;
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
  Math, Inifiles, EzConsts, ezbase, fLineType, fBrushStyle, fFontStyle;

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
         btnZoomAll.OnClick(nil);
      end;
   end;
   BtnFirst.OnClick(BtnFirst);
   Caption := Format(SLinetypesEditorTitle, [Ez_LineTypes.FileName, FCurrent]);
end;

procedure TfrmLinetypes.Save1Click(Sender: TObject);
begin
  SaveFromMapToLinetype;
  if Length(Trim(Ez_Linetypes.FileName))=0 then exit;
  Ez_Linetypes.Save;

  FModified := False;
end;

procedure TfrmLinetypes.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmLinetypes.New1Click(Sender: TObject);
begin
  SaveFromMapToLinetype;
  Ez_Linetypes.Add(TEzSymbol.Create(Ez_Linetypes));
  FCurrent := Ez_Linetypes.Count - 1;
  with SymbolsBox1 do
  begin
     CreateNewEditor;
     ZoomWindow(Rect2D(0, 0, 10, 10));
  end;
  CreateAxxis;
end;

procedure TfrmLinetypes.Orto1Click(Sender: TObject);
begin
  Orto1.Checked := not Orto1.Checked;
  CmdLine1.UseOrto := Orto1.Checked;
end;

procedure TfrmLinetypes.Snap1Click(Sender: TObject);
begin
  Snap1.Checked := not Snap1.Checked;
  SymbolsBox1.GridInfo.SnapToGrid := Snap1.Checked;
end;

procedure TfrmLinetypes.Scrollbars1Click(Sender: TObject);
begin
  Scrollbars1.Checked := not Scrollbars1.Checked;
  if Scrollbars1.Checked then
     SymbolsBox1.ScrollBars := ssBoth
  else
     SymbolsBox1.ScrollBars := ssNone;
end;

procedure TfrmLinetypes.Delete1Click(Sender: TObject);
begin
  SymbolsBox1.DeleteSelection;
  SymbolsBox1.GIS.UpdateExtension;
  SymbolsBox1.Repaint;
end;

procedure TfrmLinetypes.DeleteSymbol1Click(Sender: TObject);
begin
  SaveFromMapToLinetype;
  if Ez_Linetypes.Count<2 then Exit;
  SymbolsBox1.Selection.Clear;
  Ez_Linetypes.Delete(FCurrent);
  if (FCurrent>0) and (FCurrent=Ez_Linetypes.Count) then Dec(FCurrent);
  UpdateLinetype;
end;

procedure TfrmLinetypes.Clear1Click(Sender: TObject);
begin
  with SymbolsBox1 do
  begin
     Selection.Clear;
     Repaint;
  end;
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
     if TmpWord = IDYES then Save1.OnClick(Self);
     FModified := False;
  end;
end;

procedure TfrmLinetypes.SymbolsBox1GridError(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := SGridTooDense;
end;

procedure TfrmLinetypes.Grid1Click(Sender: TObject);
begin
  Grid1.Checked := not Grid1.Checked;
  SymbolsBox1.GridInfo.ShowGrid := Grid1.Checked;
  SymbolsBox1.Repaint;
end;

procedure TfrmLinetypes.SelectAll1Click(Sender: TObject);
begin
  SymbolsBox1.SelectAll;
end;

procedure TfrmLinetypes.Edit1Click(Sender: TObject);
var
  cnt: integer;
begin
  cnt := SymbolsBox1.Selection.NumSelected;
  Delete1.Enabled := cnt > 0;
  Front1.Enabled := (cnt = 1);
  Back1.Enabled := (cnt = 1);
end;

procedure TfrmLinetypes.MenuItem1Click(Sender: TObject);
begin
  Grid1.Checked := SymbolsBox1.GridInfo.ShowGrid;
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

procedure TfrmLinetypes.LineStyle1Click(Sender: TObject);
begin
  with TfrmLineType.create(Nil) do
    try
      Enter(self.SymbolsBox1);
    finally
      free;
    end;
end;

procedure TfrmLinetypes.FillStyle1Click(Sender: TObject);
begin
  with TfrmBrushStyle.create(Nil) do
    try
      Enter(SymbolsBox1);
    finally
      free;
    end;
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

procedure TfrmLinetypes.Loadsymbols1Click(Sender: TObject);
begin
   SaveFromMapToLinetype;
   SaveIfModified;
   if not OpenDialog1.Execute then exit;
   Ez_Linetypes.Close;
   Ez_Linetypes.FileName:=OpenDialog1.FileName;
   Ez_Linetypes.Open;
   FCurrent := 0;
   ResetView;
   BtnFirst.OnClick(BtnFirst);
end;

procedure TfrmLinetypes.Saveas1Click(Sender: TObject);
var
   S: TEzSymbol;
begin
   SaveFromMapToLinetype;
   if Sender = New2 then SaveIfModified;
   with Ez_Linetypes do
     if Sender = Saveas1 then
     begin
        if not SaveDialog1.Execute then exit;
        FileName:=SaveDialog1.Filename;
        Save;
        Caption := Format(SLinetypesEditorTitle, [SaveDialog1.Filename,FCurrent]);
     end
     else if Sender = New2 then
     begin
        Clear;
        S:= TEzSymbol.Create(Ez_Linetypes);
        S.Add(TEzRectangle.CreateEntity(Point2D(0,0),Point2D(10,10)));
        Add(S);
        FCurrent := 0;
        ResetView;
        BtnFirst.OnClick(BtnFirst);
        { save new symbols file }
        if not SaveDialog1.Execute then exit;
        FileName:=SaveDialog1.Filename;
        Save;
     end;
end;

procedure TfrmLinetypes.Textstyle1Click(Sender: TObject);
begin
  with TfrmFontStyle.create(Nil) do
    try
      Enter(self.SymbolsBox1);
    finally
      free;
    end;
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
     btnZoomAll.OnClick(nil);
  end;
end;

procedure TfrmLinetypes.SymbolsBox1BeginRepaint(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := '';
end;

procedure TfrmLinetypes.btnLineClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdLine,'');
end;

procedure TfrmLinetypes.btnPLineClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdPolyline,'');
end;

procedure TfrmLinetypes.btnPolygonClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdPolygon,'');
end;

procedure TfrmLinetypes.btnRectClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdRectangle,'');
end;

procedure TfrmLinetypes.btnArcClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdArc,'');
end;

procedure TfrmLinetypes.btnEllipseClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdEllipse,'');
end;

procedure TfrmLinetypes.btnSplineClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdSpline,'');
end;

procedure TfrmLinetypes.btnMoveClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdMove,'');
end;

procedure TfrmLinetypes.btnScaleClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdScale,'');
end;

procedure TfrmLinetypes.btnRotateClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdRotate,'');
end;

procedure TfrmLinetypes.btnReshapeClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdReshape,'');
end;

procedure TfrmLinetypes.btnFirstClick(Sender: TObject);
begin
   if Ez_Linetypes.Count = 0 then Exit;
   SaveFromMapToLinetype;
   FCurrent := 0;
   UpdateLinetype;
end;

procedure TfrmLinetypes.btnPriorClick(Sender: TObject);
begin
  if FCurrent <= 0 then Exit;
  SaveFromMapToLinetype;
  Dec(FCurrent);
  UpdateLinetype;
end;

procedure TfrmLinetypes.btnNextClick(Sender: TObject);
begin
  if FCurrent >= Ez_Linetypes.Count - 1 then Exit;
  SaveFromMapToLinetype;
  Inc(FCurrent);
  UpdateLinetype;
end;

procedure TfrmLinetypes.btnLastClick(Sender: TObject);
begin
   SaveFromMapToLinetype;
   with Ez_Linetypes do
   begin
     if Count = 0 then Exit;
     FCurrent := Count - 1;
   end;
   UpdateLinetype;
end;

procedure TfrmLinetypes.btnAddClick(Sender: TObject);
begin
   SaveFromMapToLinetype;
   New1.OnClick(nil);
end;

procedure TfrmLinetypes.btnDeleteClick(Sender: TObject);
begin
   if MessageDlg('Are you sure you want to delete this linetype ?', mtConfirmation,
     [mbYes,mbNO], 0)<>mrOk then Exit;
   DeleteSymbol1.OnClick(nil);
end;

procedure TfrmLinetypes.btnSelectClick(Sender: TObject);
begin
  CmdLine1.Clear;
  SymbolsBox1.Cursor:= crDefault;
end;

procedure TfrmLinetypes.btnRectSelectClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdSelect,'');
end;

procedure TfrmLinetypes.btnPolyselectClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdPolygonSelect,'');
end;

procedure TfrmLinetypes.btnCircleSelectClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdCircleSelect,'');
end;

procedure TfrmLinetypes.btnPanClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdHandScroll,'');
end;

procedure TfrmLinetypes.btnRealTimeZoomClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdRealTimeZoom,'');
end;

procedure TfrmLinetypes.btnZoomWClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdZoomWindow,'');
end;

procedure TfrmLinetypes.btnZoomAllClick(Sender: TObject);
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

procedure TfrmLinetypes.btnZoomPrevClick(Sender: TObject);
begin
  SymbolsBox1.ZoomPrevious;
end;

procedure TfrmLinetypes.btnZoomInClick(Sender: TObject);
begin
  SymbolsBox1.ZoomIn(85);
end;

procedure TfrmLinetypes.btnZoomOutClick(Sender: TObject);
begin
  SymbolsBox1.ZoomOut(85);
end;

procedure TfrmLinetypes.btnTofrontClick(Sender: TObject);
begin
  SymbolsBox1.BringToFront;
end;

procedure TfrmLinetypes.btnTobackClick(Sender: TObject);
begin
  SymbolsBox1.SendToBack;
end;

procedure TfrmLinetypes.Osnap2Click(Sender: TObject);
begin
   //BaseDialogs1.OsnapSettingsDialog;
end;

procedure TfrmLinetypes.Preferences2Click(Sender: TObject);
begin
  //BaseDialogs1.PreferencesDialog;
end;

procedure TfrmLinetypes.btnFittedTextClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdFittedText,'');
end;

procedure TfrmLinetypes.CreateAxxis;
var
   p:TEzPoint;
   ent:TEzEntity;
begin
   { add the temporary entities }
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

   SymbolsBox1.TempEntities.Clear;
   SymbolsBox1.TempEntities.Add(ent);
end;

procedure TfrmLinetypes.FormCreate(Sender: TObject);
var
   tm: TTextMetric;
   IniFile: TIniFile;
   //StartVal:Double;
begin
   SymbolsBox1.GIS.OnBeforePaintEntity:= MyBeforePaintEntity;

   CreateAxxis;

   SymbolsBox1.Grapher.SetViewTo(Rect2d(0,0,10,10));
   SymbolsBox1.Repaint;

   ResetView;
   IniFile:= TIniFile.Create(ExtractFilePath(Application.ExeName)+'Active.Ini');
   try
     with CmdLine1 do
     begin
        UseOrto := IniFile.ReadBool('Linetypes','UseOrto',False);
        Orto1.Checked := UseOrto;
        SymbolsBox1.GridInfo.SnapToGrid:= IniFile.ReadBool('Linetypes','SnapToGrid',False);
        Snap1.Checked:=SymbolsBox1.GridInfo.SnapToGrid;
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

procedure TfrmLinetypes.HGuidesClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdHorzGLine,'');
end;

procedure TfrmLinetypes.VGuidesClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdVertGLine,'');
end;

procedure TfrmLinetypes.btnPointClick(Sender: TObject);
begin
  CmdLine1.DoCommand( SCmdPoint, '' );
end;

procedure TfrmLinetypes.btnVisibleClick(Sender: TObject);
var
  I:Integer;
  ent:TEzEntity;
  stl:Integer;
begin
  if Sender = btnVisible then
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

procedure TfrmLinetypes.DWG1Click(Sender: TObject);
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

end.
