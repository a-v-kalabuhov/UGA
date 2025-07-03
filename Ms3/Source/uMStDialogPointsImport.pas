unit uMStDialogPointsImport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons, ActnList,
  uMStClassesPointsImport, uMStImport;

type
  TmstPointsViewMode = (pvmNone, pvmSelectX, pvmSelectY);

  TMstDialogImportPointsForm = class(TForm, ImstImportPointsDialog)
    lvText: TListView;
    RadioGroup1: TRadioGroup;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    CheckBox1: TCheckBox;
    ActionList1: TActionList;
    Action1: TAction;
    Label1: TLabel;
    cbX: TComboBox;
    cbY: TComboBox;
    Label2: TLabel;
    procedure RadioGroup1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure lvTextColumnClick(Sender: TObject; Column: TListColumn);
    procedure Action1Execute(Sender: TObject);
    procedure Action1Update(Sender: TObject);
    procedure lvTextMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lvTextChanging(Sender: TObject; Item: TListItem;
      Change: TItemChange; var AllowChange: Boolean);
    procedure lvTextKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvTextKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvTextChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure FormCreate(Sender: TObject);
    procedure lvTextDrawItem(Sender: TCustomListView; Item: TListItem;
      Rect: TRect; State: TOwnerDrawState);
    procedure cbXChange(Sender: TObject);
    procedure cbYChange(Sender: TObject);
  private
    FPointList: TmstImportedPointList;
    FMode: TmstPointsViewMode;
    FXError, FYError: Boolean;
    FCanSelectItems: Boolean;
    procedure LoadFile;
    function GetColSeparator: Char;
    procedure SetColSeparator(const Value: Char);
    property ColSeparator: Char read GetColSeparator write SetColSeparator;
    procedure SetPointsFile(const Value: TmstImportedPointList);
    procedure DrawSubItem(Sender: TCustomListView; Item: TListItem;
      SubItem: Integer; Selected: Boolean);
    procedure SetMode(const Value: TmstPointsViewMode);
  public
    property Mode: TmstPointsViewMode read FMode write SetMode;
    function Execute(aPointsList: TObject): Boolean;
  end;

implementation

{$R *.dfm}

procedure TMstDialogImportPointsForm.RadioGroup1Click(Sender: TObject);
begin
  Edit1.Visible := RadioGroup1.ItemIndex = 4;
  if Edit1.Visible then
    Edit1.SetFocus
  else
  begin
    FPointList.Separator := ColSeparator;
    LoadFile;
  end;
  Mode := pvmNone;
end;

procedure TMstDialogImportPointsForm.SetPointsFile(const Value: TmstImportedPointList);
begin
  FPointList := Value;
  if Assigned(FPointList) then
  begin
    case FPointList.Separator of
    ';' : RadioGroup1.ItemIndex := 0;
    ',' : RadioGroup1.ItemIndex := 1;
    #9  : RadioGroup1.ItemIndex := 2;
    ' ' : RadioGroup1.ItemIndex := 3;
    else
      begin
        RadioGroup1.ItemIndex := 4;
        Edit1.Text := FPointList.Separator;
      end;
    end;
    LoadFile;
  end;
end;

procedure TMstDialogImportPointsForm.Edit1Change(Sender: TObject);
begin
  if Edit1.Text <> '' then
  begin
    if Assigned(FPointList) then
    begin
      FPointList.Separator := String(Edit1.text)[1];
      LoadFile;
    end;
  end;
  Mode := pvmNone;
end;

function TMstDialogImportPointsForm.Execute(aPointsList: TObject): Boolean;
begin
  FPointList := aPointsList as TmstImportedPointList;
  ColSeparator := FPointList.Separator;
  Result := ShowModal = mrOK;
end;

procedure TMstDialogImportPointsForm.LoadFile;
var
  I, J, C: Integer;
