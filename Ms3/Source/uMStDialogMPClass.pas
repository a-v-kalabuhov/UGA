unit uMStDialogMPClass;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TmstMPClassDialog = class(TForm)
    edLayerName: TEdit;
    cbProjectLayer: TComboBox;
    cbMPLayer: TComboBox;
    btnOK: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure edLayerNameChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FMPNetTypes: TStrings;
    FNetTypes: TStrings;
    function GetLayerName: string;
    function GetMPNetTypeId: Integer;
    function GetNetTypeId: Integer;
    procedure SetLayerName(const Value: string);
    procedure SetMPNetTypeId(const Value: Integer);
    procedure SetMPNetTypes(const Value: TStrings);
    procedure SetNetTypeId(const Value: Integer);
    procedure SetNetTypes(const Value: TStrings);
  private
    FId: Integer;
    FLayerNames: TStrings;
    function DoCheckLayerName(): Boolean;
    procedure SetId(const Value: Integer);
  public
    function EditLayer(): Boolean;
    //
    property Id: Integer read FId write SetId;
    property LayerName: string read GetLayerName write SetLayerName;
    property LayerNames: TStrings read FLayerNames write FLayerNames;
    property NetTypeId: Integer read GetNetTypeId write SetNetTypeId;
    property MPNetTypeId: Integer read GetMPNetTypeId write SetMPNetTypeId;
    property NetTypes: TStrings read FNetTypes write SetNetTypes;
    property MPNetTypes: TStrings read FMPNetTypes write SetMPNetTypes;
  end;

var
  mstMPClassDialog: TmstMPClassDialog;

implementation

{$R *.dfm}

procedure TmstMPClassDialog.btnOKClick(Sender: TObject);
begin
  if Trim(edLayerName.Text) = '' then
  begin
    ShowMessage('Нужно указать имя слоя в DXF!');
    edLayerName.SetFocus;
    Exit;
  end;
  if not DoCheckLayerName() then
  begin
    ShowMessage('Слой с таким именем уже есть в классификаторе!');
    edLayerName.SetFocus;
    Exit;
  end;
//  if cbProjectLayer.ItemIndex < 0 then
//  begin
//    ShowMessage('Нужно указать слой для проектов!');
//    cbProjectLayer.SetFocus;
//    Exit;
//  end;
  if cbMPLayer.ItemIndex < 0 then
  begin
    ShowMessage('Нужно указать слой для сводного плана!');
    cbMPLayer.SetFocus;
    Exit;
  end;
  ModalResult := mrOk;
end;

function TmstMPClassDialog.DoCheckLayerName: Boolean;
var
//  LayerExists: Boolean;
  I, aId: Integer;
begin
  Result := True;
  if Assigned(FLayerNames) then
  begin
    for I := 0 to FLayerNames.Count - 1 do
    begin
      if FLayerNames[I] = edLayerName.Text then
      begin
        aId := Integer(FLayerNames.Objects[I]);
        if aId <> FId then
        begin
          Result := False;
          Exit;
        end;
      end;
    end;
  end;
end;

function TmstMPClassDialog.EditLayer: Boolean;
begin
  Result := ShowModal = mrOK;
end;

procedure TmstMPClassDialog.edLayerNameChange(Sender: TObject);
begin
  Caption := 'Класс - ' + edLayerName.Text;
end;

procedure TmstMPClassDialog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  mstMPClassDialog := nil;
  Action := caFree;
end;

function TmstMPClassDialog.GetLayerName: string;
begin
  Result := edLayerName.Text;
end;

function TmstMPClassDialog.GetMPNetTypeId: Integer;
var
  I: Integer;
begin
  I := cbMPLayer.ItemIndex;
  Result := Integer(FMPNetTypes.Objects[I]);
end;

function TmstMPClassDialog.GetNetTypeId: Integer;
var
  I: Integer;
begin
  I := cbProjectLayer.ItemIndex;
  if I < 0 then
    Result := -1
  else
    Result := Integer(FNetTypes.Objects[I]);
end;

procedure TmstMPClassDialog.SetId(const Value: Integer);
begin
  FId := Value;
end;

procedure TmstMPClassDialog.SetLayerName(const Value: string);
begin
  edLayerName.Text := Value;
end;

procedure TmstMPClassDialog.SetMPNetTypeId(const Value: Integer);
var
  I, J, K: Integer;
begin
  K := -1;
  for I := 0 to FMPNetTypes.Count - 1 do
  begin
    J := Integer(FMPNetTypes.Objects[I]);
    if J = Value then
    begin
      K := I;
      Break;
    end;
  end;
  cbMPLayer.ItemIndex := K;
end;

procedure TmstMPClassDialog.SetMPNetTypes(const Value: TStrings);
begin
  FMPNetTypes := Value;
  cbMPLayer.Items.Assign(FMPNetTypes);
end;

procedure TmstMPClassDialog.SetNetTypeId(const Value: Integer);
var
  I, J, K: Integer;
begin
  K := -1;
  for I := 0 to FNetTypes.Count - 1 do
  begin
    J := Integer(FNetTypes.Objects[I]);
    if J = Value then
    begin
      K := I;
      Break;
    end;
  end;
  cbProjectLayer.ItemIndex := K;
end;

procedure TmstMPClassDialog.SetNetTypes(const Value: TStrings);
begin
  FNetTypes := Value;
  cbProjectLayer.Items.Clear();
  cbProjectLayer.Items.Assign(FNetTypes);
end;

end.
