unit fAddPlace;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, EzMiscelCtrls, EzNumEd, EzActionLaunch,
  EzBaseGis;

type
  TfrmAddPlace = class(TForm)
    SymbList1: TEzSymbolsListBox;
    Panel1: TPanel;
    CboSize: TComboBox;
    Launcher1: TEzActionLauncher;
    NumEd1: TEzNumEd;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure CboSizeChange(Sender: TObject);
    procedure NumEd1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Launcher1KeyPress(Sender: TObject; var Key: Char);
    procedure Launcher1Finished(Sender: TObject);
    procedure Launcher1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; const WX, WY: Double);
    procedure Launcher1Paint(Sender: TObject);
    procedure Launcher1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
    procedure Launcher1SuspendOperation(Sender: TObject);
    procedure Launcher1ContinueOperation(Sender: TObject);
    procedure SymbList1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FPlace: TEzEntity;    // the entity to add
    procedure UpdatePosition;
  public
    { Public declarations }
    procedure CreateParams(var Params: TCreateParams); override;
  end;

implementation

{$R *.dfm}

uses
  fMain, EzEntities, ezlib, ezbase, EzSystem;

{ TfrmAddPlace }

procedure TfrmAddPlace.CreateParams(var Params: TCreateParams);
begin
  Inherited CreateParams( Params );
  With Params Do
  Begin
    Style := Style Or ws_Overlapped;
    WndParent := fMain.Form1.Handle;
  end;
end;

procedure TfrmAddPlace.FormCreate(Sender: TObject);
begin
  { create the entity }
  FPlace:= TEzPlace.CreateEntity( Point2d(0,0) );
  Launcher1.CmdLine:= fMain.Form1.CmdLine1;
  cboSize.ItemIndex:= 5;
  NumEd1.NumericValue:= fMain.Form1.DrawBox1.Grapher.DistToRealY(StrToIntDef(cboSize.Text, 12));
  SymbList1.ItemIndex:= Ez_Preferences.DefSymbolStyle.Index;
  TEzPlace(FPlace).Symboltool.Index:=SymbList1.ItemIndex;
  TEzPlace(FPlace).Symboltool.Height:= NumEd1.NumericValue;

  Launcher1.TrackGenericAction('');
  Launcher1.Caption:= 'Click on a point on the map to add a symbol';
end;

procedure TfrmAddPlace.UpdatePosition;
begin
  { erase previous symbol }
  fMain.Form1.CmdLine1.All_DrawEntity2DRubberBand(FPlace);
  { change height of symbol}
  TEzPlace(FPlace).Symboltool.Height:= NumEd1.NumericValue;
  { draw new one }
  fMain.Form1.CmdLine1.All_DrawEntity2DRubberBand(FPlace);
end;

procedure TfrmAddPlace.CboSizeChange(Sender: TObject);
begin
  NumEd1.NumericValue:= fMain.Form1.cmdLine1.ActiveDrawBox.Grapher.PointsToDistY(StrToIntDef(cboSize.Text, 9));
  UpdatePosition;
  fMain.Form1.SetFocus;
end;

procedure TfrmAddPlace.NumEd1Change(Sender: TObject);
begin
  cboSize.Text:=
    IntToStr(Trunc( fMain.Form1.cmdLine1.ActiveDrawBox.Grapher.DistToPointsY(NumEd1.NumericValue) ));
  UpdatePosition;
  fMain.Form1.SetFocus;
end;

procedure TfrmAddPlace.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:= caFree;
end;

procedure TfrmAddPlace.Launcher1KeyPress(Sender: TObject; var Key: Char);
begin
  If Key=#27 then
  begin
    Launcher1.Finished:= true;
  end;
end;

procedure TfrmAddPlace.Launcher1Finished(Sender: TObject);
begin
  Close;
end;

procedure TfrmAddPlace.Launcher1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
var
  CurrPoint: TEzPoint;
