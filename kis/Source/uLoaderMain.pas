 unit uLoaderMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IBDatabase, DB, IBCustomDataSet, IBQuery, IBSQL,
  ExtCtrls;

type
  TForm1 = class(TForm)
    IBDatabase1: TIBDatabase;
    IBTransaction1: TIBTransaction;
    Memo1: TMemo;
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    IBSQL1: TIBSQL;
    OpenDialog1: TOpenDialog;
    RadioGroup1: TRadioGroup;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    Memo1.Lines.LoadFromFile(OpenDialog1.FileName);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  I: Integer;
begin
  IBTransaction1.StartTransaction;
  if CheckBox1.Checked then
  begin
    IBSQL1.SQL.Clear;
    case RadioGroup1.ItemIndex of
    0 : IBSQL1.SQL.Text := 'DELETE FROM OFFICE_DOC_TYPES WHERE OFFICES_ID='+Edit1.Text;
    1 : IBSQL1.SQL.Text := 'DELETE FROM OBJECT_TYPES WHERE OFFICES_ID='+Edit1.Text;
    2 : IBSQL1.SQL.Text := 'DELETE FROM EXECUTION_PHASES WHERE OFFICES_ID='+Edit1.Text;
    end;
    if IBSQL1.SQL.COunt > 0 then
      IBSQL1.ExecQuery;
  end;
  IBSQL1.SQL.Clear;
  case RadioGroup1.ItemIndex of
  0 : IBSQL1.SQL.Text := 'INSERT INTO OFFICE_DOC_TYPES(OFFICES_ID, NAME) VALUES (:OFFICES_ID, :NAME)';
  1 : IBSQL1.SQL.Text := 'INSERT INTO OBJECT_TYPES(OFFICES_ID, NAME) VALUES (:OFFICES_ID, :NAME)';
  2 : IBSQL1.SQL.Text := 'INSERT INTO EXECUTION_PHASES(OFFICES_ID, NAME) VALUES (:OFFICES_ID, :NAME)';
  end;
  if IBSQL1.SQL.COunt > 0 then
    for I := 0 to Pred(memo1.Lines.Count) do
    begin
      IBSQL1.ParamByName('NAME').AsString := Memo1.Lines[I];
      IBSQL1.ParamByName('OFFICES_ID').AsString := Edit1.Text;
      IBSQL1.ParamByName('OFFICES_ID').
      IBSQL1.ExecQuery;
    end;
  IBTransaction1.Commit;
end;

end.
