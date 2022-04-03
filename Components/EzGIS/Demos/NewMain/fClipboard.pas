unit fClipboard;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, EzBaseGIS, EzBasicCtrls, EzCADCtrls, EzCmdLine,
  EzLib, EzActionLaunch;

type
  TfrmClipboard = class(TForm)
    CAD1: TEzCAD;
    DrawBox1: TEzDrawBox;
    CmdLine1: TEzCmdLine;
    Launcher1: TEzActionLauncher;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Launcher1Finished(Sender: TObject);
    procedure Launcher1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; const WX, WY: Double);
    procedure Launcher1KeyPress(Sender: TObject; var Key: Char);
    procedure Launcher1Paint(Sender: TObject);
    procedure Launcher1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
    procedure FormResize(Sender: TObject);
    procedure Launcher1SuspendOperation(Sender: TObject);
    procedure Launcher1ContinueOperation(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FCentroid: TEzPoint;
    FLastPoint: TEzPoint;
    procedure PaintClipboardContent;
  public
    { Public declarations }
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Enter(FromInternalClipboard: Boolean);
  end;


implementation

{$R *.dfm}

uses
  Clipbrd, EzSystem, fMain;

procedure TfrmClipboard.CreateParams(var Params: TCreateParams);
begin
  Inherited CreateParams( Params );
  With Params Do
  Begin
    Style := Style Or ws_Overlapped;
    WndParent := fMain.Form1.Handle;
  end;
end;

procedure TfrmClipboard.Enter(FromInternalClipboard: Boolean);
var
  n: Integer;
  Layer: TEzBaseLayer;
  ent: TEzEntity;
  TmpCent: TEzPoint;
begin
  { create one layer }
  Cad1.CreateNew(''); // dummy file
  Cad1.Layers.CreateNew('A0',nil);    // create one layer
  Cad1.MapInfo.Extension:= INVALID_EXTENSION;
  { set current layer }
  Cad1.CurrentLayerName:= 'A0';
  If FromInternalClipboard Then
    { paste from Internal "clipboard" }
    fMain.Form1.DrawBox.Undo.PasteFromClipboardTo(Cad1)
  Else
    { paste from internal "clipboard" }
    CmdLine1.DoCommand(Clipboard.AsText, '');
  { calculate centroid of all entities }
  Layer:= Cad1.Layers[0];
  n:= 0;
  Layer.First;
  while not Layer.Eof do
  begin
    Ent:= Layer.RecLoadEntity;
    If n = 0 then
      Ent.Centroid(FCentroid.X, FCentroid.Y)
    Else
    Begin
      Ent.Centroid(TmpCent.X, TmpCent.Y);
      FCentroid.X:= FCentroid.X + TmpCent.X;
      FCentroid.Y:= FCentroid.Y + TmpCent.Y;
    End;
    Inc(n);

    Layer.next;
  end;
  If n=0 then
  begin
    Close;
    exit;
  end;
  FCentroid.X:= FCentroid.X / n;
  FCentroid.Y:= FCentroid.Y / n;

  FLastPoint:= INVALID_POINT;

  { now connect the TEzActionLauncher to the fMain.Form1.CmdLine1
   TEzActionLauncher will be used for moving the pasted entities on the main
   form DrawBox1 and when clicked, it will be pased to the current layer }
  Launcher1.CmdLine:= fMain.Form1.CmdLine1;
  Launcher1.TrackGenericAction('');
  fMain.Form1.CmdLine1.AccuDraw.ChangeOrigin(FCentroid);

  Show;

  HideFormTitleBar(Self);
end;

procedure TfrmClipboard.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:= caFree;
end;

procedure TfrmClipboard.FormDestroy(Sender: TObject);
begin
  { if you move this to the FormClose event, it will causes an AV when you
    explicitly close the form with the system button }
  Launcher1.Finish;
  fMain.Form1.frmClipboard:= Nil;
end;

procedure TfrmClipboard.FormShow(Sender: TObject);
begin
  DrawBox1.ZoomToExtension;
end;

procedure TfrmClipboard.PaintClipboardContent;
var
  Layer: TEzMemoryLayer;
  Ent: TEzEntity;
  M: TEzMatrix;
{$IFDEF FALSE}
  I: Integer;
  SaveID: Integer;
  SaveM: TEzMatrix;
{$ENDIF}
Begin
  M:= Translate2d( FLastPoint.X - FCentroid.X, FLastPoint.Y - FCentroid.Y);
  Layer:= Cad1.Layers[0] As TEzMemoryLayer;
{$IFDEF FALSE}
  { it can be done with this also }
  For I:= 1 to Layer.Entities.Count do
  Begin
    If Layer.IsDeleted(I) Then Continue;
    { the following line is direct access to the in-memory entity. This way
     a copy of that entity is not needed to build }
    Ent:= TEzEntity(Layer.Entities[I-1]);
    SaveID:= Ent.ID;
    SaveM:= Ent.GetTransformMatrix;
    Ent.SetTransformMatrix( M );
    Ent.ID:=-2;
    fMain.Form1.DrawBox1.DrawEntity2DRubberBand( Ent );
    Ent.SetTransformMatrix( SaveM );
    Ent.ID:= SaveID;
  End;
{$ENDIF}
  Layer.First;
  While not Layer.Eof do
  Begin
    Ent:= Layer.RecLoadEntity;
    Try
      Ent.SetTransformMatrix( M );
      Ent.ID:=-2;
      fMain.Form1.DrawBox.DrawEntity2DRubberBand( Ent );
    Finally
      Ent.Free;
    End;
    Layer.Next;
  End;
End;

procedure TfrmClipboard.Launcher1Finished(Sender: TObject);
begin
  Release;  // if the action is finished some way, close this form
end;

procedure TfrmClipboard.Launcher1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
begin
  If Not EqualPoint2d( FLastPoint, INVALID_POINT) Then
    PaintClipboardContent;
  { create a transform matrix that is the move from all entities centroid to current point }
  FLastPoint:= fMain.Form1.CmdLine1.GetSnappedPoint;
  PaintClipboardContent;
end;

procedure TfrmClipboard.Launcher1KeyPress(Sender: TObject; var Key: Char);
begin
  If Key=#27 then
  begin
    PaintClipboardContent;
    Launcher1.Finished:= true;
  end;
end;

procedure TfrmClipboard.Launcher1Paint(Sender: TObject);
begin
  PaintClipboardContent;
end;

procedure TfrmClipboard.Launcher1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer; const WX,
  WY: Double);
