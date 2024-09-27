unit fmProcessXML;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, sgcad, sgcadimage;

type
  TForm1 = class(TForm)
    edInputXML: TMemo;
    edOutputXML: TMemo;
    btnOpen: TButton;
    btnProcessXML: TButton;
    OpenDialog: TOpenDialog;
    btnNew: TButton;
    procedure btnProcessXMLClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FCADFile: THandle;
    procedure CloseDrawing;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnOpenClick(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    CloseDrawing;
    FCADFile := CreateCAD(Handle, PChar(OpenDialog.FileName));
  end;
end;

procedure TForm1.btnProcessXMLClick(Sender: TObject);
var
  vInput: string;
  vOutput: Variant;
begin
  vInput := edInputXML.Lines.Text;
  ProcessXML(FCADFile, PChar(vInput), vOutput);
  edOutputXML.Lines.Text := vOutput;
end;

procedure TForm1.btnNewClick(Sender: TObject);
begin
  CloseDrawing;
  FCADFile := CreateCAD(Handle, nil);
end;

procedure TForm1.CloseDrawing;
begin
  if FCADFile <> 0 then
  begin
    CloseCAD(FCADFile);
    FCADFile := 0;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FCADFile := 0;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  CloseDrawing;
end;

end.
