unit uMStDialogMissingLayers;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TMStMissingLayersDialog = class(TForm)
    ListBox1: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure FormShow(Sender: TObject);
  private
    FObjectsCount: Integer;
    FCanContinue: Boolean;
    procedure SetLayers(const Value: TStrings);
    function GetLayers: TStrings;
    procedure SetObjectsCount(const Value: Integer);
    procedure SetCanContinue(const Value: Boolean);
  public
    property CanContinue: Boolean read FCanContinue write SetCanContinue;
    property Layers: TStrings read GetLayers write SetLayers;
    property ObjectsCount: Integer read FObjectsCount write SetObjectsCount;
  end;

var
  MStMissingLayersDialog: TMStMissingLayersDialog;

implementation

{$R *.dfm}

{ TMStMissingLayersDialog }

procedure TMStMissingLayersDialog.FormShow(Sender: TObject);
begin
  Label2.Font.Style := Label2.Font.Style + [fsBold]; 
end;

function TMStMissingLayersDialog.GetLayers: TStrings;
begin
  Result := ListBox1.Items;
end;

procedure TMStMissingLayersDialog.SetCanContinue(const Value: Boolean);
begin
  FCanContinue := Value;
  Button2.Visible := Value;
  if Value then
    Button1.Caption := 'Импорт'
  else
    Button1.Caption := 'OK';
end;

procedure TMStMissingLayersDialog.SetLayers(const Value: TStrings);
begin
  ListBox1.Items.Assign(Value);
end;

procedure TMStMissingLayersDialog.SetObjectsCount(const Value: Integer);
begin
  FObjectsCount := Value;
  Label2.Caption := IntToStr(Value);
end;

end.