var
  SourceLayer, DestLayer: TEzBaseLayer;
  Ent: TEzEntity;
  UpdateR,EntR: TEzRect;
begin
  PaintClipboardContent;
  { the entities on the clipboard are added to the current layer }
  SourceLayer:= Cad1.Layers[0];
  DestLayer:= fMain.Form1.GIS.CurrentLayer;
  If DestLayer = Nil then Exit; // no current layer
  UpdateR:= INVALID_EXTENSION;
  SourceLayer.First;
  while not SourceLayer.Eof do
  begin
    Ent:= SourceLayer.RecLoadEntity;
    try
      Ent.SetTransformMatrix( Translate2d( FLastPoint.X - FCentroid.X, FLastPoint.Y - FCentroid.Y) );
      Ent.ApplyTransform;
      DestLayer.AddEntity( Ent );
      EntR:= Ent.FBox;
      EzLib.MaxBound( UpdateR.Emax, EntR.Emax );
      EzLib.MinBound( UpdateR.Emin, EntR.Emin );
    finally
      Ent.free;
    end;
    SourceLayer.Next;
  end;
  fMain.Form1.DrawBox.RepaintRect(UpdateR);
  PaintClipboardContent;
end;

procedure TfrmClipboard.FormResize(Sender: TObject);
begin
  DrawBox1.ZoomToExtension;
end;

procedure TfrmClipboard.Launcher1SuspendOperation(Sender: TObject);
begin
  { usually these events are fired by the AccuSnap when needs to draw its bitmaps
    indicating tentative snap points.
    If you don't define these events you will see strange paintings on your drawing }
  PaintClipboardContent;
end;

procedure TfrmClipboard.Launcher1ContinueOperation(Sender: TObject);
begin
  PaintClipboardContent;
end;

procedure TfrmClipboard.FormKeyPress(Sender: TObject; var Key: Char);
begin
  If Key=#27 then Close;
  If AnsiUpperCase(Key) = 'S' then ShowFormTitleBar(Self);
  If AnsiUpperCase(Key) = 'H' then HideFormTitleBar(Self);
end;

end.
