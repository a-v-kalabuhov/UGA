unit sgAboutDlg;
{$INCLUDE SGDXF.inc}
interface

uses
  sgConsts;

  function ShowAboutDlg(const ACaption: string): Integer;

implementation

uses
  Classes, Graphics, Forms, Controls, Dialogs, ExtCtrls, StdCtrls, ShellAPI;

function ShowAboutDlg(const ACaption: string): Integer;
var
  vForm: TForm;
  vRight, vLeft, vTop: Integer;
  vMessage: TLabel;
  vBtnOk: TButton;

  function ShellOpen(const AFileName: string): THandle;
  begin
    Result := ShellExecute(Application.Handle, 'open', PChar(AFileName), '', '', 5{SW_SHOW});
  end;

  procedure LabelClick(ASelf: TEdit; ASender: TObject);
  begin
    if Pos('@', ASelf.Text) > 0 then
      ShellOpen('mailto:' + ASelf.Text + '?subject='+Application.MainForm.Caption+'&Body='+'')
    else
      ShellOpen(ASelf.Text);
    ASelf.Font.Color := clPurple;
  end;

  function CreateLabel(const ACaption: string; AForm: TForm; ALeft: Integer;
    var ARight: Integer; var ATop: Integer): TEdit;
  var
    MethodOnClick: TMethod;
    vOnClick: TNotifyEvent absolute MethodOnClick;
  begin
    Result := TEdit.Create(AForm);
    Result.ReadOnly := True;
    Result.Ctl3D := False;
    Result.BorderStyle := bsNone;
    Result.Brush.Assign(AForm.Brush);
{$IFDEF SGDEL_2009}
    Result.Font := Screen.MessageFont;
{$ENDIF}
    Result.Font.Color := clBlue;
    Result.Font.Style := [fsUnderline];
    Result.Parent := AForm;
    Result.Text := ACaption;
    Result.Left := ALeft;
    Result.Top := ATop;
    Result.Cursor := crHandPoint;
    Result.Width := AForm.Canvas.TextWidth(ACaption) + 4;
    if Result.BoundsRect.Right > ARight then
      ARight := Result.BoundsRect.Right;
    ATop := Result.Top + AForm.Canvas.TextHeight(ACaption);
    MethodOnClick.Code := @LabelClick;
    MethodOnClick.Data := Result;
    Result.OnClick := vOnClick;
  end;

begin
  vForm := CreateMessageDialog('Website: '#13#10'E-mail: '#13#10'Support: ',
    mtInformation, [mbOK]);
  try
    vForm.Caption := ACaption;
    vForm.Position := poMainFormCenter;
    vMessage := TLabel(vForm.FindComponent('Message'));
    vRight := vMessage.BoundsRect.Right;
    vTop := vMessage.Top;
    vLeft := vMessage.BoundsRect.Right + 8;
    CreateLabel(sWebAddress, vForm, vLeft, vRight, vTop);
    CreateLabel('info@cadsofttools.com', vForm, vLeft, vRight, vTop);
    CreateLabel('support@cadsofttools.com', vForm, vLeft, vRight, vTop);
    vForm.ClientWidth := vRight + 8;
    vBtnOk := TButton(vForm.FindComponent('OK'));
    vBtnOk.Left := (vForm.ClientWidth - vBtnOk.Width) div 2;
    Result := vForm.ShowModal;
  finally
    vForm.Free;
  end;
end;

end.
