unit uMStDialogImportLayer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, DB,
  //
  uGeoTypes,
  //
  uMStImport, uMStKernelSemantic;

type
  TMstDialogImportLayerForm = class(TForm, ImstImportLayerDialog)
    Label1: TLabel;
    Label2: TLabel;
    edLayerName: TEdit;
    Label3: TLabel;
    cbCoordSys: TComboBox;
    Label4: TLabel;
    lvFieldsSource: TListView;
    lvFieldsTarget: TListView;
    btnAddField: TButton;
    btnDelField: TButton;
    btnAddAll: TButton;
    btnDelAll: TButton;
    Label5: TLabel;
    Label6: TLabel;
    txtRecordCount: TStaticText;
    txtFileName: TStaticText;
    Button1: TButton;
    Button2: TButton;
    chbExchangeXY: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure lvFieldsSourceChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure lvFieldsTargetChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure btnAddFieldClick(Sender: TObject);
    procedure btnDelFieldClick(Sender: TObject);
    procedure btnAddAllClick(Sender: TObject);
    procedure btnDelAllClick(Sender: TObject);
    procedure lvFieldsTargetKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    function GetSettings(): ImstImportSettings;
    function Execute(anImport: ImstImportLayer): Boolean;
  strict private
    FImport: ImstImportLayer;
    procedure LoadFields(aFields: TmstLayerFields);
    function FindSourceField(FieldName: string): TListItem;
    function FindTargetField(FieldName: string): TListItem;
  end;

implementation

{$R *.dfm}

type
  TmstImportSettings = class(TInterfacedObject, ImstImportSettings)
  private
    function GetLayerCaption(): string;
    procedure SetLayerCaption(Value: string);
    //
    function GetMifFileName(): string;
    procedure SetMifFileName(Value: string);
    //
    function GetCoordSystem(): TCoordSystem;
    procedure SetCoordSystem(Value: TCoordSystem);
    //
    function GetFields(): TmstLayerFields;
    procedure SetFields(Value: TmstLayerFields);
    //
    function GetExchangeCoords(): Boolean;
    procedure SetExchangeCoords(Value: Boolean);
  private
    FCaption: string;
    FCoordSystem: TCoordSystem;
    FFields: TmstLayerFields;
    FMifFile: string;
    FExchangeCoords: Boolean;
  public
    constructor Create;
    destructor Destroy; override; 
  end;

{ TMstDialogImportLayerForm }

procedure TMstDialogImportLayerForm.btnAddAllClick(Sender: TObject);
var
  Itm, Itm2: TListItem;
  I: Integer;
begin
  for I := 0 to lvFieldsSource.Items.Count - 1 do
  begin
    Itm := lvFieldsSource.Items[I];
    Itm2 := FindTargetField(Itm.Caption);
    if not Assigned(Itm2) then
    begin
      Itm2 := lvFieldsTarget.Items.Add;
      Itm2.Caption := Itm.Caption;
      Itm2.SubItems.Add(Itm.SubItems[0]);
      Itm2.SubItems.Add(Itm.Caption);
    end;
  end;
end;

procedure TMstDialogImportLayerForm.btnAddFieldClick(Sender: TObject);
var
  Itm, Itm2: TListItem;
begin
  Itm := lvFieldsSource.Selected;
  if Assigned(Itm) then
  begin
    Itm2 := FindTargetField(Itm.Caption);
    if not Assigned(Itm2) then
    begin
      Itm2 := lvFieldsTarget.Items.Add;
      Itm2.Caption := Itm.Caption;
      Itm2.SubItems.Add(Itm.SubItems[0]);
      Itm2.SubItems.Add(Itm.Caption);
    end
    else
    begin
      lvFieldsTarget.Selected := Itm2;
      Itm2.MakeVisible(False);
    end;
  end;
end;

procedure TMstDialogImportLayerForm.btnDelAllClick(Sender: TObject);
begin
  lvFieldsTarget.Clear;
end;

procedure TMstDialogImportLayerForm.btnDelFieldClick(Sender: TObject);
var
  Itm, Itm2: TListItem;
begin
  Itm2 := lvFieldsTarget.Selected;
  if Assigned(Itm2) then
  begin
    Itm := FindSourceField(Itm2.SubItems[1]);
    if Assigned(Itm) then
      Itm.MakeVisible(False);
    Itm2.Delete;
  end;
end;

procedure TMstDialogImportLayerForm.Button1Click(Sender: TObject);
begin
  if Trim(edLayerName.Text) = '' then
  begin
    edLayerName.SetFocus;
    ShowMessage('¬ведите им€ сло€!');
    Exit;
  end;
  ModalResult := mrOK;
end;

