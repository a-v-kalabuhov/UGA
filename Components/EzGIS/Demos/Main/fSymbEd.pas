unit fSymbEd;

{$I EZ_FLAG.PAS}
interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Menus, ComCtrls, Messages,
  EzLib, EzCmdLine, EzSystem, Dialogs, EzBaseGIS, EzEntities,
  EzBasicCtrls, Mask, EzMiscelCtrls;

type
  TfrmSymbols = class(TForm)
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
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
    Loadsymbols1: TMenuItem;
    Saveas1: TMenuItem;
    New2: TMenuItem;
    Currentsymbol1: TMenuItem;
    Textstyle1: TMenuItem;
    Import1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Panel1: TPanel;
    Label1: TLabel;
    EdName: TEdit;
    btnFirst: TSpeedButton;
    Bevel2: TBevel;
    btnPrior: TSpeedButton;
    btnNext: TSpeedButton;
    btnLast: TSpeedButton;
    btnAdd: TSpeedButton;
    btnDelete: TSpeedButton;
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
    N22: TMenuItem;
    Osnap2: TMenuItem;
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
    Fit: TMenuItem;
    Group1: TMenuItem;
    btnDimHorz: TSpeedButton;
    BtnDimVert: TSpeedButton;
    btnDimParallel: TSpeedButton;
    BtnCircleCR: TSpeedButton;
    BtnCircle3P: TSpeedButton;
    cboSymbols: TEzSymbolsGridBox;
    BtnTrue: TSpeedButton;
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
    procedure SymbolsBox1MouseMove2D(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; const WX, WY: Double);
    procedure EdNameChange(Sender: TObject);
    procedure Loadsymbols1Click(Sender: TObject);
    procedure Saveas1Click(Sender: TObject);
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
    procedure FitClick(Sender: TObject);
    procedure Group1Click(Sender: TObject);
    procedure btnDimHorzClick(Sender: TObject);
    procedure BtnDimVertClick(Sender: TObject);
    procedure btnDimParallelClick(Sender: TObject);
    procedure FillStyle1Click(Sender: TObject);
    procedure Textstyle1Click(Sender: TObject);
    procedure BtnCircle3PClick(Sender: TObject);
    procedure BtnCircleCRClick(Sender: TObject);
    procedure BtnTrueClick(Sender: TObject);
    procedure cboSymbolsChange(Sender: TObject);
  private
    { Private declarations }
    FCurrent: Integer;
    FModified, FWasPainted: Boolean;
    FSkipChanges: Boolean;
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
  Math, Inifiles, EzConsts, fImpTT, fLineType, fBrushStyle, fFontStyle;

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
   BtnFirst.OnClick(BtnFirst);
   Caption := Format(SSymbolsEditorTitle, [Ez_Symbols.FileName, FCurrent]);
end;

procedure TfrmSymbols.Save1Click(Sender: TObject);
begin
  SaveFromMapToSymbol;
  Ez_Symbols.SaveAs(Ez_Symbols.FileName);

  FModified := False;
end;

procedure TfrmSymbols.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmSymbols.New1Click(Sender: TObject);
begin
  SaveFromMapToSymbol;
  SymbolsBox1.CreateNewEditor;
  Ez_Symbols.Add(TEzSymbol.Create(Ez_Symbols));
  FCurrent := Ez_Symbols.Count - 1;
  UpdateSymbol;
  SymbolsBox1.ZoomWindow(Rect2D(0, 0, 100, 100));
  //cboSymbols.Populate;
end;

procedure TfrmSymbols.Orto1Click(Sender: TObject);
begin
  Orto1.Checked := not Orto1.Checked;
  CmdLine1.UseOrto := Orto1.Checked;
end;

procedure TfrmSymbols.Snap1Click(Sender: TObject);
begin
  Snap1.Checked := not Snap1.Checked;
  SymbolsBox1.GridInfo.SnapToGrid:=Snap1.Checked;
end;