begin
  lvText.Items.BeginUpdate;
  try
    lvText.Items.Clear;
    lvText.Columns.Clear;
    with lvText.Columns.Add do
    begin
      Caption := '№ Строки';
      Width := 70;
      MinWidth := 70;
    end;
    //
    for I := 1 to FPointList.ColCount do
      lvText.Columns.Add;
    C := FPointList.Columns[0].Count;
    for J := 0 to Pred(C) do
      with lvText.Items.Add do
      begin
        ImageIndex := -1;
        Caption := IntToStr(J + 1);
        for I := 0 to Pred(FPointList.ColCount) do
          SubItems.Add(FPointList.Columns[I].Strings[J]);
      end;
    //
    for I := 0 to Pred(lvText.Columns.Count) do
      lvText.Column[I].AutoSize := True;
    //
    if FPointList.XIndex >= 0 then
      with lvText.Column[FPointList.XIndex + 1] do
      begin
        Caption := 'X';
        ImageIndex := 3;
      end;
    if FPointList.YIndex >= 0 then
      with lvText.Column[FPointList.YIndex + 1] do
      begin
        Caption := 'Y';
        ImageIndex := 3;
      end;
  finally
    lvText.Items.EndUpdate;
  end;
  //
  cbX.Items.Clear;
  for I := 1 to FPointList.ColCount do
    cbX.Items.Add(IntToStr(I));
  cbX.ItemIndex := FPointList.XIndex;
  cbY.Items.Clear;
  for I := 1 to FPointList.ColCount do
    cbY.Items.Add(IntToStr(I));
  cbY.ItemIndex := FPointList.YIndex;
end;

procedure TMstDialogImportPointsForm.CheckBox1Click(Sender: TObject);
begin
  FPointList.ReplaceOldPoints := CheckBox1.Checked;
end;

procedure TMstDialogImportPointsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Mode := pvmNone;
  FXError := False;
  FYError := False;
end;

procedure TMstDialogImportPointsForm.Button1Click(Sender: TObject);
begin
  Mode := pvmSelectX;
end;

procedure TMstDialogImportPointsForm.Button2Click(Sender: TObject);
begin
  Mode := pvmSelectY;
end;

procedure TMstDialogImportPointsForm.cbXChange(Sender: TObject);
var
  Column: TListColumn;
  I: Integer;
  F: Double;
begin
  if FPointList.XIndex >= 0 then
    with lvText.Columns[FPointList.XIndex + 1] do
    begin
      ImageIndex := -1;
      Caption := '';
    end;
  //
  FPointList.XIndex := cbX.ItemIndex;
  if cbX.ItemIndex >= 0 then
  begin
    Column := lvText.Columns[cbX.ItemIndex + 1];
    Column.ImageIndex := 3;
    Column.Caption := 'X';
    FXError := not FPointList.Columns[cbX.ItemIndex].IsFloat;
    if FXError then
    begin
      for I := 0 to Pred(FPointList.Columns[cbX.ItemIndex].Count) do
        if not TryStrToFloat(FPointList.Columns[cbX.ItemIndex].Strings[I], F) then
          lvText.Items[I].MakeVisible(False);
    end;
  end;
  lvText.Repaint;
end;

procedure TMstDialogImportPointsForm.cbYChange(Sender: TObject);
var
  Column: TListColumn;
  I: Integer;
  F: Double;
begin
  if FPointList.YIndex >= 0 then
    with lvText.Columns[FPointList.YIndex + 1] do
    begin
      ImageIndex := -1;
      Caption := '';
    end;
  //
  FPointList.YIndex := cbY.ItemIndex;
  if cbY.ItemIndex >= 0 then
  begin
    Column := lvText.Columns[cbY.ItemIndex + 1];
    Column.ImageIndex := 3;
    Column.Caption := 'Y';
    FYError := not FPointList.Columns[cbY.ItemIndex].IsFloat;
    if FYError then
    begin
      for I := 0 to Pred(FPointList.Columns[cbY.ItemIndex].Count) do
        if not TryStrToFloat(FPointList.Columns[cbY.ItemIndex].Strings[I], F) then
          lvText.Items[I].MakeVisible(False);
    end;
  end;
  lvText.Repaint;
