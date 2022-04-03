unit uVCLUtils;

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}

interface

uses
  SysUtils, Classes, Controls, StdCtrls, DBGrids, ComCtrls, Forms, Menus, Windows, TypInfo;


type
  TPopupMenuHelper = class helper for TPopupMenu
  public
    function AddNewItem(const aCaption: String = ''; ClickEventHandler: TNotifyEvent = nil): TMenuItem; 
  end;

  // VCL
  procedure AutoSelectListViewColumnWidth(ListView: TListView;
    ImageWidth: Integer = 16);
  procedure EditDateKeyDown(AEdit: TCustomEdit; var Key: Word;
    Shift: TShiftState);
  function  HasOnlyOneGrid(Component: TComponent): Boolean;
  function  HintIsActive(const HintStr: String): Boolean;
  function  LocateId(Strings: TStrings; Id: Integer): Integer;
  procedure SetControlState(AControl: TControl; ReadOnly: Boolean);
  procedure SetEditSelection(AEdit: TCustomEdit; Start, Finish: Integer);


implementation

procedure SetControlState(AControl: TControl; ReadOnly: Boolean);
var
  I, CC: Integer;
  Info: PPropInfo;
begin
  if AControl is TWinControl then
  with AControl as TWinControl do
  begin
    CC := Pred(ControlCount);
    for I := 0 to CC do
    begin
      Info := GetPropInfo(Controls[I], 'ReadOnly', []);
      if Assigned(Info) and Assigned(Info.SetProc) then
        SetPropValue(Controls[I], 'ReadOnly', ReadOnly);
      SetControlState(Controls[I], ReadOnly);
    end;
  end;
end;

procedure SetEditSelection(AEdit: TCustomEdit; Start, Finish: Integer);
begin
  if Assigned(AEdit) and (Start > 0) and (Finish > Start) then
  begin
    AEdit.SelStart := Start;
    AEdit.SelLength := Succ(Finish - Start);
  end
end;

const
  EditKeys = [VK_LEFT, VK_RIGHT, VK_UP, VK_DOWN, VK_BACK, VK_INSERT,
    VK_DELETE, VK_RETURN];
  dateDelimiters = [Ord('.'), Ord('/'), Ord('-')];

type
  TDateState = (
    dsNone,
    dsFirstDigit,
    dpMidDigit,
    dsLastDigit,
    dsSeparator,
    dsError
  );

  TDatePart = (
    dpNone,
    dpDay,
    dpMonth,
    dpYear
  );

procedure ParseDate(const Text: String; var DateState: TDateState; var DatePart: TDatePart);
var
  I: Integer;
begin
  DateState := dsNone;
  DatePart := dpNone;
  for I := 1 to Length(Text) do
  if Text = '' then
  begin
    DateState := dsNone;
    DatePart := dpNone;
  end
  else
  begin
  end;
end;

procedure EditDateKeyDown(AEdit: TCustomEdit; var Key: Word;
  Shift: TShiftState);
var
  ValidKey: Boolean;
  L: Integer;
begin
  // строка пустая - можно вводить цифры
  // строка не пустая
    // строка из одного символа - можно ввести цифру
    // строка из двух цифр - можно ввести только разделитель
    // строка из цифры и разделителя - можно вводить цифры
  if AEdit = nil then
    Exit;
  if Key in EditKeys then
    Exit;
  ValidKey := False;
  L := AEdit.SelStart;//Length(AEdit.Text);
  case L of
  0 :  // строка пустая - можно вводить цифру
    ValidKey := (Key >= Ord('0')) and (Key <= Ord('9'));
  1 :
    begin
      case StrToInt(Copy(AEdit.Text, 1, L)) of
      0 :
        ValidKey := (Key > Ord('0')) and (Key <= Ord('9'));
      1, 2 :
        ValidKey := Key in [Ord('0')..Ord('9'), Ord('.'), Ord('/'), Ord('-')];
      3 :
        ValidKey := Key in [Ord('0'), Ord('1'), Ord('.'), Ord('/'), Ord('-')];
      else
        ValidKey := Key in DateDelimiters;
      end;
    end;
  2 :
    begin
      if Ord(AEdit.Text[2]) in DateDelimiters then
        ValidKey := Key in [Ord('0')..Ord('9')]
      else
        ValidKey := Key in DateDelimiters;
    end;
  3 :
    begin
      if Ord(AEdit.Text[3]) in DateDelimiters then
        ValidKey := Key in [Ord('0')..Ord('9')]
      else
        ;
    end;
  else
    ValidKey := False;
  end;

  if not ValidKey then
    Key := 0;
end;

// Проверяет количество DBGrid'ов на форме.
function HasOnlyOneGrid(Component: TComponent): Boolean;
var
  I, L, Count: Integer;
begin
  Result := False;
  if Assigned(Component) then
  begin
    L := Pred(Component.ComponentCount);
    Count := 0;
    for I := 0 to L do
      if Component.Components[I] is TdbGrid then
      begin
        Inc(Count);
        if Count > 1 then
          Exit;
      end;
    Result := True;
  end;
end;

procedure AutoSelectListViewColumnWidth(ListView: TListView; ImageWidth: Integer = 16);
var
  I, J, aWidth, aTextWidth: Integer;
begin
  if not Assigned(ListView) then
    Exit;
  aWidth := 0;
  for J := 0 to Pred(ListView.Items.Count) do
  begin
    with ListView do
      aTextWidth := Canvas.TextWidth(Items[J].Caption);
    if aTextWidth > aWidth then
      aWidth := aTextWidth;
  end;
  if ListView.Columns[0].Width < aWidth + 10 + ImageWidth then
    ListView.Columns[0].Width := aWidth + 10 + ImageWidth;
  for I := 1 to Pred(ListView.Columns.Count) do
  begin
    aWidth := 0;
    for J := 0 to Pred(ListView.Items.Count) do
    begin
      with ListView do
        aTextWidth := Canvas.TextWidth(Items[J].SubItems[Pred(I)]);
      if aTextWidth > aWidth then
        aWidth := aTextWidth;
    end;
    if ListView.Columns[I].Width < aWidth + 20 then
      ListView.Columns[I].Width := aWidth + 20;
  end;
end;

function HintIsActive(const HintStr: String): Boolean;
var
  Handle: THandle;
begin
  Handle := FindWindowEx(Application.Handle, 0, PChar('THintWindow'), PChar(HintStr));
  Result := Handle <> 0;
  if Result then
    Result := IsWindowVisible(Handle);
end;

function LocateId(Strings: TStrings; ID: Integer): Integer;
var
  I: Integer;
begin
  Result := -1;
  if Assigned(Strings) then
    for I := 0 to Pred(Strings.Count) do
      if Strings.Objects[I] = Pointer(ID) then
      begin
        Result := I;
        Exit;
      end;
end;

{ TPopupMenuHelper }

function TPopupMenuHelper.AddNewItem(const aCaption: String; ClickEventHandler: TNotifyEvent): TMenuItem;
var
  Mi: TMenuItem;
begin
  Mi := TMenuItem.Create(Self);
  Mi.Caption := aCaption;
  Mi.OnClick := ClickEventHandler;
  Self.Items.Add(Mi);
  Result := Mi;
end;

end.