procedure TfrmSymbols.Scrollbars1Click(Sender: TObject);
begin
  Scrollbars1.Checked := not Scrollbars1.Checked;
  if Scrollbars1.Checked then
     SymbolsBox1.ScrollBars := ssBoth
  else
     SymbolsBox1.ScrollBars := ssNone;
end;

procedure TfrmSymbols.Delete1Click(Sender: TObject);
begin
  SymbolsBox1.DeleteSelection;
  SymbolsBox1.GIS.UpdateExtension;
  SymbolsBox1.Repaint;
end;

procedure TfrmSymbols.DeleteSymbol1Click(Sender: TObject);
begin
  SaveFromMapToSymbol;
  if Ez_Symbols.Count<2 then Exit;
  SymbolsBox1.Selection.Clear;
  Ez_Symbols.Delete(FCurrent);
  if (FCurrent>0) and (FCurrent=Ez_Symbols.Count) then Dec(FCurrent);
  UpdateSymbol;
  //cboSymbols.Populate;
end;

procedure TfrmSymbols.Clear1Click(Sender: TObject);
begin
  with SymbolsBox1 do
  begin
     Selection.Clear;
     Repaint;
  end;
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
     if TmpWord = IDYES then Save1.OnClick(Self);
     FModified := False;
  end;
end;

procedure TfrmSymbols.SymbolsBox1GridError(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := SGridTooDense;
end;

procedure TfrmSymbols.Grid1Click(Sender: TObject);
begin
  Grid1.Checked := not Grid1.Checked;
  SymbolsBox1.GridInfo.ShowGrid := Grid1.Checked;
  SymbolsBox1.Repaint;
end;

procedure TfrmSymbols.SelectAll1Click(Sender: TObject);
begin
  SymbolsBox1.SelectAll;
end;

procedure TfrmSymbols.Edit1Click(Sender: TObject);
var
  cnt: integer;
begin
  cnt := SymbolsBox1.Selection.NumSelected;
  Delete1.Enabled := cnt > 0;
  Front1.Enabled := (cnt = 1);
  Back1.Enabled := (cnt = 1);
end;

procedure TfrmSymbols.MenuItem1Click(Sender: TObject);
begin
  Grid1.Checked := SymbolsBox1.GridInfo.ShowGrid;
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

procedure TfrmSymbols.Loadsymbols1Click(Sender: TObject);
begin
   SaveFromMapToSymbol;
   SaveIfModified;
   if not OpenDialog1.Execute then exit;
   Ez_Symbols.FileName:= OpenDialog1.FileName;
   Ez_Symbols.Open;
   FCurrent := 0;
   ResetViewport;
   BtnFirst.OnClick(BtnFirst);
   //cboSymbols.Populate;
end;

procedure TfrmSymbols.Saveas1Click(Sender: TObject);
var
   S: TEzSymbol;
begin
   SaveFromMapToSymbol;
   if Sender = New2 then SaveIfModified;
   with Ez_Symbols do
     if Sender = Saveas1 then
     begin
        if not SaveDialog1.Execute then exit;
        SaveAs(SaveDialog1.Filename);
        Caption := Format(SSymbolsEditorTitle, [SaveDialog1.Filename,FCurrent]);
     end
     else if Sender = New2 then
     begin
        Clear;
        S:= TEzSymbol.Create(Ez_Symbols);
        S.Add(TEzRectangle.CreateEntity(Point2D(0,0),Point2D(10,10)));
        Add(S);
        FCurrent := 0;
        ResetViewport;
        BtnFirst.OnClick(BtnFirst);
        { save new symbols file }
        if not SaveDialog1.Execute then exit;
        SaveAs(SaveDialog1.Filename);
     end;
   //cboSymbols.Populate;
end;

procedure TfrmSymbols.Import1Click(Sender: TObject);
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

procedure TfrmSymbols.btnLineClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdLine,'');
end;

procedure TfrmSymbols.btnPLineClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdPolyline,'');
end;

