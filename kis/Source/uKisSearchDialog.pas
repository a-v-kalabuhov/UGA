{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Диалог поиска                                   }
{                                                       }
{       Copyright (c) 2004-2005, МП УГА                 }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание:
  Имя модуля: Search Dialog
  Версия: 1.03
  Дата последнего изменения: 16.06.2005
  Цель:
  Используется:
  Использует:
  Исключения: нет }

{
  1.03        16.06.2005
      - ширина генерируемых контролов устанавливается автоматически
        (раньше была константа)

  1.02        26.08.2004
      - при выборе булевого поля комбобокс имеет стиль csDropDownList

  1.01
      - добавлен признак FGenerating
}

unit uKisSearchDialog;

interface

{$I KisFlags.pas}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, ExtCtrls, DB, ComCtrls, uKisSearchClasses;

type
  TKisSearchDialog = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    cbTables: TComboBox;
    Label2: TLabel;
    cbFields: TComboBox;
    GroupBox2: TGroupBox;
    btnOK: TButton;
    btnCancel: TButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    CheckBox1: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    chbEmptyField: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnOKClick(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
  private
    FField: TKisField;
    FFieldType: TFieldType;
    FControl1, FControl2: TWinControl;
    FGenerating: Boolean;
    procedure FreeControls;
    procedure CreateStringControls;
    procedure CreateBooleanControls;
    procedure CreateDateControls;
    procedure CreateFloatControls;
    procedure CreateIntegerControls;
    procedure CreateLookupControls;
    procedure FloatKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure IntKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    function GetValueControlWidth: Integer;
    procedure UpdateEmptyCheckBox;
  public
    procedure GenerateControls(AField: TKisField);
    //
    property Control1: TWinControl read FControl1;
    property Control2: TWinControl read FControl2;
    property Field: TKisField read FField;
    property FieldType: TFieldType read FFieldType;
  end;

implementation

{$R *.dfm}

uses
  uKisConsts, uKisAppModule;

const
//  VALUECONTROLWIDTH = 181;
  S_SEARCHCONDITION1 = 'Точное соответсвие';
  S_SEARCHCONDITION2 = 'Искать подобное';
  S_SEARCHCONDITION_RANGE = 'Диапазон';
  S_SEARCHCONDITION_CASE = 'С учетом регистра';

{ TKisSearchDialog }

procedure TKisSearchDialog.GenerateControls(AField: TKisField);
begin
  if FGenerating then
    Exit;
  FGenerating := True;
  //
  FField := AField;
  if AField.FLookUp then
  begin
    FreeControls;
    CreateLookUpControls;
    FFieldType := ftUnknown;
  end
  else
  begin
    case AField.DataType of
    ftString, ftMemo, ftFmtMemo, ftFixedChar, ftWideString, ftBlob:
      begin
        if FFieldType <> AField.DataType then
        begin
          FreeControls;
          CreateStringControls;
        end;
      end;
    ftSmallint, ftInteger, ftWord:
      begin
        if FFieldType <> AField.DataType then
        begin
          FreeControls;
          CreateIntegerControls;
        end;
        FControl2.Visible := RadioButton2.Checked;
        Label3.Visible := RadioButton2.Checked;
        Label4.Visible := RadioButton2.Checked;
      end;
    ftBoolean:
      begin
        if FFieldType <> AField.DataType then
        begin
          FreeControls;
          CreateBooleanControls;
        end;
      end;
    ftFloat:
      begin
        if FFieldType <> AField.DataType then
        begin
          FreeControls;
          CreateFloatControls;
        end;
        FControl2.Visible := RadioButton2.Checked;
        Label3.Visible := RadioButton2.Checked;
        Label4.Visible := RadioButton2.Checked;
      end;
    ftDate, ftDateTime:
      begin
        if FFieldType <> AField.DataType then
        begin
          FreeControls;
          CreateDateControls;
        end;
        FControl2.Visible := RadioButton2.Checked;
        Label3.Visible := RadioButton2.Checked;
        Label4.Visible := RadioButton2.Checked;
      end;
    ftUnknown:
      Exit;
    else
      FGenerating := False;
      raise Exception.Create(S_UNSUPPORTED_FIELD_TYPE);
    end;
    FFieldType := AField.DataType;
  end;
  UpdateEmptyCheckBox;
  FGenerating := False; 
end;

procedure TKisSearchDialog.FormCreate(Sender: TObject);
begin
  FFieldType := ftUnknown;
  RadioButton1.Checked := True;
end;

procedure TKisSearchDialog.FreeControls;
begin
  FreeAndNil(FControl1);
  FreeAndNil(FControl2);
end;

procedure TKisSearchDialog.CreateStringControls;
begin
  Label3.Visible := False;
  Label4.Visible := False;
  RadioButton1.Visible := True;
  RadioButton1.Caption := S_SEARCHCONDITION1;
  RadioButton2.Visible := True;
  RadioButton2.Caption := S_SEARCHCONDITION2;
  RadioButton2.Checked := True;
  FControl1 := TEdit.Create(Self);
  FControl1.Parent := GroupBox2;
  FControl1.Top := cbTables.Top;
  FControl1.Left := cbTables.Left;
  FControl1.Width := GetValueControlWidth;
  Self.ActiveControl := FControl1;
  CheckBox1.Caption := S_SEARCHCONDITION_CASE;
  CheckBox1.Visible := True;
  UpdateEmptyCheckBox;
end;

procedure TKisSearchDialog.btnOKClick(Sender: TObject);
var
  CanClose: Boolean;
  DlgRes: Integer;
begin
  CanClose := True;
  if FField.FLookUp or (FFieldType = ftBoolean) then
    if TComboBox(FControl1).ItemIndex < 0 then
    begin
      CanClose := False;
      MessageBox(Handle, 'Значение поля не выбрано!'#13'Пожалуйста, выберите значение из списка!',
        'Вниманние', MB_OK + MB_ICONWARNING);
      FControl1.SetFocus;
    end;
  if CanClose then
  begin
    if (not chbEmptyField.Visible) or (not chbEmptyField.Checked) then
    case FFieldType of
      ftString, ftMemo, ftFmtMemo, ftFixedChar, ftWideString, ftBlob:
        begin
          if Trim(TEdit(FControl1).Text) = '' then
          begin
            DlgRes := MessageBox(Handle, 'Искать пустые поля?',
                'Требуется подтверждение', MB_YESNOCANCEL + MB_ICONQUESTION);
            if DlgRes = ID_CANCEL then
              CanClose := False
            else
            if DlgRes = ID_YES then
              chbEmptyField.Checked := True;
          end;
        end;
    end;
  end;
  //
  if CanClose then
    ModalResult := mrOK;
end;

procedure TKisSearchDialog.CreateBooleanControls;
begin
  Label3.Visible := False;
  Label4.Visible := False;
  RadioButton1.Visible := False;
  RadioButton2.Visible := False;
  FControl1 := TComboBox.Create(Self);
  FControl1.Parent := GroupBox2;
  FControl1.Top := cbTables.Top;
  FControl1.Width := getValueControlWidth;
  FControl1.Left := cbTables.Left;
  Self.ActiveControl := FControl1;
  with FControl1 as TComboBox do
  begin
    Style := csDropdownList;
    Items.Add(S_NO);
    Items.Add(S_YES);
    ItemIndex := 1;
  end;
  CheckBox1.Visible := False;
  UpdateEmptyCheckBox;
end;

procedure TKisSearchDialog.CreateDateControls;
begin
  RadioButton1.Visible := True;
  RadioButton1.Caption := S_SEARCHCONDITION1;
  RadioButton2.Visible := True;
  RadioButton2.Caption := S_SEARCHCONDITION_RANGE;
  FControl1 := TDateTimePicker.Create(Self);
  FControl1.Parent := GroupBox2;
  FControl1.Top := cbTables.Top;
  FControl1.Left := cbTables.Left;
  FControl1.Width := GetValueControlWidth;
  Self.ActiveControl := FControl1;
  FControl2 := TDateTimePicker.Create(Self);
  FControl2.Parent := GroupBox2;
  FControl2.Top := cbFields.Top;
  FControl2.Width := getValueControlWidth;
  FControl2.Left := cbTables.Left;
  CheckBox1.Visible := False;
  UpdateEmptyCheckBox;
end;

procedure TKisSearchDialog.CreateFloatControls;
begin
  RadioButton1.Visible := True;
  RadioButton1.Caption := S_SEARCHCONDITION1;
  RadioButton2.Visible := True;
  RadioButton2.Caption := S_SEARCHCONDITION_RANGE;
  FControl1 := TEdit.Create(Self);
  FControl1.Parent := GroupBox2;
  FControl1.Top := cbTables.Top;
  FControl1.Width := GetValueControlWidth;
  FControl1.Left := cbTables.Left;
  Self.ActiveControl := FControl1;
  TEdit(FControl1).OnKeyUp := FloatKeyUp;
  FControl2 := TEdit.Create(Self);
  FControl2.Parent := GroupBox2;
  FControl2.Top := cbFields.Top;
  FControl2.Width := GetValueControlWidth;
  FControl2.Left := cbTables.Left;
  TEdit(FControl2).OnKeyUp := FloatKeyUp;
  CheckBox1.Visible := False;
  UpdateEmptyCheckBox;
end;

procedure TKisSearchDialog.IntKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not (Key in IntegerEditKeys) then
    Key := 0;
end;

procedure TKisSearchDialog.RadioButton1Click(Sender: TObject);
begin
  UpdateEmptyCheckBox;
end;

procedure TKisSearchDialog.RadioButton2Click(Sender: TObject);
begin
  UpdateEmptyCheckBox;
end;

procedure TKisSearchDialog.UpdateEmptyCheckBox;
var
  DT: TFieldType;
begin
  if Assigned(FField) then
    DT := FField.DataType
  else
    DT := FFieldType;
  case DT of
  ftString, ftMemo, ftFmtMemo, ftFixedChar, ftWideString, ftBlob:
    chbEmptyField.Visible := True;
  ftSmallint, ftInteger, ftWord:
    chbEmptyField.Visible := RadioButton1.Checked;
  ftBoolean:
    chbEmptyField.Visible := False;
  ftFloat:
    chbEmptyField.Visible := RadioButton1.Checked;
  ftDate, ftDateTime:
    chbEmptyField.Visible := RadioButton1.Checked;
  ftUnknown:
    chbEmptyField.Visible := False;
  end;
end;

procedure TKisSearchDialog.FloatKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not (Key in FloatEditKeys) then
    Key := 0;
end;

procedure TKisSearchDialog.CreateIntegerControls;
begin
  RadioButton1.Visible := True;
  RadioButton1.Caption := S_SEARCHCONDITION1;
  RadioButton2.Visible := True;
  RadioButton2.Caption := S_SEARCHCONDITION_RANGE;
  FControl1 := TEdit.Create(Self);
  FControl1.Parent := GroupBox2;
  FControl1.Top := cbTables.Top;
  FControl1.Width := GetValueControlWidth;
  FControl1.Left := cbTables.Left;
  Self.ActiveControl := FControl1;
  TEdit(FControl1).OnKeyUp := IntKeyUp;
  FControl2 := TEdit.Create(Self);
  FControl2.Parent := GroupBox2;
  FControl2.Top := cbFields.Top;
  FControl2.Width := GetValueControlWidth;
  FControl2.Left := cbTables.Left;
  TEdit(FControl2).OnKeyUp := IntKeyUp;
  CheckBox1.Visible := False;
  UpdateEmptyCheckBox;
end;

procedure TKisSearchDialog.CreateLookupControls;
begin
  Label3.Visible := False;
  Label4.Visible := False;
  RadioButton1.Visible := False;
  RadioButton2.Visible := False;
  FControl1 := TComboBox.Create(Self);
  FControl1.Parent := GroupBox2;
  FControl1.Top := cbTables.Top;
  FControl1.Width := GetValueControlWidth;
  FControl1.Left := cbTables.Left;
  Self.ActiveControl := FControl1;
  with FControl1 as TComboBox do
  begin
    Style := csDropdownList;
    AppModule.GetLookupValues(nil, FField.FLookUpTable, FField.FLookUpKey,
      FField.FLookUpValue, Items);
    ItemIndex := 0;
  end;
  CheckBox1.Visible := False;
  UpdateEmptyCheckBox;
end;

procedure TKisSearchDialog.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    ModalResult := mrOK;
end;

function TKisSearchDialog.GetValueControlWidth: Integer;
begin
  Result := GroupBox2.Width - 2 * cbTables.Left;
end;

end.