end;

procedure TMstDialogImportPointsForm.lvTextColumnClick(Sender: TObject;
  Column: TListColumn);
var
  I: Integer;
  PtCol: TmstImportedPointsColumn;
  F: Double;
begin
  if Column.Index = 0 then
    Exit;
  case Mode of
  pvmSelectX :
    begin
      if FPointList.XIndex >= 0 then
        with lvText.Columns[FPointList.XIndex + 1] do
        begin
          ImageIndex := -1;
          Caption := '';
        end;
      //
      Column.ImageIndex := 3;
      Column.Caption := 'X';
      FPointList.XIndex := Column.Index - 1;
      //
      if FPointList.YIndex = (Column.ImageIndex - 1) then
      begin
        FPointList.YIndex := -1;
        FYError := False;
      end;
      //
      PtCol := FPointList.Columns[Column.Index - 1];
      FXError := not PtCol.IsFloat;
      if not FXError then
        Mode := pvmNone
      else
      begin
        for I := 0 to Pred(PtCol.Count) do
          if not TryStrToFloat(PtCol.Strings[I], F) then
            lvText.Items[I].MakeVisible(False);
      end;
    end;
  pvmSelectY :
    begin
      if FPointList.YIndex >= 0 then
        with lvText.Columns[FPointList.YIndex + 1] do
        begin
          ImageIndex := -1;
          Caption := '';
        end;
      //
      Column.ImageIndex := 3;
      Column.Caption := 'Y';
      FPointList.YIndex := Column.Index - 1;
      //
      if FPointList.XIndex = (Column.Index - 1) then
      begin
        FPointList.XIndex := -1;
        FXError := False;
      end;
      PtCol := FPointList.Columns[Column.Index - 1];
      FYError := not PtCol.IsFloat;
      if not FYError then
        Mode := pvmNone
      else
      begin
        for I := 0 to Pred(PtCol.Count) do
          if not TryStrToFloat(PtCol.Strings[I], F) then
            lvText.Items[I].MakeVisible(False);
      end;
    end;
  else
    Mode := pvmNone;
  end;
  lvText.Invalidate;
end;

