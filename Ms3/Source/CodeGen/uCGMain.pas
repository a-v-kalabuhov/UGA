unit uCGMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Button2: TButton;
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

uses
  StrUtils;

procedure TForm1.Button1Click(Sender: TObject);
var
  Code: TStringList;
  I, J: Integer;
  S, Fld: String;
begin
  Code := TStringList.Create;
  try
    for I := 0 to Memo1.Lines.Count - 1 do
    begin
      S := Memo1.Lines[I];
      if S <> '' then
      begin
        Fld := S;
        Code.Add('  P := Q.ParamByName(SF_' + Fld + ');');
        Code.Add('  if Assigned(P) then');
        S := AnsiLowerCase(S);
        S[1] := AnsiUpperCase(S[1])[1];
        J := Pos('_', S);
        while J > 0 do
        begin
          Delete(S, J, 1);
          if J < Length(S) then
            S[J] := AnsiUpperCase(S[J])[1];
          J := Pos('_', S);
        end;
        Code.Add('    P.AsString := aKiosk.' + S + ';');
      end;
    end;
    Memo1.lines.Assign(Code);
  finally
    Code.Free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Code: TStringList;
  I, J: Integer;
  S: String;
begin
  Code := TStringList.Create;
  try
    J := 0;
    for I := 0 to Memo1.Lines.Count - 1 do
    begin
      S := Memo1.Lines[I];
      if S <> '' then
      begin
        if J > 0 then
          S := '+ ''' + S + ''''
        else
          S := '  ''' + S + '''';
        Code.Add(S);
        Inc(J);
      end;
    end;
    Memo1.Lines.Assign(Code);
  finally
    Code.Free;
  end;
end;

end.
