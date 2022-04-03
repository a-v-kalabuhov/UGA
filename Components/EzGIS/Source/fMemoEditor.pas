unit fMemoEditor;

{$I EZ_FLAG.PAS}
interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, Messages;

type
  TfrmMemoEditor = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Memo1: TMemo;
    Label1: TLabel;
    procedure Memo1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  end;

implementation

{$R *.DFM}

procedure TfrmMemoEditor.Memo1Change(Sender: TObject);
//var
  //LineNumber, ColNumber: Integer;
begin
  //LineNumber  := SendMessage(Memo1.Handle, EM_LINEFROMCHAR, 0, Memo1.SelStart);
  //ColNumber := (Memo1.SelStart - SendMessage(Memo1.Handle, EM_LINEINDEX, LineNumber, 0));
{$IFDEF LANG_ENG}
  Label1.Caption:= Format('%d Lines', [Memo1.Lines.Count]);;
{$ENDIF}
{$IFDEF LANG_SPA}
  Label1.Caption:= Format('%d Lineas', [Memo1.Lines.Count]);;
{$ENDIF}
    //Format('%d Lines; Row %d, Col %d', [Memo1.Lines.Count, LineNumber, ColNumber]);
end;

procedure TfrmMemoEditor.FormCreate(Sender: TObject);
begin
{$IFDEF LANG_SPA}
  Caption:= 'Editor de lista de cadenas';
  OKBtn.Caption:='Aceptar';
  CancelBtn.caption:='Cancelar';
{$ENDIF}
end;

end.