begin
  { erase previous one }
  fMain.Form1.cmdLine1.All_DrawEntity2DRubberBand(FPlace);
  { update position}
  CurrPoint:= fMain.Form1.CmdLine1.GetSnappedPoint;
  FPlace.Points[0]:= CurrPoint;
  { draw new one }
  fMain.Form1.cmdLine1.All_DrawEntity2DRubberBand(FPlace);
end;

procedure TfrmAddPlace.Launcher1Paint(Sender: TObject);
begin
  { repaint entity rubber banding }
  (Sender As TEzBaseDrawBox).DrawEntity2DRubberBand(FPlace);
end;

procedure TfrmAddPlace.Launcher1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
var
  Layer: TEzBaseLayer;
  Accept: Boolean;
  Recno: Integer;
  Box: TEzRect;
  MinDim:Double;
  CurrPoint: TEzPoint;
begin
  { add the entity to the current layer }
  fMain.Form1.cmdLine1.All_DrawEntity2DRubberBand(FPlace,false,false);
  Layer:= fMain.Form1.GIS.CurrentLayer;
  try
    If Layer = Nil Then Exit;

    { check if the entity is accepted }
    Accept:= True;
    If Assigned( fMain.Form1.DrawBox1.OnBeforeInsert ) Then
      fMain.Form1.DrawBox1.OnBeforeInsert( Self, Layer, FPlace, Accept );
    If Not Accept Then Exit;

    { add the entity }
    CurrPoint:= fMain.Form1.CmdLine1.GetSnappedPoint;

    FPlace.Points[0]:= CurrPoint;

    Recno:= Layer.AddEntity( FPlace );
    If Assigned( fMain.Form1.DrawBox1.OnAfterInsert ) Then
      fMain.Form1.DrawBox1.OnAfterInsert( Self, Layer, Recno );

    { update accudraw position }
    fMain.Form1.CmdLine1.AccuDraw.UpdatePosition( CurrPoint, CurrPoint );

    { in order to avoid repainting all the map, repaint only the area occupied by the new entity }
    Box:= FPlace.FBox;
    { add a small margin for limits of symbol (5 pixels) }
    MinDim := fMain.Form1.cmdLine1.ActiveDrawBox.Grapher.DistToRealY( 5 );
    InflateRect2D( Box, MinDim, MinDim );
    fMain.Form1.cmdLine1.All_RepaintRect( Box );

  finally
    { repaint again the entity rubber banding in order to allow adding symbols }
    fMain.Form1.cmdLine1.All_DrawEntity2DRubberBand(FPlace);
  end;
end;

procedure TfrmAddPlace.Launcher1SuspendOperation(Sender: TObject);
begin
  { this occurs at several times during execution of this action, like when
    snapping to entities, suspending this action and runing other, etc.
  }
  fMain.Form1.cmdLine1.All_DrawEntity2DRubberBand(FPlace,false,false);
end;

procedure TfrmAddPlace.Launcher1ContinueOperation(Sender: TObject);
begin
  { this happens when this action is restarted after stopping temporary }
  fMain.Form1.cmdLine1.All_DrawEntity2DRubberBand(FPlace,false,false);
end;

procedure TfrmAddPlace.SymbList1Click(Sender: TObject);
begin
  { erase current drawing symbol }
  fMain.Form1.cmdLine1.All_DrawEntity2DRubberBand(FPlace,false,false);
  { change size of symbol }
  TEzPlace(FPlace).SymbolTool.Index:= SymbList1.ItemIndex;
  { draw new one }
  fMain.Form1.cmdLine1.All_DrawEntity2DRubberBand(FPlace,false,false);
end;

procedure TfrmAddPlace.FormDestroy(Sender: TObject);
begin
  { if you move this to the FormClose event, it will causes an AV when you
    explicitly close the form with the system button }
  Launcher1.Finish;
  fMain.Form1.BtnSymbolMult.Down:=false;
  FPlace.Free;
  fMain.Form1.frmAddPlace:= Nil;
end;

end.
