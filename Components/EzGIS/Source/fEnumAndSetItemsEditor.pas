unit fEnumAndSetItemsEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, EzInspect;

type

  TFrmEnumAndSetItemsEditor = class(TForm)
    Button1: TButton;
    Button2: TButton;
    chkDefault: TCheckBox;
    Bevel3: TBevel;
    BtnAdd: TSpeedButton;
    BtnDelete: TSpeedButton;
    Bevel1: TBevel;
    btnUp: TSpeedButton;
    btnDown: TSpeedButton;
    Bevel2: TBevel;
    btnEdit: TSpeedButton;
    procedure BtnAddClick(Sender: TObject);
    procedure CheckList1Click(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
  private
    { Private declarations }
    Procedure UpdateButtons;
  public
    { Public declarations }
    List1 : TCustomListBox;
    Function EnumerationItemsEdit(EnumP : TEzEnumerationProperty) : Word;
    Function SetItemsEdit(SetP : TEzSetProperty) : Word;
  end;

implementation
{$R *.DFM}

uses
  CheckLst;

Const
  ListTop    = 46;
  ListLeft   = 16;
  ListWidth  = 185;
  ListHeight = 144;
ResourceString
  SMessage = 'Change this value';
  SErrorMessageList = 'The list is not assigned';
  SCaptionMessage = 'EzSystems [Properties editor]';

procedure TFrmEnumAndSetItemsEditor.BtnAddClick(Sender: TObject);
Var
  Str : String;
begin
  If Not TSpeedButton(Sender).Enabled Then Exit;
  If Not Assigned(List1) Then Begin
    Raise Exception.Create(SErrorMessageList);
    Exit;
  End;
  Str := InputBox(SCaptionMessage, 'Value', SMessage);
  If Str = SMessage Then Exit;
  List1.Items.Add(Str);
  If List1 Is TCheckListBox Then
    TCheckListBox(List1).Checked[List1.Items.Count-1] := chkDefault.Checked;
  If List1.ItemIndex < 0 Then
    List1.ItemIndex := 0;
  List1.Invalidate;
  UpdateButtons;
end;

procedure TFrmEnumAndSetItemsEditor.UpdateButtons;
begin
  If Not Assigned(List1) Then Begin
    btnDelete.Enabled := False;
    btnUp.Enabled := False;
    btnDown.Enabled := False;
    btnAdd.Enabled := False;
    btnEdit.Enabled := False;
    Button1.Enabled := False;
    Exit;
  End;
  btnDelete.Enabled := List1.ItemIndex >= 0;
  btnEdit.Enabled := btnDelete.Enabled;
  btnUp.Enabled := List1.ItemIndex > 0;
  btnDown.Enabled := (List1.ItemIndex < List1.Items.Count - 1) And
                     (List1.ItemIndex <> -1);
end;

procedure TFrmEnumAndSetItemsEditor.CheckList1Click(Sender: TObject);
begin
  UpDateButtons;
end;

procedure TFrmEnumAndSetItemsEditor.BtnDeleteClick(Sender: TObject);
Var
  Index : Integer;
begin
  If Not TSpeedButton(Sender).Enabled Then Exit;
  Index := List1.ItemIndex;
  List1.Items.Delete(Index);
  If Index > List1.Items.Count - 1 Then
    Dec(Index);
  List1.ItemIndex := Index;
  List1.Invalidate;
  UpdateButtons;
end;

procedure TFrmEnumAndSetItemsEditor.btnUpClick(Sender: TObject);
begin
  If Not TSpeedButton(Sender).Enabled Then Exit;
  List1.Items.Exchange(List1.ItemIndex, List1.ItemIndex - 1);
  UpdateButtons;
end;

procedure TFrmEnumAndSetItemsEditor.btnDownClick(Sender: TObject);
begin
  If Not TSpeedButton(Sender).Enabled Then Exit;
  List1.Items.Exchange(List1.ItemIndex, List1.ItemIndex + 1);
  UpdateButtons;
end;

procedure TFrmEnumAndSetItemsEditor.FormCreate(Sender: TObject);
begin
 {  List1 := TCheckListBox.Create(Self);
  With List1 As TCheckListBox Do Begin
    Parent := Self;
    Left :=  ListLeft;
    Top :=   ListTop;
    Width := ListWidth;
    Height := ListHeight;
    OnClick := CheckList1Click;
  End; }
  Caption := SCaptionMessage;
end;

function TFrmEnumAndSetItemsEditor.EnumerationItemsEdit(EnumP : TEzEnumerationProperty) : Word;
Var
  I : Integer;
begin
  if Assigned(List1) Then List1.Free;
  List1 := TListBox.Create(Self);
  With List1 As TListBox Do Begin
    Parent := Self;
    Left :=  ListLeft;
    Top :=   ListTop;
    Width := ListWidth;
    Height := ListHeight;
    OnClick := CheckList1Click;
  End;
  If EnumP <> Nil Then
    For I := 0 To EnumP.Strings.Count - 1 Do
      List1.Items.Add(EnumP.Strings[I]);
  Result := ShowModal;
end;



function TFrmEnumAndSetItemsEditor.SetItemsEdit(SetP : TEzSetProperty) : Word;
Var
  I : Integer;
begin
  if Assigned(List1) Then List1.Free;
  List1 := TCheckListBox.Create(Self);
  With List1 As TCheckListBox Do Begin
    Parent := Self;
    Left :=  ListLeft;
    Top :=   ListTop;
    Width := ListWidth;
    Height := ListHeight;
    OnClick := CheckList1Click;
  End;
  If SetP <> Nil Then
    For I := 0 To SetP.Strings.Count - 1 Do Begin
      List1.Items.Add(SetP.Strings[I]);
      TCheckListBox(List1).Checked[I] := SetP.Defined[I];
    End;
  Result := ShowModal;
end;

procedure TFrmEnumAndSetItemsEditor.FormShow(Sender: TObject);
begin
  UpdateButtons;
  chkDefault.Enabled := List1 Is TCheckListBox;
end;

procedure TFrmEnumAndSetItemsEditor.btnEditClick(Sender: TObject);
Var
  Str : String;
begin
  If Not TSpeedButton(Sender).Enabled Then Exit;
  Str := InputBox('EzSystems [Properties editor]', 'Value', List1.Items[List1.ItemIndex]);
  List1.Items[List1.ItemIndex] := Str;
end;

end.