procedure TMstDialogImportPointsForm.Action1Execute(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TMstDialogImportPointsForm.Action1Update(Sender: TObject);
begin
  Action1.Enabled := Assigned(FPointList) and (FPointList.XIndex >= 0)
    and (FPointList.YIndex >= 0) and (not FXError) and (not FYError);
end;

procedure TMstDialogImportPointsForm.DrawSubItem(
  Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  Selected: Boolean);
var
  F: Double;
  R: TRect;
  I: Integer;
  S: String;
begin
  if Selected then
  begin
    lvText.Canvas.Font.Color := clInfoBk;
    lvText.Canvas.Brush.Color := clHighlight;
  end
  else
  begin
    lvText.Canvas.Font.Color := clBlack;
    lvText.Canvas.Brush.Color := clInfoBk;
  end;
  if SubItem = Succ(FPointList.XIndex) then
    if FXError then
      if not TryStrToFloat(Item.SubItems[Pred(SubItem)], F) then
        if Selected then
          lvText.Canvas.Font.Color := clRed
        else
          lvText.Canvas.Brush.Color := $9999FF;
  if SubItem = Succ(FPointList.YIndex) then
    if FYError then
      if not TryStrToFloat(Item.SubItems[Pred(SubItem)], F) then
        if Selected then
          lvText.Canvas.Font.Color := clRed
        else
          lvText.Canvas.Brush.Color := $9999FF;
  //
  R := Item.DisplayRect(drBounds);
  R.Left := 0;
  for I := 0 to Pred(SubItem) do
    Inc(R.Left, lvText.Columns[I].Width);
  Inc(R.Left);
  R.Right := R.Left + lvText.Columns[SubItem].Width;
//  Dec(R.Right);
  lvText.Canvas.FillRect(R);
  //
  S := Item.SubItems[Pred(SubItem)];
  Inc(R.Left, 2);
  Inc(R.Top, 2);
  DrawText(lvText.Canvas.Handle, PChar(S), Length(S), R, DT_SINGLELINE + DT_TOP + DT_LEFT);
  lvText.Canvas.Brush.Color := clInfoBk;//clWindow;
end;

procedure TMstDialogImportPointsForm.lvTextMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Item: TListItem;
begin
  if X > lvText.Columns[0].Width then
  begin
    FCanSelectItems := True;
    try
      Item := lvText.GetItemAt(16, Y);
      if Assigned(Item) then
      begin
        lvText.Selected := Item;
        Item.Focused := True;
      end;
    finally
      FCanSelectItems := False;
    end;
  end;
end;

procedure TMstDialogImportPointsForm.lvTextChanging(Sender: TObject;
  Item: TListItem; Change: TItemChange; var AllowChange: Boolean);
begin
  AllowChange := FCanSelectItems;
end;

procedure TMstDialogImportPointsForm.lvTextKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  FCanSelectItems := True;
end;

procedure TMstDialogImportPointsForm.lvTextKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  FCanSelectItems := False;
end;

procedure TMstDialogImportPointsForm.lvTextChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  lvText.Invalidate;
end;

procedure TMstDialogImportPointsForm.FormCreate(Sender: TObject);
begin
//  Screen.Cursors[crSelectX] := LoadCursor(HInstance, 'CRSELECTX');
//  Screen.Cursors[crSelectY] := LoadCursor(HInstance, 'CRSELECTY');
end;

function TMstDialogImportPointsForm.GetColSeparator: Char;
begin
  case RadioGroup1.ItemIndex of
  0 : Result := ';';
  1 : Result := ',';
  2 : Result := #9;
  3 : Result := ' ';
  4 : if Edit1.Text <> '' then
        Result := String(Edit1.Text)[1]
      else
        Result := #9;
  else
    Result := ';';
  end;
end;

procedure TMstDialogImportPointsForm.SetColSeparator(const Value: Char);
begin
  case Value of
  ';' : RadioGroup1.ItemIndex := 0;
  ',' : RadioGroup1.ItemIndex := 1;
  #9 : RadioGroup1.ItemIndex := 2;
  ' ' : RadioGroup1.ItemIndex := 3;
  else
    begin
      Edit1.Text := Value;
      RadioGroup1.ItemIndex := 4;
    end;
  end;
end;

procedure TMstDialogImportPointsForm.SetMode(const Value: TmstPointsViewMode);
begin
  FMode := Value;
  case FMode of
  pvmSelectX :
    lvText.Cursor := crHandPoint;
  pvmSelectY :
    lvText.Cursor := crHandPoint;
  pvmNone :
    lvText.Cursor := crDefault;
  end;
end;

procedure TMstDialogImportPointsForm.lvTextDrawItem(Sender: TCustomListView;
  Item: TListItem; Rect: TRect; State: TOwnerDrawState);
var
  R, R1, R2: TRect;
  I: Integer;
begin
  lvText.Canvas.Brush.Color := clBtnFace;
  R1 := Item.DisplayRect(drLabel);
  R2 := Item.DisplayRect(drIcon);
  R2.Right := R1.Right;
  Inc(R2.Bottom);
  lvText.Canvas.Rectangle(R2);
  lvText.Canvas.TextOut(R1.Left + 5, R1.Top + 2, Item.Caption);
  lvText.Canvas.Brush.Color := clInfoBk;//clWindow;
  //
  for I := 1 to Item.SubItems.Count do
    DrawSubItem(Sender, Item, I, odSelected in State);
  //
  if odFocused in State then
  begin
    R := Item.DisplayRect(drBounds);
    R.Left := lvText.Columns[0].Width + 1;
    lvText.Canvas.DrawFocusRect(R);
  end;
end;

end.
