unit fDxfImport;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, Dialogs,
  Messages, Buttons, ExtCtrls, EzBaseGIS, EzBasicCtrls, Grids, 
  EzDxfImport, EzCmdLine;

type
  TfrmDxfImport = class(TForm)
    DrawBox1: TEzDrawBox;
    Panel1: TPanel;
    OKBtn: TButton;
    CancelBtn: TButton;
    CmdLine1: TEzCmdLine;
    ZoomWBtn: TSpeedButton;
    ZoomIn: TSpeedButton;
    ZoomOut: TSpeedButton;
    BtnHand: TSpeedButton;
    Grid1: TStringGrid;
    Splitter1: TSplitter;
    Label1: TLabel;
    check1: TCheckBox;
    ZoomAll: TSpeedButton;
    procedure BtnHandClick(Sender: TObject);
    procedure ZoomWBtnClick(Sender: TObject);
    procedure ZoomInClick(Sender: TObject);
    procedure ZoomOutClick(Sender: TObject);
    procedure Grid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Grid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Grid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OKBtnClick(Sender: TObject);
    procedure Grid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure ZoomAllClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FDxfImport: TEzDxfImport;
    FVisible: TBitmap;
    FInVisible: TBitmap;
    FOldWidth, FOldHeight: Integer;
    procedure WMEnterSizeMove( Var m: TMessage ); Message WM_ENTERSIZEMOVE;
    procedure WMExitSizeMove( Var m: TMessage ); Message WM_EXITSIZEMOVE;
    procedure VisibleChange( Sender: TObject; const Filename: string );
  public
    { Public declarations }
    function Enter( DxfImport: TEzDxfImport ): word;
  end;

implementation

{$R *.dfm}

{ TfrmDGNImport }

function TfrmDxfImport.Enter( DxfImport: TEzDxfImport ): word;
var
  I: Integer;
begin
  FDxfImport := DxfImport;

  DrawBox1.GIS:= DxfImport.Cad;
  DrawBox1.BeginUpdate;

  DxfImport.Cad.OnVisibleLayerChange := VisibleChange;

  Grid1.RowCount:= DxfImport.Cad.Layers.Count + 1;

  Grid1.Options := Grid1.Options - [goEditing];

  Grid1.Cells[ 0, 0 ] := 'Name';
  Grid1.Cells[ 1, 0 ] := 'Visible';
  Grid1.Cells[ 2, 0 ] := 'New Target Name';
  for I:= 0 to DxfImport.Cad.Layers.Count - 1 do
  begin
    Grid1.Cells[ 0, I + 1 ] := DxfImport.Cad.Layers[I].Name;
    Grid1.Cells[ 2, I + 1 ] := DxfImport.Cad.Layers[I].Name;
  end;

  FVisible:= TBitmap.create;
  FVisible.Handle:= LoadBitmap(HInstance, 'VISIBLE');
  FVisible.Transparent:= True;
  FVisible.TransparentMode:= tmAuto;

  FInVisible:= TBitmap.create;
  FInVisible.Handle:= LoadBitmap(HInstance, 'INVISIBLE');
  FInVisible.Transparent:= True;
  FInVisible.TransparentMode:= tmAuto;

  Check1.Checked:= DxfImport.GenerateMultiLayers;

  Result:= ShowModal;
end;

procedure TfrmDxfImport.VisibleChange(Sender: TObject;
  const Filename: string);
begin
  DrawBox1.Repaint ;
end;

procedure TfrmDxfImport.BtnHandClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('SCROLL','');
end;

procedure TfrmDxfImport.ZoomWBtnClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ZOOMWIN','');
end;

procedure TfrmDxfImport.ZoomInClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ZOOMIN','');
end;

procedure TfrmDxfImport.ZoomOutClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ZOOMOUT','');
end;

procedure TfrmDxfImport.Grid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  Grid1.Options := Grid1.Options - [goEditing];
  if Check1.Checked then
  begin
    If ACol = 2 then
      Grid1.Options := Grid1.Options + [goEditing];
  end;
