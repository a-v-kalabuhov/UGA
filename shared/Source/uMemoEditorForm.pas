unit uMemoEditorForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uAppForm, Menus, ComCtrls, StdCtrls, StdActns, ActnList, ToolWin;


type
  TkaMemoEditorForm = class(TkaAppForm)
    Memo: TMemo;
    StatusBar: TStatusBar;
    MainMenu: TMainMenu;
    PopupMenu: TPopupMenu;
    ActionList: TActionList;
    Cut: TEditCut;
    Copy: TEditCopy;
    Paste: TEditPaste;
    SelectAll: TEditSelectAll;
    Undo: TEditUndo;
    Delete: TEditDelete;
    acLoad: TAction;
    acExit: TAction;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    miCustom: TMenuItem;
    procedure acExitExecute(Sender: TObject);
    procedure kaAppFormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure acLoadExecute(Sender: TObject);
  public

  end;

implementation

{$R *.dfm}

procedure TkaMemoEditorForm.acExitExecute(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TkaMemoEditorForm.kaAppFormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  I: Integer;
begin
  inherited;
  I := MessageBox(Self.Handle, PChar('Сохранить изменения?'),
    PChar('Внимание!'), MB_YESNOCANCEL + MB_ICONQUESTION);
  case I of
  ID_YES :
    begin
      ModalResult := mrOK;
      CanClose := True;
    end;
  ID_NO :
    begin
      ModalResult := mrCancel;
      CanClose := True;
    end;
  ID_CANCEL :
    begin
       CanClose := False;
    end;
  end;
end;

procedure TkaMemoEditorForm.acLoadExecute(Sender: TObject);
var
  OldText: String;
begin
  inherited;
  with TOpenDialog.Create(Self) do
  begin
    Filter := 'Текстовые файлы|*.txt';
    DefaultExt := 'txt';
    if Execute then
    try
      OldText := Memo.Lines.Text;
      Memo.Lines.LoadFromFile(FileName);
    except
      MessageBox(Self.Handle, PChar('Невозможно загрузить текст из файла '
        + FileName), PChar('Ошибка!'), MB_OK + MB_ICONERROR);
      Memo.Lines.Text := OldText;
    end;
    Free;
  end;
end;

end.
