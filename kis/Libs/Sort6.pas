unit Sort6;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBGrids, CheckLst, Buttons, IBQuery, DB, StrUtils,
  //
  uIBXUtils, uSQL, uGC,
  //
  uKisAppModule;

type
  TSortForm = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    lbOrderFields: TCheckListBox;
    Label1: TLabel;
    btnUp: TSpeedButton;
    btnDown: TSpeedButton;
    lbAllFields: TListBox;
    btnAdd: TButton;
    btnRemove: TButton;
    btnAddAll: TButton;
    btnRemoveAll: TButton;
    Label2: TLabel;
    Label3: TLabel;
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnAddAllClick(Sender: TObject);
    procedure btnRemoveAllClick(Sender: TObject);
  private
    _Grid: TDBGrid;
    Query: TIBQuery;
    procedure MoveCurrentItem(Count: Integer);
    procedure ReadColumns;
    procedure Add(AItemIndex: Integer);
    procedure Remove(AItemIndex: Integer);
  public
    { Public declarations }
  end;

function ShowSort(Grid: TDBGrid): Boolean;

implementation

{$R *.DFM}

uses
  AString6, AGrids6, AProc6;

function ShowSort(Grid: TDBGrid): Boolean;
var
  I: Integer;
  NewSQL: TStrings;
  OrderClause: String;
  Fld: TField;
begin
  with TSortForm.Create(Application) do
  try
    _Grid := Grid;
    Query := TIBQuery(Grid.DataSource.DataSet);
    ReadColumns;
    Result := (ShowModal = mrOk);
    if Result then
    begin
      NewSQL := TStringList.Create;
      NewSQL.Forget();
      NewSQL.Assign(Query.SQL);
      for I := 0 to Pred(lbOrderFields.Items.Count) do
      begin
        if OrderClause <> '' then
          OrderClause := OrderClause + ',';
        Fld := TColumn(lbOrderFields.Items.Objects[I]).Field;
        if Fld.Origin <> '' then
          OrderClause := OrderClause + Fld.Origin
        else
          OrderClause := OrderClause + Fld.FieldName;
        if lbOrderFields.Checked[I] then
          OrderClause := OrderClause + ' DESC';
      end;
//        if OrderClause<>'' then Delete(OrderClause,Length(OrderClause),1);
      TSQLFactory.CreateNew(NewSQL).WriteClause(scOrderBy,OrderClause);
      Query.Reset(NewSQL, AppModule.SQLErrorHandler);
    end;
  finally
    Free;
  end;
end;

procedure TSortForm.MoveCurrentItem(Count: Integer);
var
  Pos: Integer;
begin
  if lbOrderFields.ItemIndex < 0 then
    Exit;
  Pos := lbOrderFields.ItemIndex + Count;
  if Pos < 0 then
    Pos := 0
  else
    if Pos > Pred(lbOrderFields.Items.Count) then
      Pos := Pred(lbOrderFields.Items.Count);
  lbOrderFields.Items.Move(lbOrderFields.ItemIndex,Pos);
  lbOrderFields.ItemIndex := Pos;
end;

procedure TSortForm.btnUpClick(Sender: TObject);
begin
  MoveCurrentItem(-1);
end;

procedure TSortForm.btnDownClick(Sender: TObject);
begin
  MoveCurrentItem(1);
end;

function GetStringsObjectIndex(Strings: TStrings; Obj: TObject): Integer;
var
  I: Integer;
begin
  for I := 0 to Pred(Strings.Count) do
    if Strings.Objects[I] = Obj then
    begin
      Result := I;
      Exit;
    end;
  Result := -1;
end;

procedure TSortForm.ReadColumns;
var
  OrderClause, FieldName: String;
  ColumnIndex, I: Integer;
  Desc: Boolean;
  Column: TColumn;
begin
  //читаем колонки
  for I := 0 to Pred(_Grid.Columns.Count) do
  begin
    lbAllFields.Items.Add(_Grid.Columns[I].Title.Caption);
    lbAllFields.Items.Objects[I] := _Grid.Columns[I];
  end;
  //читаем текущий порядок сортировки
  OrderClause := UpperCase(Query.AsSQL.ReadClause(scOrderBy));
  while OrderClause <> '' do
  begin
    FieldName := GetNextWord(OrderClause, [',']);
    if FieldName <> '' then
    begin
      //смотрим порядок сортировки
      I := Pos(' DESC', FieldName);
      Desc := I > 0;
      if I = 0 then
         I := Pos(' ASC', FieldName);
      if I > 0 then
        FieldName := Trim(Copy(FieldName, 1, Pred(I)));
      if FieldName[1] in DigitsSet then
        FieldName := Query.Fields[Pred(StrToInt(FieldName))].FieldName
      else
      begin
        // определяем имя поля или его origin
        I := Pos('.', FieldName);
        if I > 0 then
        for I := 0 to Pred(Query.FieldCount) do
          if Query.Fields[I].Origin <> '' then
          begin
            if Query.Fields[I].Origin = FieldName then
              FieldName := Query.Fields[I].FieldName;
          end
      end;
      Column := ColumnByFieldName(_Grid, FieldName);
      if Assigned(Column) then
      begin
        ColumnIndex := GetStringsObjectIndex(lbAllFields.Items, Column);
        Add(ColumnIndex);
        lbOrderFields.Checked[Pred(lbOrderFields.Items.Count)] := Desc;
      end;
    end;
  end;
end;

procedure TSortForm.Add(AItemIndex: Integer);
begin
  with lbOrderFields.Items do
  begin
    Add(lbAllFields.Items[AItemIndex]);
    Objects[Pred(Count)] := lbAllFields.Items.Objects[AItemIndex];
    lbAllFields.Items.Delete(AItemIndex);
  end;
end;

procedure TSortForm.Remove(AItemIndex: Integer);
begin
  with lbAllFields.Items do
  begin
    Add(lbOrderFields.Items[AItemIndex]);
    Objects[Pred(Count)] := lbOrderFields.Items.Objects[AItemIndex];
    lbOrderFields.Items.Delete(AItemIndex);
  end;
end;

procedure TSortForm.btnAddClick(Sender: TObject);
begin
  if lbAllFields.ItemIndex >= 0 then
    Add(lbAllFields.ItemIndex);
end;

procedure TSortForm.btnRemoveClick(Sender: TObject);
begin
  if lbOrderFields.ItemIndex >= 0 then
    Remove(lbOrderFields.ItemIndex);
end;

procedure TSortForm.btnAddAllClick(Sender: TObject);
begin
  while lbAllFields.Items.Count > 0 do
    Add(0);
end;

procedure TSortForm.btnRemoveAllClick(Sender: TObject);
begin
  while lbOrderFields.Items.Count > 0 do
    Remove(0);
end;

end.
