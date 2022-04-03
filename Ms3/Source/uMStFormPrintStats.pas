unit uMStFormPrintStats;

interface

{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CAST OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Grids, DBGrids, ExtCtrls, DBCtrls, DB, ComObj,
  uMStKernelInterfaces;

type
  TmstPrintStatsForm = class(TForm)
    Label1: TLabel;
    cbOffice: TComboBox;
    Label2: TLabel;
    cbUser: TComboBox;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    meSingleDay: TMaskEdit;
    Label3: TLabel;
    meStart: TMaskEdit;
    Label4: TLabel;
    meEnd: TMaskEdit;
    Button1: TButton;
    Button2: TButton;
    DataSource1: TDataSource;
    DBNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    Button3: TButton;
    procedure RadioButton1Click(Sender: TObject);
    procedure cbOfficeChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    FStats: IStats;
    procedure SetDataModule(const Value: IStats);
    procedure LoadOffices;
    procedure LoadPeople;
    procedure PrepareStatQuery;
  public
    property Stats: IStats read FStats write SetDataModule;
  end;

implementation

{$R *.dfm}

procedure TmstPrintStatsForm.Button1Click(Sender: TObject);
var
  D1: TDateTime;
begin
  if meSingleDay.Enabled then
    if not TryStrToDate(meSingleDay.Text, D1) then
    begin
      ShowMessage('Проверьте введенную дату!');
      meSingleDay.SetFocus;
      Exit;
    end;
  //
  if meStart.Enabled then
    if not TryStrToDate(meStart.Text, D1) then
    begin
      ShowMessage('Проверьте дату начала!');
      meStart.SetFocus;
      Exit;
    end;
  //
  if meEnd.Enabled then
    if not TryStrToDate(meEnd.Text, D1) then
    begin
      ShowMessage('Проверьте дату конца!');
      meEnd.SetFocus;
      Exit;
    end;
  //
  try
    PrepareStatQuery;
  finally
    Button3.Enabled := Assigned(DataSource1.DataSet) and
      DataSource1.DataSet.Active;
    DBGrid1.ParentColor := not Button3.Enabled;
    if Button3.Enabled then
      DBGrid1.Color := clWindow;
    DBGrid1.Enabled := Button3.Enabled;
  end;
end;

procedure TmstPrintStatsForm.Button3Click(Sender: TObject);
var
  ExApp, WB, Sheet, Range: OleVariant;
  Row, RecNo, I: Integer;
  Fn: String;
  D1, D2: TDateTime;
begin
  // create excel doc
  ExApp := CreateOleObject('Excel.Application');
  WB := ExApp.WorkBooks.Add;
  if WB.Sheets.Count = 0 then
    Sheet := WB.Sheets.Add
  else
    Sheet := WB.Sheets[1];
  // create header
  Row := 1;
  Sheet.Cells[Row, 1] := 'Статистика печати планшетов';
  Inc(Row);
  //
  if meSingleDay.Enabled then
  begin
    TryStrToDate(meSingleDay.Text, D1);
    Sheet.Cells[Row, 1] := 'за ' + DateToStr(D1);
  end
  else
  if meStart.Enabled then
  begin
    TryStrToDate(meStart.Text, D1);
    TryStrToDate(meEnd.Text, D2);
    Sheet.Cells[Row, 1] := 'c ' + DateToStr(D1) + ' по ' + DateToStr(D2);
  end;
  Inc(Row);
  //
  if cbOffice.ItemIndex > 0 then
  begin
    Sheet.Cells[Row, 1] := 'Отдел:';
    Sheet.Cells[Row, 2] := cbOffice.Text;
    Inc(Row);
  end;
  //
  if cbUser.ItemIndex > 0 then
  begin
    Sheet.Cells[Row, 1] := 'Сотрудник:';
    Sheet.Cells[Row, 2] := cbUser.Text;
    Inc(Row);
  end;
  //
  Inc(Row);
  for I := 0 to DBGrid1.Columns.Count - 1 do
  begin
    Sheet.Cells[Row, I + 1] := DBGrid1.Columns[I].Title.Caption;
    Range := Sheet.Cells[Row, I + 1];
    Range.Font.Bold := True;
    Range.Borders.Weight := 3;
  end;
  Inc(Row);
  //
  RecNo := FStats.DataSet.RecNo;
  FStats.DataSet.DisableControls;
  try
    FStats.DataSet.First;
    while not FStats.DataSet.Eof do
    begin
      for I := 0 to DBGrid1.Columns.Count - 1 do
      begin
        Fn := DBGrid1.Columns[I].FieldName;
        Sheet.Cells[Row, I + 1] := FStats.DataSet.FieldByName(Fn).AsString;
      end;
      Inc(Row);
      FStats.DataSet.Next;
    end;
  finally
    FStats.DataSet.RecNo := RecNo;
    FStats.DataSet.EnableControls;
  end;
  // formating
  Range := Sheet.Columns[1];
  Range.ColumnWidth := 35;
  Range := Sheet.Columns[2];
  Range.ColumnWidth := 25;
  Range := Sheet.Columns[3];
  Range.ColumnWidth := 25;
  Range := Sheet.Columns[4];
  Range.ColumnWidth := 25;
  // show
  ExApp.Visible:= True;
end;

procedure TmstPrintStatsForm.cbOfficeChange(Sender: TObject);
begin
  LoadPeople;
end;

procedure TmstPrintStatsForm.LoadOffices;
var
  Offices: TStrings;
begin
  cbOffice.Clear;
  cbOffice.AddItem('Все', nil);
  cbOffice.ItemIndex := 0;
  Offices := FStats.GetOffices();
  try
    cbOffice.Items.AddStrings(Offices);
  finally
    Offices.Free;
  end;
end;

procedure TmstPrintStatsForm.LoadPeople;
var
  OfficeId: Integer;
  People: TStrings;
begin
  cbUser.Clear;
  cbUser.AddItem('Все', nil);
  cbUser.ItemIndex := 0;
  //
  OfficeId := Integer(cbOffice.Items.Objects[cbOffice.ItemIndex]);
  People := FStats.GetPeople(OfficeId);
  try
    cbUser.Items.AddStrings(People);
  finally
    People.Free;
  end;
end;

procedure TmstPrintStatsForm.PrepareStatQuery;
var
  D1, D2: TDateTime;
  OfficeId, PeopleId: Integer;
begin
  if meSingleDay.Enabled then
  begin
    TryStrToDate(meSingleDay.Text, D1);
  end
  else
  if meStart.Enabled then
  begin
    TryStrToDate(meStart.Text, D1);
    TryStrToDate(meEnd.Text, D2);
  end;
  //
  OfficeId := Integer(cbOffice.Items.Objects[cbOffice.ItemIndex]);
  PeopleId := Integer(cbUser.Items.Objects[cbUser.ItemIndex]);
  //
  FStats.PrepareDataSet(OfficeId, PeopleId, D1, D2, meSingleDay.Enabled or meStart.Enabled, meStart.Enabled);
end;

procedure TmstPrintStatsForm.RadioButton1Click(Sender: TObject);
begin
  meSingleDay.Enabled := RadioButton1.Checked;
  meStart.Enabled := not RadioButton1.Checked;
  meEnd.Enabled := not RadioButton1.Checked;
  //
  meSingleDay.ParentColor := not meSingleDay.Enabled;
  if meSingleDay.Enabled then
    meSingleDay.Color := clWindow;
  //
  meStart.ParentColor := not meStart.Enabled;
  if meStart.Enabled then
    meStart.Color := clWindow;
  //
  meEnd.ParentColor := not meEnd.Enabled;
  if meEnd.Enabled then
    meEnd.Color := clWindow;
end;

procedure TmstPrintStatsForm.SetDataModule(const Value: IStats);
begin
  if Assigned(FStats) then
    FStats.Close;
  FStats := Value;
  LoadOffices;
  LoadPeople;
  //
  DataSource1.DataSet := FStats.DataSet;
end;

end.
