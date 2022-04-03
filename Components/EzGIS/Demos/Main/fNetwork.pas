unit fNetwork;

{$I EZ_FLAG.PAS}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, EzNetwork, EzBaseGis,
  EzActionLaunch, Grids, EzNumEd, ExtCtrls, EzMiscelCtrls
{$IFDEF LEVEL6}
  , Variants
{$ENDIF}
  ;

type
  TfrmNetwork = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    CboNetwork: TComboBox;
    Label2: TLabel;
    cboResult: TComboBox;
    SpeedButton1: TSpeedButton;
    Button1: TButton;
    Label3: TLabel;
    CboStartToEnd: TComboBox;
    Label4: TLabel;
    CboEndToStart: TComboBox;
    btnAssist: TButton;
    btnAssistT: TButton;
    Label7: TLabel;
    CboStreetName: TComboBox;
    chkSelected: TCheckBox;
    Button2: TButton;
    Network1: TEzNetwork;
    Launcher1: TEzActionLauncher;
    EzNumEd1: TEzNumEd;
    Label6: TLabel;
    LblNPts: TLabel;
    PageControl2: TPageControl;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Grid1: TStringGrid;
    Memo1: TMemo;
    Label5: TLabel;
    CboUnits: TComboBox;
    Label8: TLabel;
    Panel1: TPanel;
    Button3: TButton;
    PrintDialog1: TPrintDialog;
    FontDialog1: TFontDialog;
    Button4: TButton;
    SaveDialog1: TSaveDialog;
    Button5: TButton;
    TabSheet5: TTabSheet;
    Label9: TLabel;
    ComboBox1: TComboBox;
    ChkDelete: TCheckBox;
    chkErase: TCheckBox;
    chkBreak: TCheckBox;
    chkDisolve: TCheckBox;
    Label10: TLabel;
    EdTolerance: TEzNumEd;
    Label11: TLabel;
    Symbolsbox: TEzSymbolsGridBox;
    Label12: TLabel;
    EdSymbolSize: TEzNumEd;
    CheckBox1: TCheckBox;
    Button6: TButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure CboNetworkClick(Sender: TObject);
    procedure btnAssistClick(Sender: TObject);
    procedure btnAssistTClick(Sender: TObject);
    procedure Launcher1Finished(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Launcher1KeyPress(Sender: TObject; var Key: Char);
    procedure Launcher1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
    FNetworkLayer: TEzBaseLayer;
  public
    { Public declarations }
    procedure Enter;
    procedure CreateParams(var Params: TCreateParams); override;
  end;

implementation

{$R *.dfm}

uses
  Printers, fMain, fExpress, EzEntities, EzLib;

{ TfrmNetwork }

procedure TfrmNetwork.CreateParams(var Params: TCreateParams);
begin
  inherited;
  With Params Do
  Begin
    Style := Style Or ws_Overlapped;
    WndParent := fMain.Form1.Handle ;
  end;
end;

procedure TfrmNetwork.Enter;
var
  I: Integer;
begin
  for I:= 0 to fMain.Form1.GIS1.Layers.Count-1 do
  begin
    CboNetwork.Items.Add(fMain.Form1.GIS1.Layers[I].Name);
    CboResult.Items.Add(fMain.Form1.GIS1.Layers[I].Name);
  end;
  Launcher1.CmdLine := fMain.Form1.CmdLine1;
  Grid1.Cells[0,0]:= 'Routes';
  Grid1.Cells[1,0]:= 'Costs';
  Grid1.RowCount:= 2;

  CboUnits.Text:= 'Meters';

  Show;
end;

procedure TfrmNetwork.SpeedButton1Click(Sender: TObject);
begin
  ShowMessage('Warning !'#13#10'All entities in Result layer will be deleted before calculation'#13#10'Please create a special layer for this purpose');
end;

procedure TfrmNetwork.CboNetworkClick(Sender: TObject);
var
  I: Integer;
begin
  if cboNetwork.ItemIndex < 0 then exit;
  cboStartToEnd.Items.Clear;
  CboEndToStart.Items.Clear;
  CboStreetName.Items.Clear;
  FNetworkLayer:= fMain.Form1.GIS1.Layers.LayerByName( cboNetwork.Text );
  For i := 1 To FNetworkLayer.DBTable.FieldCount Do
  begin
    cboStartToEnd.Items.Add( FNetworkLayer.DBTable.Field(I) );
    CboEndToStart.Items.Add( FNetworkLayer.DBTable.Field(I) );
    CboStreetName.Items.Add( FNetworkLayer.DBTable.Field(I) );
  end;
  CboStreetName.ItemIndex:= 0;

end;

procedure TfrmNetwork.btnAssistClick(Sender: TObject);
begin
  if FNetworkLayer=Nil then exit;
  With TfrmExprDlg.Create( Application ) Do
    Try
      If Enter( cboStartToEnd.Text, fMain.Form1.Gis1, FNetworkLayer ) = mrOk Then
      begin
        cboStartToEnd.Text := Memo1.Text;
      end;
    Finally
      Free;
    End;
end;

procedure TfrmNetwork.btnAssistTClick(Sender: TObject);
begin
  if FNetworkLayer=Nil then exit;
  With TfrmExprDlg.Create( Application ) Do
    Try
      If Enter( cboEndToStart.Text, fMain.Form1.Gis1, FNetworkLayer ) = mrOk Then
      begin
        cboEndToStart.Text := Memo1.Text;
      end;
    Finally
      Free;
    End;
end;

procedure TfrmNetwork.Launcher1Finished(Sender: TObject);
begin
  LblNPts.Caption:= IntToStr( Network1.PickedPoints.Count );
  Self.Show;
end;

procedure TfrmNetwork.Button1Click(Sender: TObject);
begin
  Form1.DrawBox1.TempEntities.Clear;
  Network1.PickedPoints.Clear;
  Launcher1.TrackGenericAction('PICK_POINTS');
  Launcher1.Caption:= 'Click Stops points. <ESC> finish.';
  Hide;
end;

procedure TfrmNetwork.Launcher1KeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #27 then
    Launcher1.Finished:= True;  // causes to finish this action
end;

procedure TfrmNetwork.Launcher1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
var
  Radius: Double;
  Ellipse: TEzEntity;
begin
  Network1.PickedPoints.AddPoint( WX, WY );
  Radius:= fMain.Form1.DrawBox1.Grapher.PointsToDistY( EzNumEd1.NumericValue );
  Ellipse:= TEzEllipse.CreateEntity(Point2d(WX-Radius,WY-Radius),Point2d(WX+Radius,WY+Radius));
  with TEzEllipse( Ellipse ) do
  begin
    Pentool.Style:= 1;
    Pentool.Color:= clBlack;
    Brushtool.Pattern:=1;
    Brushtool.ForeColor:= clBlue;
  end;
  fMain.Form1.DrawBox1.TempEntities.Add(Ellipse);
  fMain.Form1.DrawBox1.Refresh;
end;

procedure TfrmNetwork.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:= caFree;
end;

procedure TfrmNetwork.Button2Click(Sender: TObject);
var
  RouteLayer: TEzBaseLayer;   // where the calculated optimal route will be placed
  I, Routeno: Integer;
begin

  RouteLayer:= fMain.Form1.GIS1.Layers.LayerByName( CboResult.Text );
  if RouteLayer = Nil then
  begin
    ShowMessage('The route layer is not defined');
    exit;
  end;
  If RouteLayer.RecordCount > 100 then
  begin
    If MessageDlg( 'Result Layer contains many records' + #13#10 + 'Are you sure to proceed ?',
      mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;
  end;

  If Length( CboStartToEnd.Text ) = 0 then
  begin
    ShowMessage('Cost expression is not defined');
    exit;
  end;
  Network1.StartToEndExpression:= CboStartToEnd.Text;
  If Length( CboEndToStart.Text ) = 0 then
  begin
    ShowMessage('Cost expression is not defined');
    exit;
  end;
  Network1.EndToStartExpression:= CboEndToStart.Text;
  If Length( CboStreetName.Text ) = 0 then
  begin
    ShowMessage('Street field name is not define');
    exit;
  end;
  Network1.StreetFieldName:= CboStreetName.Text;
  Network1.SelectedAreClosed:= chkSelected.Checked;
  Network1.Units:= CboUnits.Text;
  { calculate it }
  Network1.FindShortPath( fMain.Form1.DrawBox1, FNetworkLayer, RouteLayer );

  Memo1.Lines.Assign( Network1.Directions );

  Grid1.RowCount:= Network1.PickedPoints.Count-1+1;
  Routeno:= 0;
  For I:= 0 to Network1.PickedPoints.Count-2 do
  begin
    Inc(Routeno);
    Grid1.Cells[0,Routeno] := Format('Route %d', [Routeno] );
    Grid1.Cells[1,Routeno] := Format('Total Cost %.*n', [fMain.Form1.DrawBox1.NumDecimals, Network1.TotalCosts[RouteNo-1]] );
  end;

end;

procedure TfrmNetwork.Button3Click(Sender: TObject);
Var
  i: integer;
  PText: TextFile;
Begin
  If PrintDialog1.Execute Then
  Begin
    AssignPrn( PText );
    Rewrite( PText );
    Try
      Printer.Canvas.Font := Memo1.Font;
      For i := 0 To Memo1.Lines.Count - 1 Do
        writeln( PText, Memo1.Lines[i] );
    Finally
      CloseFile( PText );
    End;
  End;
end;

procedure TfrmNetwork.Button4Click(Sender: TObject);
begin
  FontDialog1.Font.Assign( Memo1.Font );
  If Not FontDialog1.Execute Then Exit;
  Memo1.Font.Assign( FontDialog1.Font );
end;

procedure TfrmNetwork.Button5Click(Sender: TObject);
begin
  If Not SaveDialog1.Execute Then Exit;
  Memo1.Lines.SaveToFile( SaveDialog1.FileName );
end;

end.
