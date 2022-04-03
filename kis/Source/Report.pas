unit Report;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  StdCtrls, Buttons, Dialogs;

type
  TReportForm = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    edtReportName: TEdit;
    Label2: TLabel;
    edtFileName: TEdit;
    SelectBtn: TSpeedButton;
    OpenDialog: TOpenDialog;
    procedure SelectBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ShowReport(var ReportName, FileName: String): Boolean;

implementation

{$R *.DFM}

uses
  uKisAppModule;

function ShowReport(var ReportName, FileName: String): Boolean;
begin
  with TReportForm.Create(Application) do
  try
    edtReportName.Text := ReportName;
    edtFileName.Text := FileName;
    SetCurrentDir(AppModule.ReportsPath);
    Result:=ShowModal=mrOk;
    if Result then begin
      ReportName:=edtReportName.Text;
      FileName:=edtFileName.Text;
    end;
  finally
    Free;
  end;
end;

procedure TReportForm.SelectBtnClick(Sender: TObject);
begin
  OpenDialog.FileName:=edtFileName.Text;
  if OpenDialog.Execute then
    edtFileName.Text:=ExtractRelativePath(AppModule.ReportsPath,
      OpenDialog.FileName);
end;

end.
