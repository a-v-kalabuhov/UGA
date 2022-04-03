unit MSOUtils;

interface

  function WordApplication(var word: Variant): Boolean;
  function CloseWord(var word: Variant): Boolean;
  function VisioApplication(var visio: Variant): Boolean;
  function CloseVisio(var visio: Variant): Boolean;

implementation

uses
  ComObj, Dialogs, Variants;

const
  sCantStart = 'Не удалось запустить ';
  sMSWord = 'Word';
  sMSVisio = 'Visio';
  sOooh = '!';

function WordApplication(var word: Variant): Boolean;
begin
  result := False;
  try
    word := CreateOLEObject('Word.Application');
    result := True;
  except
    on E: EOleError  do
    begin
      MessageDlg(sCantStart + sMSWord + sOooh, mtWarning, [mbOK], 0);
      exit;
    end;
    on E: EOleSysError do
    begin
      MessageDlg(sCantStart + sMSWord + sOooh, mtWarning, [mbOK], 0);
      exit;
    end;
    on E: EOleException do
    begin
      MessageDlg(sCantStart + sMSWord + sOooh, mtWarning, [mbOK], 0);
      exit;
    end;
  end;
end;

function CloseWord(var word: Variant): Boolean;
begin
  result := False;
  try
    if not VarIsEmpty(word) then
    {if not Word.Visible then} Word.Quit;
    VarClear(word);
    result := True;
  except
    on E: EOleError do ;
    on E: EOleSysError do ;
    on E: EOleException do ;
  end;
end;

function VisioApplication(var visio: Variant): Boolean;
begin
  result := False;
  try
    visio := CreateOLEObject('Visio.Application');
    result := True;
  except
    on E: EOleError  do
    begin
      MessageDlg(sCantStart + sMSVisio + sOooh, mtWarning, [mbOK], 0);
      exit;
    end;
    on E: EOleSysError do
    begin
      MessageDlg(sCantStart + sMSVisio + sOooh, mtWarning, [mbOK], 0);
      exit;
    end;
    on E: EOleException do
    begin
      MessageDlg(sCantStart + sMSVisio + sOooh, mtWarning, [mbOK], 0);
      exit;
    end;
  end;
end;

function CloseVisio(var visio: Variant): Boolean;
begin
  result := False;
  try
    if not VarIsEmpty(visio) then
      visio.Quit;
    VarClear(visio);
    result := True;
  except
    on E: EOleError do ;
    on E: EOleSysError do ;
    on E: EOleException do ;
  end;
end;

end.
