unit uKisFileReportForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ImgList,
  uKisFileReport;

type
  TKisFileReportForm = class(TForm)
    ListView1: TListView;
    btnClose: TButton;
    ImageList1: TImageList;
    btnTakeBack: TButton;
    procedure btnCloseClick(Sender: TObject);
  private type
    TViewMode = (vmReport, vmTakeBack);
  private
    procedure SetViewMode(Value: TKisFileReportForm.TViewMode);
  public
    procedure Execute(aReport: TFileReport); 
    function Execute2(aReport: TFileReport; OnProcessReport: TNotifyEvent): Boolean;
  end;

var
  KisFileReportForm: TKisFileReportForm;

implementation

{$R *.dfm}

procedure TKisFileReportForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TKisFileReportForm.Execute(aReport: TFileReport);
var
  I: Integer;
  Itm: TListItem;
begin
  SetViewMode(vmReport);
  ListView1.Clear;
  for I := 0 to aReport.Count - 1 do
  begin
    Itm := ListView1.Items.Add;
    Itm.Caption := ExtractFileName(aReport[I].FileName);
    Itm.SubItems.Add(aReport[I].Text);
    if aReport[I].Status then
      Itm.ImageIndex := 0
    else
      Itm.ImageIndex := 1;
  end;
  ShowModal;
end;

function TKisFileReportForm.Execute2(aReport: TFileReport;
  OnProcessReport: TNotifyEvent): Boolean;
begin
  // проверяем есть ли файлы на приём
  // если есть, то показываем кнопки и добавляем колонки
  // если нет, то показываем в режиме отчёта
  SetViewMode(vmReport);
  SetViewMode(vmTakeBack);
  btnTakeBack.Visible := Assigned(OnProcessReport);
  btnTakeBack.OnClick := OnProcessReport;
end;

procedure TKisFileReportForm.SetViewMode(Value: TKisFileReportForm.TViewMode);
begin
  case Value of
    vmReport:
      begin
        btnTakeBack.Visible := False;
        with ListView1.Columns do
          while Count > 2 do
            Delete(Count - 1);
      end;
    vmTakeBack:
      begin
        btnTakeBack.Visible := True;
        with ListView1.Columns do
          if Count = 2 then
          begin
            with ListView1.Columns.Add do
            begin
              Caption := 'Сравнить';
            end;
            with ListView1.Columns.Add do
            begin
              Caption := 'Изменения';
            end;
          end;
      end;
  end;
end;

end.
