Unit fSelec;

{***********************************************************}
{   EzGis select entities                                   }
{   (c) 2002 EzSoft Engineering                             }
{   All Rights Reserved                                     }
{***********************************************************}

{$I EZ_FLAG.PAS}
Interface

Uses Windows, Messages, SysUtils, Classes, Forms, Controls, StdCtrls, dialogs,
  Buttons, ExtCtrls, EzBaseGis, Db, EzSystem, ComCtrls, EzCmdLine, ezlib,
  EzTable, EzNumEd, Grids, DBGrids, EzActionLaunch, fExpressBuilder,
  fSpatialQuery, fVectorialExpr, Menus, CheckLst;

Type
  TfrmSelectDlg = Class( TForm )
    Panel1: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    LblRecCount: TLabel;
    btnall: TSpeedButton;
    btnnone: TSpeedButton;
    BtnClear: TSpeedButton;
    Button2: TSpeedButton;
    Button3: TSpeedButton;
    Button6: TSpeedButton;
    Button4: TSpeedButton;
    Button5: TSpeedButton;
    DBGrid1: TDBGrid;
    Button10: TButton;
    DataSource1: TDataSource;
    Table1: TEzTable;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Panel2: TPanel;
    MemoWhere: TMemo;
    Button1: TSpeedButton;
    BtnAddFlds: TSpeedButton;
    SpeedButton1: TSpeedButton;
    PopupMenu1: TPopupMenu;
    StandardExpression1: TMenuItem;
    VectorialExpression1: TMenuItem;
    JOINLayersExpression1: TMenuItem;
    CheckList1: TCheckListBox;
    Procedure Button6Click( Sender: TObject );
    Procedure BtnClearClick( Sender: TObject );
    Procedure Button3Click( Sender: TObject );
    Procedure Button2Click( Sender: TObject );
    Procedure Button5Click( Sender: TObject );
    Procedure Button4Click( Sender: TObject );
    Procedure FormClose( Sender: TObject; Var Action: TCloseAction );
    Procedure Button7Click( Sender: TObject );
    procedure btnallClick(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure BtnAddFldsClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure StandardExpression1Click(Sender: TObject);
    procedure VectorialExpression1Click(Sender: TObject);
    procedure JOINLayersExpression1Click(Sender: TObject);
  Private
    { Private declarations }
    FLayer: TEzBaseLayer;
    FDrawBox: TEzBaseDrawBox;
    FCmdLine: TEzCmdLine;
    FfrmVectorialExpr: TfrmVectorialExpr;
    FfrmSpatialQuery:TfrmSpatialQuery;
    //Procedure PopulatePointList( V: TEzVector );
{$IFDEF LEVEL3}
    Procedure CreateParams( Var Params: TCreateParams ); Override;
{$ENDIF}
  Public
    { Public declarations }
    Procedure Enter( DrawBox: TEzBaseDrawBox; CmdLine: TEzCmdLine;
      ALayer: TEzBaseLayer );
{$IFDEF LEVEL4}
    Procedure CreateParams( Var Params: TCreateParams ); Override;
{$ENDIF}

    property frmVectorialExpr: TfrmVectorialExpr read FfrmVectorialExpr write FfrmVectorialExpr;
    property frmSpatialQuery:TfrmSpatialQuery read FfrmSpatialQuery write FfrmSpatialQuery;
  End;

var
  ParentSelectHWND: THandle;

Implementation

{$R *.DFM}

Uses
  Inifiles, EzEntities, ezbase, EzConsts, fExpress, fMain;

Resourcestring
  SWrongNumberOfPoints = 'Wrong number of points for entity';
  SQueryRecCount = '%d records';
  SUnassignedReport= 'Report does not exists for this layer. Designer will be launched';

{ TfrmSelectDlg }

Procedure TfrmSelectDlg.Enter( DrawBox: TEzBaseDrawBox; CmdLine: TEzCmdLine; ALayer: TEzBaseLayer );
var
  i, w: integer;
Begin
  ActiveControl:= MemoWhere;
  FLayer := ALayer;
  FDrawBox := DrawBox;
  FCmdLine := CmdLine;
  // fill the list of fields
  FLayer.PopulateFieldList( CheckList1.Items );
  for I:= 0 to CheckList1.Items.Count-1 do
    CheckList1.Checked[I]:= True;

  Table1.Gis := DrawBox.Gis;
  Table1.LayerName := ALayer.Name;

  Caption := Caption + ' - ' + ALayer.Name;

  Show;
End;
{$IFDEF LEVEL3}

Procedure TfrmSelectDlg.CreateParams( Var Params: TCreateParams );
Begin
  Inherited CreateParams( Params );
  With Params Do
  Begin
    Style := Style Or ws_Overlapped;
    WndParent := ParentSelectHWND;
  End;
End;
{$ENDIF}
Procedure TfrmSelectDlg.Button6Click( Sender: TObject );
Var
  I{, CurvePoints}: Integer;
  //Distance: Double;
  //Ent: TEzEntity;
  //Operator: TEzGraphicOperator;
  s: String;
  //Points: TEzVector;
  //IsGraphicOperatorInExpression: Boolean;
{$ifdef false}
  Column: TdxDBTreeListColumn;
  ColumnClass: TdxDBTreeListColumnClass;
{$endif}
Begin
  s := Trim( MemoWhere.Text );
  Table1.Close;
  Table1.MapFields.Clear;
  For I := 0 To CheckList1.Items.Count - 1 Do
  begin
    if CheckList1.Checked[I] then
      With Table1.MapFields.Add Do
      Begin
        Expression := CheckList1.Items[I];
        FieldName := Expression;
        IsExpression := true;
      End;
  end;
  Screen.Cursor := crSQLWait;
  Try
    Table1.ScopeFilter( MemoWhere.Text, True );

    Table1.Open;
  Finally
    Screen.Cursor := crDefault;
  End;
  LblRecCount.Caption := Format( SQueryRecCount, [Table1.RecordCount] );
End;

Procedure TfrmSelectDlg.BtnClearClick( Sender: TObject );
Begin
  Table1.Close;
  FDrawBox.Selection.Clear;
  LblRecCount.Caption := '';
End;

Procedure TfrmSelectDlg.Button3Click( Sender: TObject );
Begin
  If Not Table1.Active Then
  begin
    Exit;
  end;
  FDrawBox.SetEntityInViewEx(
    Table1.LayerName, Table1.SourceRecno, True );
End;

Procedure TfrmSelectDlg.Button2Click( Sender: TObject );
Begin
  If Not Table1.Active Then
  begin
    Exit;
  end;
  FDrawBox.BlinkEntityEx(Table1.LayerName, Table1.SourceRecno );
End;

Procedure TfrmSelectDlg.Button5Click( Sender: TObject );
Begin
  FDrawBox.ZoomToSelection;
End;

Procedure TfrmSelectDlg.Button4Click( Sender: TObject );
Var
  SavedRecNo: Integer;
Begin
  // select the result set
  If Not Table1.Active Then
  begin
    Exit;
  end;
  Table1.DisableControls;
  SavedRecNo := Table1.RecNo;
  Try
    FDrawBox.Selection.Clear;
    Table1.First;
    While Not Table1.Eof Do
    Begin
      FDrawBox.Selection.Add( FLayer, Table1.SourceRecNo );

      Table1.Next;
    End;
  Finally
    Table1.RecNo := SavedRecNo;
    Table1.EnableControls;
  End;
  FDrawBox.Repaint;
End;

Procedure TfrmSelectDlg.FormClose( Sender: TObject; Var Action: TCloseAction );
Begin
  If FfrmVectorialExpr <> Nil Then FreeAndNil(FfrmVectorialExpr);
  If FfrmSpatialQuery <> Nil Then FreeAndNil(FfrmSpatialQuery);
  Action := caFree;
End;

Procedure TfrmSelectDlg.Button7Click( Sender: TObject );
Begin
End;

{Procedure TfrmSelectDlg.PopulatePointList( V: TEzVector );
Begin
  Memo1.Text := V.AsString;
End; }

procedure TfrmSelectDlg.btnallClick(Sender: TObject);
var
  I:Integer;
begin
  For I := 0 To CheckList1.Items.Count - 1 Do
  begin
    if Sender = btnAll then
      CheckList1.Checked[I]:= True
    else
      CheckList1.Checked[I]:= False;
  end;
end;

procedure TfrmSelectDlg.Button10Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmSelectDlg.BtnAddFldsClick(Sender: TObject);
begin
  if not SaveDialog1.Execute then exit;
  memoWhere.Lines.SaveToFile(SaveDialog1.FileName);
end;

procedure TfrmSelectDlg.SpeedButton1Click(Sender: TObject);
begin
  if not OpenDialog1.Execute then exit;
  memoWhere.Lines.LoadFromFile(OpenDialog1.FileName);
end;

procedure TfrmSelectDlg.Button1Click(Sender: TObject);
var
  TmpPt: TPoint;
begin
  TmpPt := Self.ClientToScreen(Point(Button1.Left,Button1.Top + Button1.Height));
  Popupmenu1.Popup( TmpPt.x, TmpPt.y );
end;

procedure TfrmSelectDlg.StandardExpression1Click(Sender: TObject);
begin
  with TfrmExprBuilder.create(nil) do
    try
      Edit1.Text:= MemoWhere.Text;
      If Enter(FLayer)=mrOk then
        MemoWhere.Text:= Edit1.Text;
    finally
      free;
    end;
end;

procedure TfrmSelectDlg.VectorialExpression1Click(Sender: TObject);
begin
  If FfrmVectorialExpr = Nil Then
    FfrmVectorialExpr:=TfrmVectorialExpr.create(nil);
  FfrmVectorialExpr.Enter(Self, FDrawBox, FCmdLine,FLayer);
end;

procedure TfrmSelectDlg.JOINLayersExpression1Click(Sender: TObject);
begin
  If FfrmSpatialQuery = Nil Then
    FfrmSpatialQuery:=TfrmSpatialQuery.create(nil);
  FfrmSpatialQuery.Enter(self,self.FDrawBox,self.FCmdLine,self.FLayer);
end;

End.
