unit uMStDialogDxfImportOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  uMStKernelTypes, uMStModuleProjectImport;

type
  TMStDxfImportOptionsDialog = class(TForm)
    ListBox1: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Label8: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    FImport: TmstProjectImportModule;
    FOnXYChanged: TChangedEvent;
    FOnCK36Changed: TChangedEvent;
    procedure SetOnXYChanged(const Value: TChangedEvent);
    procedure SetOnCK36Changed(const Value: TChangedEvent);
  public
    procedure DisplayDialog(Import: TmstProjectImportModule);
    property OnCK36Changed: TChangedEvent read FOnCK36Changed write SetOnCK36Changed;
    property OnXYChanged: TChangedEvent read FOnXYChanged write SetOnXYChanged;
  end;

var
  mstDxfImportOptionsDialog: TMStDxfImportOptionsDialog;

implementation

{$R *.dfm}

procedure TMStDxfImportOptionsDialog.Button1Click(Sender: TObject);
begin
  if FImport.LinesCount = 0 then
  begin
    ShowMessage('Нет осевых линий для импорта!');
    Exit;
  end;
  Close;
  try
    FImport.EndImport(False);
  except
    FImport.EndImport(True);
  end;
end;

procedure TMStDxfImportOptionsDialog.Button2Click(Sender: TObject);
begin
  Close;
  FImport.EndImport(True);
end;

procedure TMStDxfImportOptionsDialog.CheckBox1Click(Sender: TObject);
begin
  if Assigned(FOnCK36Changed) then
    FOnCK36Changed(Self, CheckBox1.Checked);
end;

procedure TMStDxfImportOptionsDialog.CheckBox2Click(Sender: TObject);
begin
  if Assigned(FOnXYChanged) then
    FOnXYChanged(Self, CheckBox2.Checked);
end;

procedure TMStDxfImportOptionsDialog.DisplayDialog(Import: TmstProjectImportModule);
begin
  FImport := Import;
  Label2.Caption := IntToStr(Import.RecordCount);
  Label4.Caption := IntToStr(Import.RecordToImport);
  Label6.Caption := IntToStr(Import.LinesCount);
  Label8.Caption := IntToStr(Import.MissingLayers.Count);
  ListBox1.Items.Assign(Import.MissingLayers);
  CheckBox1.Checked := Import.CK36;
  CheckBox2.Checked := Import.ExchangeXY;
  Top := 0;
  Left := 0;
  Show;
end;

procedure TMStDxfImportOptionsDialog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FOnCK36Changed := nil;
  FOnXYChanged := nil;
end;

procedure TMStDxfImportOptionsDialog.FormShow(Sender: TObject);
begin
  Label2.Font.Style := Label2.Font.Style + [fsBold];
  Label4.Font.Style := Label4.Font.Style + [fsBold];
  Label6.Font.Style := Label6.Font.Style + [fsBold];
  Label8.Font.Style := Label8.Font.Style + [fsBold];
end;

procedure TMStDxfImportOptionsDialog.SetOnCK36Changed(const Value: TChangedEvent);
begin
  FOnCK36Changed := Value;
end;

procedure TMStDxfImportOptionsDialog.SetOnXYChanged(const Value: TChangedEvent);
begin
  FOnXYChanged := Value;
end;

end.