procedure TfrmSymbols.btnPolygonClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdPolygon,'');
end;

procedure TfrmSymbols.btnRectClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdRectangle,'');
end;

procedure TfrmSymbols.btnArcClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdArc,'');
end;

procedure TfrmSymbols.btnEllipseClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdEllipse,'');
end;

procedure TfrmSymbols.btnSplineClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdSpline,'');
end;

procedure TfrmSymbols.btnBmpClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdPersistBitmap,'');
end;

procedure TfrmSymbols.btnTextClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdText,'');
end;

procedure TfrmSymbols.btnMoveClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdMove,'');
end;

procedure TfrmSymbols.btnScaleClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdScale,'');
end;

procedure TfrmSymbols.btnRotateClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdRotate,'');
end;

procedure TfrmSymbols.btnReshapeClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdReshape,'');
end;

procedure TfrmSymbols.btnFirstClick(Sender: TObject);
begin
   if Ez_Symbols.Count = 0 then Exit;
   SaveFromMapToSymbol;
   FCurrent := 0;
   UpdateSymbol;
end;

procedure TfrmSymbols.btnPriorClick(Sender: TObject);
begin
  if FCurrent <= 0 then Exit;
  SaveFromMapToSymbol;
  Dec(FCurrent);
  UpdateSymbol;
end;

procedure TfrmSymbols.btnNextClick(Sender: TObject);
begin
  if FCurrent >= Ez_Symbols.Count - 1 then Exit;
  SaveFromMapToSymbol;
  Inc(FCurrent);
  UpdateSymbol;
end;

procedure TfrmSymbols.btnLastClick(Sender: TObject);
begin
   SaveFromMapToSymbol;
   with Ez_Symbols do
   begin
     if Count = 0 then Exit;
     FCurrent := Count - 1;
   end;
   UpdateSymbol;
end;

procedure TfrmSymbols.btnAddClick(Sender: TObject);
begin
   New1.OnClick(nil);
end;

procedure TfrmSymbols.btnDeleteClick(Sender: TObject);
begin
   if MessageDlg('Are you sure you want to delete this symbol ?', mtConfirmation,
    [mbYes,mbNO], 0)<>mrYes then Exit;
   DeleteSymbol1.OnClick(nil);
end;

procedure TfrmSymbols.btnSelectClick(Sender: TObject);
begin
  CmdLine1.Clear;
  SymbolsBox1.Cursor:= crDefault;
end;

procedure TfrmSymbols.btnRectSelectClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdSelect,'');
end;

procedure TfrmSymbols.btnPolyselectClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdPolygonSelect,'');
end;

procedure TfrmSymbols.btnCircleSelectClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdCircleSelect,'');
end;

procedure TfrmSymbols.btnPanClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdHandScroll,'');
end;

procedure TfrmSymbols.btnRealTimeZoomClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdRealTimeZoom,'');
end;

procedure TfrmSymbols.btnZoomWClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdZoomWindow,'');
end;

procedure TfrmSymbols.btnZoomAllClick(Sender: TObject);
begin
  SymbolsBox1.ZoomToExtension;
end;

procedure TfrmSymbols.btnZoomPrevClick(Sender: TObject);
begin
  SymbolsBox1.ZoomPrevious;
end;

procedure TfrmSymbols.btnZoomInClick(Sender: TObject);
begin
  SymbolsBox1.ZoomIn(85);
end;

procedure TfrmSymbols.btnZoomOutClick(Sender: TObject);
begin
  SymbolsBox1.ZoomOut(85);
end;

procedure TfrmSymbols.btnTofrontClick(Sender: TObject);
begin
  SymbolsBox1.BringToFront;
end;

procedure TfrmSymbols.btnTobackClick(Sender: TObject);
begin
  SymbolsBox1.SendToBack;
end;

procedure TfrmSymbols.btnJustifTextClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdJustifText,'');
end;

