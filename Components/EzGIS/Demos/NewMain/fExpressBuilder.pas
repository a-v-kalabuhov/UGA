unit fExpressBuilder;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Buttons, ExtCtrls,
  ezbase,ezbasegis,ezlib;

type
  TfrmExprBuilder = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    LBFields: TListBox;
    Splitter1: TSplitter;
    Panel4: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    cboOp1: TComboBox;
    cboOp2: TComboBox;
    Grid1: TStringGrid;
    Grid2: TStringGrid;
    cboOp3: TComboBox;
    Grid3: TStringGrid;
    cboOp4: TComboBox;
    Grid4: TStringGrid;
    cboOp5: TComboBox;
    Grid5: TStringGrid;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Edit1: TMemo;
    procedure Button3Click(Sender: TObject);
    procedure LBFieldsClick(Sender: TObject);
    procedure Grid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
    FLayer: TEzBaseLayer;
    procedure BuildExpression;
    procedure ConfigureGrids;
    procedure DoCOnfigure(Index:integer;Grid:TStringGrid);
  public
    { Public declarations }
    function Enter(Layer: TEzBaseLayer):Word;
  end;

implementation

uses
  fExpress;

{$R *.dfm}

{ TfrmExprBuilder }

function TfrmExprBuilder.Enter(Layer: TEzBaseLayer): Word;
var
  Identifier, LayerName: string;
  Accept:boolean;
