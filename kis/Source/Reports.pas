unit Reports;

interface

uses
  // System
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  StdCtrls, IniFiles, Menus;

type
  TReportsForm = class(TForm)
    lbReports: TListBox;
    btnAdd: TButton;
    btnDelete: TButton;
    btnEdit: TButton;
    btnOk: TButton;
    btnCancel: TButton;
    procedure btnDeleteClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
  private
    RepIni: TIniFile;
    Reports: TStrings;
    procedure ReadReportNames;
  public
  end;

  function ShowReports(const SectionName: string): Boolean;
  procedure ReadReports(const SectionName: string; Reports: TStrings);
  procedure SaveReports(const SectionName: string; Reports: TStrings);
  procedure ReadReportsToMenu(Reports: TStrings; MenuItem: TMenuItem;
    Event: TNotifyEvent);

implementation

{$R *.DFM}

uses
  // Project
  AProc6, Report, uKisAppModule, uKisConsts;

function ShowReports(const SectionName: string): Boolean;
begin
  with TReportsForm.Create(Application) do
  try
    RepIni := TIniFile.Create(AppModule.ReportsPath + S_REPORTINI);
    Reports := TStringList.Create;
    ReadReports(SectionName,Reports);
    ReadReportNames;
    Result:=ShowModal=mrOk;
    if Result then SaveReports(SectionName,Reports);
  finally
    if RepIni<>nil then RepIni.Free;
    if Reports<>nil then Reports.Free;
    Free;
  end;
end;

procedure ReadReports(const SectionName: string; Reports: TStrings);
var
  Ini: TIniFile;
begin
  Ini:=TIniFile.Create(AppModule.ReportsPath + S_REPORTINI);
  Reports.Clear;
  try
    Ini.ReadSectionValues(SectionName,Reports);
  finally
    Ini.Free;
  end;
end;

procedure SaveReports(const SectionName: string; Reports: TStrings);
var
  Ini: TIniFile;
  I: Integer;
begin
  Ini:=TIniFile.Create(AppModule.ReportsPath + S_REPORTINI);
  try
    Ini.EraseSection(SectionName);
    for I:=0 to Reports.Count-1 do
      Ini.WriteString(SectionName,Reports.Names[I],Reports.Values[Reports.Names[I]]);
  finally
    Ini.Free;
  end;
end;

procedure TReportsForm.ReadReportNames;
var
  I: Integer;
begin
  lbReports.Items.BeginUpdate;
  try
    lbReports.Items.Clear;
    for I := 0 to Pred(Reports.Count) do lbReports.Items.Add(Reports.Names[I]);
  finally
    lbReports.Items.EndUpdate;
  end;
end;

procedure TReportsForm.btnDeleteClick(Sender: TObject);
begin
  if (lbReports.ItemIndex >= 0) and
     (MessageBox(0, PChar(S_CONFIRM_DELETE_REPORT), PChar(S_CONFIRM), MB_ICONQUESTION+MB_OKCANCEL)=IDOK) then begin
    Reports.Delete(lbReports.ItemIndex);
    ReadReportNames;
  end;
end;

procedure TReportsForm.btnAddClick(Sender: TObject);
var
  ReportName, FileName: String;
begin
  if ShowReport(ReportName,FileName) then
  begin
    Reports.Values[ReportName] := FileName;
    ReadReportNames;
  end;
end;

procedure TReportsForm.btnEditClick(Sender: TObject);
var
  ReportName, FileName: String;
begin
  if lbReports.ItemIndex < 0 then Exit;
  ReportName := Reports.Names[lbReports.ItemIndex];
  FileName := Reports.Values[ReportName];
  if ShowReport(ReportName, FileName) then
  begin
    Reports[lbReports.ItemIndex] := ReportName + '=' + FileName;
    ReadReportNames;
  end;
end;

procedure ReadReportsToMenu(Reports: TStrings; MenuItem: TMenuItem;
  Event: TNotifyEvent);
var
  I: Integer;
  NewItem: TMenuItem;
begin
  //удаляем обновляемые пункты меню
  for I := Pred(MenuItem.Count) downto 0 do
    if MenuItem.Items[I].Tag = 0 then
      MenuItem.Delete(I);
  //добавляем разделитель
  if MenuItem.Count > 0 then
  begin
    NewItem := TMenuItem.Create(MenuItem);
    NewItem.Caption := '-';
    MenuItem.Add(NewItem);
  end;
  //добавляем пункты меню
  for I := 0 to Pred(Reports.Count) do
  begin
    NewItem := TMenuItem.Create(MenuItem);
    NewItem.Caption := Reports.Names[I];
    NewItem.OnClick := Event;
    MenuItem.Add(NewItem);
  end;
end;

end.
