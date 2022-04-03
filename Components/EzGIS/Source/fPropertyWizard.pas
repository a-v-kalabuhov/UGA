unit fPropertyWizard;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, EzInspect, ExtCtrls, Buttons, ComCtrls;

type

  TCreateAction = (caClone, caCreate);

  TfrmPropertyWizard = class(TForm)
    Label3: TLabel;
    Label4: TLabel;
    Inspector: TEzInspector;
    btnOk: TButton;
    btnCancel: TButton;
    chkReadOnly: TCheckBox;
    chkModified: TCheckBox;
    chkEdit: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    edName: TEdit;
    cboType: TComboBox;
    chkTrueType: TCheckBox;
    btnEdit: TSpeedButton;
    speIdentLevel: TEdit;
    UpDown1: TUpDown;
    procedure FormCreate(Sender: TObject);
    procedure chkReadOnlyClick(Sender: TObject);
    procedure cboTypeClick(Sender: TObject);
    procedure InspectorPropertyChange(Sender: TObject;
      const PropertyName: String);
    procedure FormShow(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
  private
    { Private declarations }
    FBp : TEzBaseProperty;
    FIndex : Integer;
    Procedure UpdateProperties;
  public
    { Public declarations }
    Function CreateNewProperty : TEzBaseProperty;
    Function ModifyProperty(Var p: TEzBaseProperty) : Boolean;
  end;

  Function CreatePropertyByIndex(Index : Integer; Clone : TEzBaseProperty;
    const Name : String; Action : TCreateAction) : TEzBaseProperty;

implementation

uses
  fEnumAndSetItemsEditor, CheckLst;

{$R *.DFM}

function TfrmPropertyWizard.CreateNewProperty: TEzBaseProperty;
begin
  Result := Nil;
  If ShowModal = mrOk Then Begin
    Result := CreatePropertyByIndex(FIndex, FBp, edName.Text, caClone);
    If Result <> Nil Then Begin
      With Result Do Begin
        ValString := FBp.ValString;
        ValInteger := Fbp.ValInteger;
        ValFloat := Fbp.ValFloat;
        ValDateTime := FBp.ValDatetime;
        ValBoolean := FBp.ValBoolean;
        UseEditButton := chkEdit.Checked;
        Modified := chkModified.Checked;
        IndentLevel := Updown1.Position;
        ReadOnly := chkReadOnly.Checked;
      End;
      If Result Is TEzFontNameProperty Then
        TEzFontNameProperty(Result).TrueType := chkTrueType.Checked;
    End;
  End;
end;

function TfrmPropertyWizard.ModifyProperty(
  var p: TEzBaseProperty): Boolean;
Var
  Tmp : TEzBaseProperty;
begin
  Result := True;
  edName.Text := p.PropName;
  Updown1.Position := p.IndentLevel;
  chkReadOnly.Checked := p.ReadOnly;
  chkEdit.Checked := p.UseEditButton;
  If p Is TEzFontNameProperty Then Begin
    chkTrueType.Enabled := True;
    chkTrueType.Checked := (p As TEzFontNameProperty).TrueType;
  End;
  FIndex := Ord(PropertyTypeOf(p));
  FBp := CreatePropertyByIndex(FIndex, p, edName.Text, caClone);
  cboType.ItemIndex := FIndex;
  Inspector.ClearPropertyList;
  Inspector.AddProperty(FBp);
  Inspector.Invalidate;
  btnEdit.Enabled := (FBp Is TEzEnumerationProperty) Or (FBp Is TEzSetProperty);
//  cboType.OnClick(cboType);
  Tmp := CreateNewProperty;
  If Tmp = Nil Then
    Result := False
  Else
    p := Tmp;
end;


procedure TfrmPropertyWizard.FormCreate(Sender: TObject);
begin
  Findex := 0;
  cboType.ItemIndex := FIndex;
  cboType.OnClick(cboType);
end;

procedure TfrmPropertyWizard.chkReadOnlyClick(Sender: TObject);
begin
  If Sender = chkReadOnly Then
    chkEdit.Enabled := Not chkReadOnly.Checked;
  UpdateProperties;
  Inspector.Invalidate;
end;

procedure TfrmPropertyWizard.UpdateProperties;
begin
  Fbp.PropName := edName.Text;
  Fbp.UseEditButton := chkEdit.Checked;
  Fbp.Modified := chkModified.Checked;
  Fbp.ReadOnly := chkReadOnly.Checked;
  Fbp.IndentLevel := Updown1.Position;
  If FBp Is TEzFontNameProperty Then Begin
    chkTrueType.Enabled := True;
    TEzFontNameProperty(Fbp).TrueType := chkTrueType.Checked;
  End Else
    chkTrueType.Enabled := False;
  btnOk.Enabled := Length(edName.Text) > 0;
  btnEdit.Enabled := (FBp Is TEzEnumerationProperty) Or (FBp Is TEzSetProperty);
end;

procedure TfrmPropertyWizard.cboTypeClick(Sender: TObject);
Var
  TmpBp : TEzBaseProperty;
begin
  TmpBp := CreatePropertyByIndex(cboType.ItemIndex, FBp, edName.Text, caCreate);
  If TmpBp = Nil Then Begin
    cboType.ItemIndex := FIndex;
    Exit;
  End;
  If edName.Text = cboType.Items.Strings[FIndex] Then
    edName.Text := cboType.Items.Strings[cboType.ItemIndex];
  FIndex := cboType.ItemIndex;
  If Assigned(FBp) Then Inspector.ClearPropertyList;
  Fbp := TmpBp;
  UpdateProperties;
  Inspector.AddProperty(FBp);
  Inspector.Invalidate;
end;

function CreatePropertyByIndex(Index: Integer;
  Clone : TEzBaseProperty; const Name : String; Action : TCreateAction): TEzBaseProperty;
Var
  Count : Integer;
begin
  Result := Nil;
  Case Index Of
    0: Result := TEzAngleProperty.Create(Name);
//    1: Result := TEzBaseProperty.Create(Name);
    1: Result := TEzBitmapProperty.Create(Name);
    2: Result := TEzBlocksProperty.Create(Name);
    3: Result := TEzBooleanProperty.Create(Name);
    4: Result := TEzBrushstyleProperty.Create(Name);
    5: Result := TEzColorProperty.Create(Name);
    6: Result := TEzDateProperty.Create(Name);
    7: Result := TEzDefineAnyLocalImageProperty.Create(Name);
    8: Result := TEzDefineLocalBitmapProperty.Create(Name);
    9: Result := TEzDefineLocalTiffProperty.Create(Name);
   10: Result := TEzDummyProperty.Create(Name);
   11: Begin
          If Action = caClone Then Begin
            Result := TEzEnumerationProperty.Create(Name);
            For Count := 0 To TEzEnumerationProperty(Clone).Strings.Count - 1 Do
              TEzEnumerationProperty(Result).Strings.Add(TEzEnumerationProperty(Clone).Strings[Count]);
          End Else With TfrmEnumAndSetItemsEditor.Create( Nil ) Do
            Try
              If EnumerationItemsEdit(Nil) = mrOk Then Begin
                Result := TEzEnumerationProperty.Create(Name);
                For Count := 0 To List1.Items.Count - 1 Do
                  TEzEnumerationProperty(Result).Strings.Add(List1.Items[Count]);
              End Else
                Result := Nil;
            Finally
              Free;
            End;
       End;
   12: Result := TEzExpressionProperty.Create(Name);
   13: Result := TEzFloatProperty.Create(Name);
   14: Result := TEzFontNameProperty.Create(Name);
   15: Result := TEzGraphicProperty.Create(Name);
   16: Result := TEzIntegerProperty.Create(Name);
   17: Result := TEzLinetypeProperty.Create(Name);
   18: Result := TEzLongTextProperty.Create(Name);
   19: Result := TEzMemoProperty.Create(Name);
   20: Result := TEzPointsProperty.Create(Name);
   21: Result := TEzSelectFolderProperty.Create(Name);
   22:  Begin
          If Action = caClone Then Begin
            Result := TEzSetProperty.Create(Name);
            For Count := 0 To TEzSetProperty(Clone).Strings.Count - 1 Do Begin
              TEzSetProperty(Result).Strings.Add(TEzSetProperty(Clone).Strings[Count]);
              TEzSetProperty(Result).Defined[Count] := TEzSetProperty(Clone).Defined[Count];
            End
          End Else With TfrmEnumAndSetItemsEditor.Create( Nil ) Do
            Try
              If SetItemsEdit(Nil) = mrOk Then Begin
                Result := TEzSetProperty.Create(Name);
                For Count := 0 To List1.Items.Count - 1 Do Begin
                  TEzSetProperty(Result).Strings.Add(List1.Items[Count]);
                  TEzSetProperty(Result).Defined[Count] := TCheckListBox(List1).Checked[Count];
                End
              End Else
                Result := Nil;
            Finally
              Free;
            End;
       End;
   23: Result := TEzStringProperty.Create(Name);
   24: Result := TEzSymbolProperty.Create(Name);
   25: Result := TEzTimeProperty.Create(Name);
{    0: Result := TEzIntegerProperty.Create(Name);
    1: Result := TEzStringProperty.Create(Name);
    2: Result := TEzFloatProperty.Create(Name);   }
  End;
  If (Clone <> Nil) And (Result <> Nil) Then Begin
    Result.ValBoolean := Clone.ValBoolean;
    Result.ValDatetime := Clone.ValDatetime;
    Result.ValFloat := Clone.ValFloat;
    Result.ValInteger := Clone.ValInteger;
    Result.ValString := Clone.ValString;
  End;
end;

procedure TfrmPropertyWizard.InspectorPropertyChange(Sender: TObject;
  const PropertyName: String);
begin
  chkModified.Checked := True;
end;

procedure TfrmPropertyWizard.FormShow(Sender: TObject);
begin
  Inspector.DefaultColWidth := Inspector.Width Div 2;
end;


procedure TfrmPropertyWizard.btnEditClick(Sender: TObject);
Var
  I : Integer;
begin
  With TfrmEnumAndSetItemsEditor.Create(Nil) Do
  Try
    If FBp Is TEzEnumerationProperty Then Begin
      If EnumerationItemsEdit(TEzEnumerationProperty(FBp)) = idOk Then
      With TEzEnumerationProperty(FBp) Do Begin
        Strings.Clear;
        For I := 0 To List1.Items.Count - 1 Do
          Strings.Add(List1.Items.Strings[I]);
      End;
    End Else If FBp Is TEzSetProperty Then Begin
      If SetItemsEdit(TEzSetProperty(FBp)) = idOk Then
      With TEzSetProperty(FBp) Do Begin
        Strings.Clear;
        For I := 0 To List1.Items.Count - 1 Do Begin
          Strings.Add(List1.Items.Strings[I]);
          Defined[I] := TCheckListBox(List1).Checked[I];
        End;
      End;
    End;
  Finally
    Free;
  End;
  Inspector.Invalidate;
end;

end.
