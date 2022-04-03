unit fLayerSelect;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, EzBaseGis;

type
  TfrmSelectLayer = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    List1: TListBox;
    Label1: TLabel;
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Enter(Gis: TEzBaseGis):Word;
  end;

  function GetLayerFromDialog(Gis: TEzBaseGis): TEzBaseLayer;

implementation

{$R *.DFM}

function GetLayerFromDialog(Gis: TEzBaseGis): TEzBaseLayer;
begin
  Result:=nil;
  with TfrmSelectLayer.create(Nil) do
    try
      if Enter(Gis)=mrOk then
      begin
        result:=TEzBaseLayer(List1.Items.Objects[List1.ItemIndex]);
      end;
    finally
      free;
    end;
end;

{ TfrmSelectLayer }

function TfrmSelectLayer.Enter(Gis: TEzBaseGis): Word;
var
  I:Integer;
  Layer: TEzBaseLayer;
begin
  for I:=0 to Gis.Layers.Count-1 do
  begin
    Layer:= Gis.Layers[I];
    List1.Items.AddObject(Layer.Name,Layer);
  end;
  if List1.Items.Count>0 then List1.ItemIndex:= 0;
  result:=showmodal;
end;

procedure TfrmSelectLayer.OKBtnClick(Sender: TObject);
begin
  if List1.ItemIndex >=0 then
  begin
    ModalResult:= mrOk;
  end else
    ModalResult:= mrCancel;
end;

end.
