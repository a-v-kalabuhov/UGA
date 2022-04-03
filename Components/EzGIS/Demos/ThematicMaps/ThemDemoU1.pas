unit ThemDemoU1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ezentities, ezbasegis, ezCtrls, ExtCtrls, EzCmdLine,
  EzBasicCtrls;

type
  TForm1 = class(TForm)
    drawbox: TEzDrawBox;
    Gis1: TEzGis;
    CmdLine1: TEzCmdLine;
    Panel1: TPanel;
    Button4: TButton;
    Button1: TButton;
    Button3: TButton;
    Button2: TButton;
    Image1: TImage;
    Image2: TImage;
    Button5: TButton;
    Timer1: TTimer;
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    scolor : integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses ezsystem;

procedure TForm1.FormActivate(Sender: TObject);
var
  Path: string;
begin
  Path:= AddSlash(ExtractFilePath(ExpandFilename('..\..\data\txt.fnt')));
  if not FileExists(Path+'txt.fnt') then
  begin
    ShowMessage('No font files found !');
  end;
  Ez_VectorFonts.AddFontFile(Path+'complex.fnt');
  Ez_VectorFonts.AddFontFile(Path+'txt.fnt');
  //Ez_VectorFonts.AddFontFile(Path+'romanc.fnt');
  //Ez_VectorFonts.AddFontFile(Path+'arial.fnt');

  { ALWAYS load the symbols after the vectorial fonts
    because the symbols can include vectorial fonts entities and
    if the vector font is not found, then the entity will be configured
    with another font }
  if FileExists(Path + 'symbols.ezs') then
  begin
    Ez_Symbols.FileName:= Path + 'symbols.ezs';
    Ez_Symbols.Open;
  end;

  // load line types
  if FileExists(Path + 'Linetypes.ezl') then
  begin
    Ez_LineTypes.FileName:=Path + 'Linetypes.ezl';
    Ez_LineTypes.Open;
  end;

  Ez_Preferences.CommonSubDir:= Path;

  Gis1.FileName:= Path + 'SampleMap.Ezm';
  Gis1.Open;
  drawbox.ZoomToExtension;

  scolor := 0;
  timer1.Enabled := false;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  drawbox.CreatePieThematic( 'STATES_', 'UID;AREA;POP1990', true, 9, 0);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  inc(scolor);
  drawbox.CreatePieThematic( 'STATES_', 'UID;AREA;POP1990', true, 9, scolor);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  drawbox.CreateBarThematic( 'STATES_', 'UID;AREA;POP1990', true, 30,30, 0);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  inc(scolor);
  drawbox.CreateBarThematic( 'STATES_', 'UID;AREA;POP1990', true, 30,30, scolor);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  timer1.Enabled := not timer1.Enabled;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Button3.Click;
end;

end.
