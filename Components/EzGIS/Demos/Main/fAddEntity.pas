unit fAddEntity;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ezbasegis;

type
  TfrmAddEntity = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Label1: TLabel;
    Memo1: TMemo;
    Label2: TLabel;
    Memo2: TMemo;
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
    FDrawBox:TEzBaseDrawBox;
  public
    { Public declarations }
    function Enter(DrawBox: TEzBaseDrawBox):Word;
  end;

implementation

{$R *.DFM}

function TfrmAddEntity.Enter(DrawBox: TEzBaseDrawBox): Word;
begin
  FDrawBox:= DrawBox;
  result:=showmodal;
end;

procedure TfrmAddEntity.OKBtnClick(Sender: TObject);
var
  ent:TEzEntity;
begin
  FDrawBox.AddEntityFromText('',Memo2.Text);  // '' = current layer
  ent:= FDrawBox.Gis.CurrentLayer.LoadEntityWithRecno(FDrawBox.Gis.CurrentLayer.RecordCount);
  if ent=nil then exit;
  try
    FDrawBox.RepaintRect(ent.FBox);
  finally
    ent.free;
  end;
end;

end.
