unit uMStFormSplash;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, GraphicEx;

type
  TmstSplashForm = class(TForm)
    Shape1: TShape;
    lMessage: TLabel;
    ProgressBar: TProgressBar;
    Label2: TLabel;
    lCounter: TLabel;
    Label4: TLabel;
    Image2: TImage;
    Label1: TLabel;
    Label3: TLabel;
    lVersion: TLabel;
    procedure FormShow(Sender: TObject);
  end;

implementation

{$R *.dfm}

uses
  uCommonUtils;

procedure TmstSplashForm.FormShow(Sender: TObject);
begin
  lVersion.Caption := 'Версия: ' + GetVersionInfo(Application.ExeName);
end;

end.