end;

procedure TfrmDxfImport.Grid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  X,Y: Integer;
  Layer: TEzBaseLayer;
begin
  If ( ACol = 1 ) And ( ARow > 0 ) then
  begin
    { draw the incandescent bulb }
    X:= Rect.Left + ((Rect.Right - Rect.Left ) - FVisible.Width ) div 2;
    Y:= Rect.Top  + ((Rect.Bottom - Rect.Top ) - FVisible.Height ) div 2;
    Layer:= FDxfImport.Cad.Layers[ARow - 1];
    if Layer.LayerInfo.Visible then
      Grid1.Canvas.Draw(X,Y,FVisible)
    else
      Grid1.Canvas.Draw(X,Y,FInVisible)
  end;
end;

procedure TfrmDxfImport.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FVisible.free;
  FInvisible.free;
end;

procedure TfrmDxfImport.Grid1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Layer : TEzBaseLayer;
  ACol, ARow: Integer;
  Coord: TGridCoord;
begin
  Coord:= Grid1.MouseCoord( X, Y );
  ACol := Coord.X;
  ARow := Coord.Y;
  if (ACol=1) And (ARow>0) then
  begin
    { Change layer visibility }
    Layer := FDxfImport.Cad.Layers[ARow - 1];
    Layer.LayerInfo.Visible := Not Layer.LayerInfo.Visible ;
    Grid1.Invalidate;
  end;
end;

procedure TfrmDxfImport.OKBtnClick(Sender: TObject);
var
  I, J: Integer;
  test: string;
begin
  FDxfImport.GenerateMultiLayers := Check1.Checked ;
  If Check1.Checked then
  begin
    { check for duplicate names, empty and invalid names }
    for I:= 0 to FDxfImport.TargetNames.Count-1 do
    begin
      test:= FDxfImport.TargetNames[I];
      if Length(trim(test)) = 0 then
      begin
        ShowMessage( 'Layer name cannot be empty' );
        ModalResult:= mrNone;
        Exit;
      end;
      { check if this field is a valid field name }
      For J:= 1 to Length(test) do
      begin
        If Not( test[J] In ['A'..'Z', 'a'..'z', '0'..'9', #127..#255, '_'] ) Then
        begin
          ShowMessage( Format('Not a valid layer name (%s)',[ test ] ) );
          ModalResult:= mrNone;
          Exit;
        end;
      end;

      for J:= 0 to FDxfImport.TargetNames.Count-1 do
        If ( I <> J ) And (AnsiCompareText( test, FDxfImport.TargetNames[J] ) =0 ) then
        begin
          ShowMessage( Format('Duplicate name (%s)',[ test ] ) );
          ModalResult:= mrNone;
          Exit;
        end;
    end;
  end;

  ModalResult:= mrOk;
end;

procedure TfrmDxfImport.Grid1SetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  If (ACol = 2) And (ARow > 0) then
  begin
    FDxfImport.TargetNames[ARow - 1]:= Value;
  end;
end;

procedure TfrmDxfImport.ZoomAllClick(Sender: TObject);
begin
  DrawBox1.ZoomToExtension;
end;

procedure TfrmDxfImport.WMEnterSizeMove(var m: TMessage);
begin
  inherited;
  DrawBox1.BeginUpdate;
  FOldWidth:= DrawBox1.Width;
  FOldHeight:= DrawBox1.Height;
end;

procedure TfrmDxfImport.WMExitSizeMove(var m: TMessage);
begin
  inherited;
  if (DrawBox1.Width = FOldWidth) And (DrawBox1.Height = FOldHeight) then
    DrawBox1.CancelUpdate
  else
    DrawBox1.EndUpdate;
end;

procedure TfrmDxfImport.FormShow(Sender: TObject);
begin
  DrawBox1.ZoomToExtension;
  DrawBox1.EndUpdate;
end;

end.
