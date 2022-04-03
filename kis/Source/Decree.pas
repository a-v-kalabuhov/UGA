unit Decree;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  StdCtrls, DBCtrls, Mask, ComCtrls, Db, Dialogs, Printers,
  uDB;

type
  TDecreeForm = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    dbeDate: TDBEdit;
    dbeNumber: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    dbeInt_Date: TDBEdit;
    dbeInt_Number: TDBEdit;
    Label6: TLabel;
    dbmHeader: TDBMemo;
    dbcbChecked: TDBCheckBox;
    btnPrint: TButton;
    dblcDecreeTypes: TDBLookupComboBox;
    Label7: TLabel;
    dbmContent: TDBMemo;
    dsDecrees: TDataSource;
    dbeDecreeTypes: TDBEdit;
    PrintDialog: TPrintDialog;
    procedure btnPrintClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ShowDecree(DataSet: TDataSet; ReadOnly: Boolean=False): Boolean;

implementation

uses
  uKisClasses, uKisAppModule, uKisCOnsts;

{$R *.DFM}

function ShowDecree(DataSet: TDataSet; ReadOnly: Boolean=False): Boolean;
begin
  with TDecreeForm.Create(Application) do
  try
    dsDecrees.DataSet:=DataSet;
    if dblcDecreeTypes.Field.Lookup then
      dbeDecreeTypes.Visible := False
    else
      dblcDecreeTypes.Visible := False;
    btnCancel.Visible := not ReadOnly;
    Result := (ShowModal = mrOk);
  finally
    Release;
  end;
end;

procedure TDecreeForm.btnPrintClick(Sender: TObject);
var
  F: TextFile;
  I, C, FontSize: Integer;
  FontName, S: String;
  CharSet: TFontCharset;
begin
  if PrintDialog.Execute then
  begin
    C := Pred(dbmContent.Lines.Count);
    if C < 0 then
    begin
      Application.MessageBox(PChar(S_NOTHING_TO_PRINT), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      Exit;
    end;
    AssignPrn(F);
    FontName := Printer.Canvas.Font.Name;
    FontSize := Printer.Canvas.Font.Size;
    CharSet := Printer.Canvas.Font.Charset;
    try
      Rewrite(F);
      Printer.Canvas.Font.Name := 'Courier New';
      Printer.Canvas.Font.Size := 10;
      Printer.Canvas.Font.Charset := RUSSIAN_CHARSET;
      S := '          ';
      for I := 0 to 3 do
        WriteLn(F, S);
      for I := 0 to C do
        WriteLn(F, S + dbmContent.Lines[I]);
    finally
      CloseFile(F);
      Printer.Canvas.Font.Name := FontName;
      Printer.Canvas.Font.Size := FontSize;
      Printer.Canvas.Font.Charset := CharSet;
    end;
//    dbmContent.Print(Application.Title);
  end;
end;

procedure TDecreeForm.FormCreate(Sender: TObject);
begin
  dbcbChecked.Enabled := AppModule.User.IsAdministrator;
end;

procedure TDecreeForm.btnOkClick(Sender: TObject);
begin
  dbeNumber.DataSource.Dataset.SoftPost();
  ModalResult := mrOk;
end;

end.
