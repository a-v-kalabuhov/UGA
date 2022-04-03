unit fSymbolType;

{$I EZ_FLAG.PAS}
interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, EzBaseGis, EzBase, dialogs, Mask, EzNumEd,
  EzMiscelCtrls;

type
  TfrmSymbolStyle = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEzNumEd;
    symList1: TEzSymbolsListBox;
    procedure FormDestroy(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
    FDrawBox: TEzBaseDrawBox;
    FSymboltool: TEzSymbolTool;
  public
    { Public declarations }
    function Enter(DrawBox: TEzBaseDrawBox): Word;
  end;

implementation

{$R *.dfm}

uses
  EzEntities, EzSystem, EzLib, fMain;

{ TfrmSymbolStyle }

function TfrmSymbolStyle.Enter(DrawBox: TEzBaseDrawBox): Word;
var
  SelLayer: TEzSelectionLayer;
  Entity: TEzEntity;

  procedure InitGlobally;
  begin
    FSymboltool.Assign(Ez_Preferences.DefSymbolStyle);
  end;

begin
  FDrawBox:= DrawBox;

  FSymboltool:= TEzSymbolTool.Create;

  with DrawBox do
  begin
    if Selection.NumSelected = 1 then
    begin
      SelLayer:= Selection[0];
      Entity:= SelLayer.Layer.LoadEntityWithRecno(SelLayer.SelList[0]);
      try
        if Entity is TEzPlace then
          FSymboltool.Assign(TEzPlace(Entity).Symboltool)
        else
          InitGlobally;
      finally
        Entity.Free;
      end;
    end else
    begin
      InitGlobally;
    end;
  end;
  if FSymbolTool.Index > Ez_Symbols.Count-1 then
     FSymbolTool.Index:= Ez_Symbols.Count-1;
  symList1.ItemIndex:= FSymbolTool.Index;
  Edit1.NumericValue:= FDrawBox.Grapher.GetSizeInPoints(FSymbolTool.Height);

  result:= ShowModal;
end;

procedure TfrmSymbolStyle.FormDestroy(Sender: TObject);
begin
  FSymboltool.Free;
end;

procedure TfrmSymbolStyle.OKBtnClick(Sender: TObject);
var
  SelLayer:TEzSelectionLayer;
  Entity:TEzEntity;
  I,J:Integer;

  procedure UpdateGlobally;
  begin
    Ez_Preferences.DefSymbolStyle.Assign(FSymbolTool);
  end;

begin
  FSymbolTool.Index:= symList1.ItemIndex;
  FSymboltool.Height:= FDrawBox.Grapher.PointsToDistY(Edit1.NumericValue);
  with FDrawBox do
  begin
    if Selection.Count>0 then 
    begin
      for I:=0 to Selection.Count-1 do
      begin
        SelLayer:= Selection[I];
        for J:=0 to SelLayer.SelList.Count-1 do
        begin
          Entity:= SelLayer.Layer.LoadEntityWithRecno(SelLayer.SelList[J]);
          try
            if Entity is TEzPlace then
            begin
              TEzPlace(Entity).Symboltool.Assign(FSymboltool);
              SelLayer.Layer.UpdateEntity(SelLayer.SelList[J],Entity);
            end
            else
              UpdateGlobally;
          finally
            Entity.Free;
          end;
        end;
      end;
    end else
      UpdateGlobally;
  end;
end;

procedure TfrmSymbolStyle.FormPaint(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to Self.ControlCount - 1 do
    ShadeIt(Self, Self.Controls[i], 3, clGray);
end;

end.