begin
  Caption:= Caption + ' For Layer ' + Layer.Name;
  FLayer:=Layer;
  Layer.PopulateFieldList(LBFields.Items, False);
  with Layer.Layers do
    if Assigned( Gis.OnStartExternalPopulate ) And
       Assigned( Gis.OnExternalPopulate ) then
    begin
      Accept:= True;
      Gis.OnStartExternalPopulate( Gis, Layer.Name, Accept );
      if Accept then
      begin
        Identifier := '';
        Gis.OnExternalPopulate( Gis, Layer.Name, Identifier );
        LayerName:= Layer.Name;
        if AnsiPos( #32, LayerName ) > 0 then
          Identifier:= '[' + LayerName + ']';
        While Length( Identifier ) > 0 do
        begin
          if AnsiPos( #32, Identifier ) > 0 then
            Identifier:= '[' + Identifier + ']';
          lbFields.Items.AddObject( LayerName + '.' + Identifier, Pointer(1) );
          Identifier := '';
          Gis.OnExternalPopulate( Gis, Layer.Name, Identifier );
        end;
        if Assigned( Gis.OnEndExternalPopulate ) then
          Gis.OnEndExternalPopulate( Gis, Layer.Name );
      End;
    end;

  DoCOnfigure(1, Grid1);
  DoCOnfigure(1, Grid2);
  DoCOnfigure(1, Grid3);
  DoCOnfigure(1, Grid4);
  DoCOnfigure(1, Grid5);

  result:=showmodal;
end;

procedure TfrmExprBuilder.Button3Click(Sender: TObject);
begin
  LBFields.ItemIndex:=-1;
  cboOp1.ItemIndex:=0;
  cboOp2.ItemIndex:=0;
  cboOp3.ItemIndex:=0;
  cboOp4.ItemIndex:=0;
  cboOp5.ItemIndex:=0;
  Grid1.ColCount:=1;
  Grid1.Cells[0,0]:='';
  Grid2.ColCount:=1;
  Grid2.Cells[0,0]:='';
  Grid3.ColCount:=1;
  Grid3.Cells[0,0]:='';
  Grid4.ColCount:=1;
  Grid4.Cells[0,0]:='';
  Grid5.ColCount:=1;
  Grid5.Cells[0,0]:='';
  ConfigureGrids;
end;

procedure TfrmExprBuilder.DoCOnfigure(Index:integer;Grid:TStringGrid);
var
  sbh: integer;
begin
  sbh:= GetSystemMetrics(SM_CXHTHUMB);
  Grid.DefaultColWidth:=120;
  case Index of
    1,2,3,4,5,6,11,12,13,14:
      begin
      Grid.ColCount:=1;
      Grid.Width:= Grid.DefaultColWidth+6;
      Grid.height:=Grid.DefaultRowHeight;
      end;
    7,8:
      begin
      Grid.ColCount:=2;
      Grid.Width:= Grid.DefaultColWidth*2+8;
      Grid.height:=Grid.DefaultRowHeight;
      end;
    9,10:
      begin
      Grid.ColCount:=100;
      Grid.Width:= Grid.DefaultColWidth*2+8;
      Grid.height:=Grid.DefaultRowHeight + sbh;
      end;
  else
      begin
      Grid.ColCount:=1;
      Grid.Width:= Grid.DefaultColWidth+6;
      Grid.height:=Grid.DefaultRowHeight;
      end;
  end;
end;

procedure TfrmExprBuilder.ConfigureGrids;
begin
  DoConfigure(cboOp1.ItemIndex,Grid1);
  DoConfigure(cboOp2.ItemIndex,Grid2);
  DoConfigure(cboOp3.ItemIndex,Grid3);
  DoConfigure(cboOp4.ItemIndex,Grid4);
  DoConfigure(cboOp5.ItemIndex,Grid5);
end;

procedure TfrmExprBuilder.BuildExpression;
var
  temp,s,FieldName: string;
  Fieldtype:Char;

  function GetPartial( cbo: TComboBox; Grid: TStringGrid):string;
  var
    i:integer;
    temp,temp2: string;
  begin
    result:='';
    if cbo.ItemIndex<=0 then exit;
    case cbo.ItemIndex of
      1:result:='= ' + Grid.Cells[0,0];
      2:result:='<> ' + Grid.Cells[0,0];
      3:result:='> ' + Grid.Cells[0,0];
      4:result:='>= ' + Grid.Cells[0,0];
      5:result:='< ' + Grid.Cells[0,0];
      6:result:='<= ' + Grid.Cells[0,0];
      7,8:
        begin
          If cbo.ItemIndex=7 then temp2:='' else temp2:='not ';
          If FieldType = 'C' Then
            result:=format('%sbetween "%s" and "%s"',[temp2,Grid.Cells[0,0],Grid.Cells[1,0]])
          else
            result:=format('%sbetween %s and %s',[temp2,Grid.Cells[0,0],Grid.Cells[1,0]]);
        end;
      9,10:
        begin
          temp:='';
          for i:= 0 to Grid.ColCount-1 do
            if Length(trim(Grid.Cells[i,0]))>0 then
            begin
              If FieldType = 'C' Then
                temp:= temp + #34+Grid.Cells[i,0]+', '
              else
                temp:= temp + Grid.Cells[i,0]+', ';
            end;
          temp:=copy(temp,1,length(temp)-1);
          If cbo.ItemIndex=9 then
            result:=format('in (%s)',[temp])
          else
            result:=format('not in (%s)',[temp])
        end;
      11:result:=format('like "%s%%"',[Grid.Cells[0,0]]);
      12:result:=format('like "%%%s"',[Grid.Cells[0,0]]);
      13:result:=format('like "%%%s%%"',[Grid.Cells[0,0]]);
      14:result:=format('not like "%%%s%%"',[Grid.Cells[0,0]]);
    else
      Result:='';
    end;

  end;

begin
  If LbFields.ItemIndex<1 then exit;
  FieldName:= LbFields.Items[LbFields.ItemIndex];
  FieldType:= FLayer.DBTable.FieldType(FLayer.DBTable.FieldNo(FieldName));
  s:=GetPartial(cboOp1, Grid1);
  if length(s) > 0 then temp:= '(' + FieldName + #32 + s + ')';
  s:=GetPartial(cboOp2, Grid2);
  if length(s) > 0 then temp:= temp + format(' Or (%s %s)',[Fieldname,s]);
  s:=GetPartial(cboOp3, Grid3);
  if length(s) > 0 then temp:= temp + format(' Or (%s %s)',[Fieldname,s]);
  s:=GetPartial(cboOp4, Grid4);
  if length(s) > 0 then temp:= temp + format(' Or (%s %s)',[Fieldname,s]);
  s:=GetPartial(cboOp5, Grid5);
  if length(s) > 0 then temp:= temp + format(' Or (%s %s)',[Fieldname,s]);

  Edit1.Text:= temp;

end;

procedure TfrmExprBuilder.LBFieldsClick(Sender: TObject);
begin
  BuildExpression;
  ConfigureGrids;
end;

procedure TfrmExprBuilder.Grid1SetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  BuildExpression;
end;

procedure TfrmExprBuilder.Button4Click(Sender: TObject);
begin
  With TfrmExprDlg.Create( Application ) Do
    Try
      If Enter( Edit1.Text, FLayer.Layers.Gis, FLayer ) = mrOk Then
      begin
        Edit1.Text := Memo1.Text;
      end;
    Finally
      Free;
    End;
end;

end.