procedure TfrmSymbols.btnFittedTextClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdFittedText,'');
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
       Orto1.Checked := UseOrto;
       SymbolsBox1.GridInfo.SnapToGrid:= IniFile.ReadBool('Symbols','SnapToGrid',False);
       Snap1.Checked:=SymbolsBox1.GridInfo.SnapToGrid;
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

procedure TfrmSymbols.Refresh1Click(Sender: TObject);
begin
  SymbolsBox1.Gis.UpdateExtension;
  SymbolsBox1.Repaint;
end;

procedure TfrmSymbols.Undo1Click(Sender: TObject);
begin
  SymbolsBox1.Undo.Undo;
  SymbolsBox1.Repaint;
end;

procedure TfrmSymbols.Cut1Click(Sender: TObject);
begin
  SymbolsBox1.Undo.CopyToClipboardFromSelection;
  SymbolsBox1.DeleteSelection;
  SymbolsBox1.Repaint;
end;

procedure TfrmSymbols.Copy1Click(Sender: TObject);
begin
  SymbolsBox1.Undo.CopyToClipboardFromSelection;
end;

procedure TfrmSymbols.Paste1Click(Sender: TObject);
begin
  SymbolsBox1.Undo.PasteFromClipboardTo;
end;

procedure TfrmSymbols.Front1Click(Sender: TObject);
begin
  SymbolsBox1.BringToFront;
end;

procedure TfrmSymbols.Back1Click(Sender: TObject);
begin
  SymbolsBox1.SendToBack;
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

procedure TfrmSymbols.LineStyle1Click(Sender: TObject);
begin
  with TfrmLineType.create(Nil) do
    try
      Enter(SymbolsBox1);
    finally
      free;
    end;
end;

procedure TfrmSymbols.BtnInsVertexClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdInsertVertex,'');

end;

procedure TfrmSymbols.BtnDelVertexClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdDeleteVertex,'');
end;

procedure TfrmSymbols.HGuidesClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdHorzGLine,'');
end;

procedure TfrmSymbols.VGuidesClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdVertGLine,'');
end;

procedure TfrmSymbols.btnBannerClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdBannerText,'');
end;

procedure TfrmSymbols.btnCalloutClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdCalloutText,'');
end;

procedure TfrmSymbols.btnBulletClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdBulletLeader,'');
end;

procedure TfrmSymbols.FitClick(Sender: TObject);
begin
  SymbolsBox1.FitSelectionToPath(true);
end;

procedure TfrmSymbols.Group1Click(Sender: TObject);
begin
  SymbolsBox1.GroupSelection;
end;

procedure TfrmSymbols.btnDimHorzClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdDimHoriz,'');
end;

procedure TfrmSymbols.BtnDimVertClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdDimVert,'');
end;

procedure TfrmSymbols.btnDimParallelClick(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdDimParall,'');
end;

procedure TfrmSymbols.FillStyle1Click(Sender: TObject);
begin
  with TfrmBrushStyle.create(Nil) do
    try
      Enter(SymbolsBox1);
    finally
      free;
    end;
end;

procedure TfrmSymbols.Textstyle1Click(Sender: TObject);
begin
  with TfrmFontStyle.create(Nil) do
    try
      Enter(self.SymbolsBox1);
    finally
      free;
    end;
end;

procedure TfrmSymbols.BtnCircle3PClick(Sender: TObject);
begin
  CmdLine1.DoCommand('CIRCLECR','');
end;

procedure TfrmSymbols.BtnCircleCRClick(Sender: TObject);
begin
  CmdLine1.DoCommand('CIRCLE3P','');
end;

procedure TfrmSymbols.BtnTrueClick(Sender: TObject);
begin
  CmdLine1.DoCommand('TEXT','');
end;

procedure TfrmSymbols.cboSymbolsChange(Sender: TObject);
begin
  if cboSymbols.ItemIndex < 0 then Exit;
  SaveFromMapToSymbol;
  FCurrent:=cboSymbols.ItemIndex;
  UpdateSymbol;
end;

end.