function TMstDialogImportLayerForm.Execute(anImport: ImstImportLayer): Boolean;
begin
  FImport := anImport;
  txtFileName.Caption := anImport.FileName;
  txtRecordCount.Caption := IntToStr(anImport.RecordCount);
  edLayerName.Text := ChangeFileExt(ExtractFileName(anImport.FileName), '');
  chbExchangeXY.Checked := False;
  LoadFields(anImport.Fields);
  Result := ShowModal = mrOK;
end;

function TMstDialogImportLayerForm.FindSourceField(FieldName: string): TListItem;
var
  I: Integer;
  Itm: TListItem;
begin
  for I := 0 to lvFieldsSource.Items.Count - 1 do
  begin
    Itm := lvFieldsSource.Items[I];
    if Itm.Caption = FieldName then
    begin
      Result := Itm;
      Exit;
    end;
  end;
  Result := nil;
end;

function TMstDialogImportLayerForm.FindTargetField(FieldName: string): TListItem;
var
  I: Integer;
  Itm: TListItem;
begin
  for I := 0 to lvFieldsTarget.Items.Count - 1 do
  begin
    Itm := lvFieldsTarget.Items[I];
    if Itm.SubItems[1] = FieldName then
    begin
      Result := Itm;
      Exit;
    end;
  end;
  Result := nil;
end;

function TMstDialogImportLayerForm.GetSettings: ImstImportSettings;
var
  I: Integer;
  Itm: TListItem;
  SourceFld: TmstLayerField;
begin
  Result := TmstImportSettings.Create;
  Result.LayerCaption := edLayerName.Text;
  Result.MifFileName := FImport.FileName;
  if cbCoordSys.ItemIndex = 0 then  
    Result.CoordSystem := csMCK36
  else
    Result.CoordSystem := csVrn;
  Result.ExchangeCoords := chbExchangeXY.Checked;
  for I := 0 to lvFieldsTarget.Items.Count - 1 do
  begin
    Itm := lvFieldsTarget.Items[I];
    SourceFld := FImport.Fields.Find(Itm.SubItems[1]);
    with Result.Fields.AddNew do
    begin
      Caption := Itm.Caption;
      Name := Itm.SubItems[1];
      DataTypeName := SourceFld.DataTypeName;
      Length := SourceFld.Length;
    end;
  end;
 end;

procedure TMstDialogImportLayerForm.LoadFields(aFields: TmstLayerFields);
var
  Itm: TListItem;
  I: Integer;
begin
  lvFieldsSource.Clear;
  for I := 0 to aFields.Count - 1 do
  begin
    Itm := lvFieldsSource.Items.Add();
    Itm.Caption := aFields[I].Name;
    Itm.SubItems.Add(aFields[I].DataTypeName);
  end;
end;

procedure TMstDialogImportLayerForm.lvFieldsSourceChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  if lvFieldsSource.Selected <> nil then
  begin
    btnAddField.Enabled := True;
//    btnAddAll.Enabled := lvFieldsSource.Items.Count > 0;
  end;
end;

procedure TMstDialogImportLayerForm.lvFieldsTargetChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  btnDelField.Enabled := lvFieldsTarget.Selected <> nil;
end;

procedure TMstDialogImportLayerForm.lvFieldsTargetKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F2 then
  begin
    if lvFieldsTarget.Selected <> nil then
      lvFieldsTarget. Selected.EditCaption();
  end;
end;

{ TmstImportSettings }

constructor TmstImportSettings.Create;
begin
  FFields := TmstLayerFields.Create;
end;

destructor TmstImportSettings.Destroy;
begin
  FFields.Free;
  inherited;
end;

function TmstImportSettings.GetCoordSystem: TCoordSystem;
begin
  Result := FCoordSystem;
end;

function TmstImportSettings.GetExchangeCoords: Boolean;
begin
  Result := FExchangeCoords;
end;

function TmstImportSettings.GetFields: TmstLayerFields;
begin
  Result := FFields;
end;

function TmstImportSettings.GetLayerCaption: string;
begin
  Result := FCaption;
end;

function TmstImportSettings.GetMifFileName: string;
begin
  Result := FMifFile;
end;

procedure TmstImportSettings.SetCoordSystem(Value: TCoordSystem);
begin
  FCoordSystem := Value;
end;

procedure TmstImportSettings.SetExchangeCoords(Value: Boolean);
begin
  FExchangeCoords := Value;
end;

procedure TmstImportSettings.SetFields(Value: TmstLayerFields);
begin
  FFields := Value;
end;

procedure TmstImportSettings.SetLayerCaption(Value: string);
begin
  FCaption := Value;
end;

procedure TmstImportSettings.SetMifFileName(Value: string);
begin
  FMifFile := Value;
end;

end.
