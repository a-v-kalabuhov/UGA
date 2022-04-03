Unit fEasyThematic;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, Grids, ComCtrls, StdCtrls, CheckLst, DBGrids, Db, math,
  EzTable, ExtCtrls, EzSystem, EzCmdLine, EzLib, Ezbase, Ezconsts,
  EzBaseGis, EzEntities, Mask, EzThematics, EzMiscelCtrls,
  EzColorPicker;

Type
  TfrmEasyThematic = Class( TForm )
    cmdSearchCompXY_0: TButton;
    Bevel2: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label10: TLabel;
    CLStart: TEzColorBox;
    CLEnd: TEzColorBox;
    MERange: TMaskEdit;
    UpDown5: TUpDown;
    CBfields: TCheckListBox;
    CBZero: TCheckBox;
    Label11: TLabel;
    Label12: TLabel;
    Label3: TLabel;
    Label13: TLabel;
    btnClose: TButton;
    cmdDraw: TButton;
    Procedure btnCloseClick( Sender: TObject );
    Procedure FormClose( Sender: TObject; Var Action: TCloseAction );
    Procedure cmdDrawClick( Sender: TObject );
    Procedure CBfieldsClick( Sender: TObject );
  Private
    { Private declarations }
    FDrawBox: TEzBaseDrawBox;
    FBuilder: TEzThematicBuilder;
    FLayer: TEzBaseLayer;

    Function GetSelected: integer;
  Public
    { Public declarations }
    Procedure Enter( DrawBox: TEzBaseDrawBox; Builder: TEzThematicBuilder);
  End;

Implementation

{$R *.DFM}

Resourcestring
  SSelectLayer = 'Layer to select';

Procedure TfrmEasyThematic.btnCloseClick( Sender: TObject );
Begin
  Close;
End;

Procedure TfrmEasyThematic.FormClose( Sender: TObject;
  Var Action: TCloseAction );
Begin
  Action := caFree;
End;

Function TfrmEasyThematic.GetSelected: integer;
Var
  i: integer;
Begin
  result := 0;
  For i := 0 To CBFields.Items.Count - 1 Do
    If CBFields.Checked[i] Then
    Begin
      result := result + 1;
    End;
End;

Procedure TfrmEasyThematic.CBfieldsClick( Sender: TObject );
Var
  intPos, intCnt: Integer;
Begin
  intCnt := 0;

  For intPos := 0 To CBFields.items.count - 1 Do
    If CBFields.Checked[intPos] Then
      inc( intCnt );

  cmdDraw.Enabled := intCnt > 0;

End;

Procedure TfrmEasyThematic.cmdDrawClick( Sender: TObject );
Var
  fNum: longint;
  i, j: longint;
  sstr, Tstr: String;

  Function RGB( r, g, b: byte ): Integer;
  Begin
    Result := 65536 * ( b ) + 256 * ( g ) + r;
  End;

Begin

  fNum := getselected;
  If fNum > 20 Then
  Begin
    MessageToUser( SMBToomanyfields, smsgerror, MB_ICONINFORMATION );
    Exit;
  End;
  If fnum = 0 Then Exit;

  sstr := '';
  tstr := '';
  j := CBFields.items.count - 1;
  For i := 0 To j Do
  Begin
    If CBFields.Checked[i] Then
    Begin
      sstr := CBFields.Items[i];
      tstr := tstr + sstr + ';'
    End;
  End;

  If copy( tstr, length( tstr ), 1 ) = ';' Then
    tstr := copy( tstr, 1, length( tstr ) - 1 );

  With Ez_Preferences.DefPenStyle Do
  Begin
    Style := 1;
    Color := clblack;
    width := 0;
  End;

  sstr := cbfields.items[cbfields.itemindex];
  FBuilder.CreateAutomaticThematicRange( FLayer.Layers.Gis,
    UpDown5.Position,
    flayer.name,
    sstr,
    clstart.Selected,
    clend.Selected,
    1,
    clstart.Selected,
    clend.Selected,
    1,
    false,
    true,
    CBZero.checked,
    false,
    2000,
    2 );
End;

Procedure TfrmEasyThematic.Enter( DrawBox: TEzBaseDrawBox; Builder: TEzThematicBuilder);
Var
  k: integer;
Begin
  FDrawBox:= DrawBox;
  FBuilder := Builder;
  If Builder.Layername = '' Then Exit;

  Flayer := FDrawBox.Gis.Layers.LayerByName( Builder.Layername );

  If ( FLayer <> Nil ) And ( FLayer.dbTable <> Nil ) Then
  Begin
    For k := 1 To FLayer.dbTable.FieldCount Do
    Begin
      If Not ( FLayer.dbTable.FieldType( k ) In ['F', 'N', 'I'] ) Then
        continue;
      CBFields.Items.Add( FLayer.dbTable.Field( k ) );
    End;
  End
  Else
    exit;

  Showmodal;
End;

End.
