unit fProgr;

{***********************************************************}
{      MIF/Other import progress dialog                     }
{***********************************************************}
{$I EZ_FLAG.PAS}
interface

uses
  Windows, SysUtils, Classes, Controls, Forms, 
  ExtCtrls, ComCtrls, StdCtrls;

type
  TfrmProgressDlg = class(TForm)
    DispMsg: TLabel;
    ProgressBar1: TProgressBar;
    Label3: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
  private
    { Private declarations }
    {$IFDEF LEVEL3}
    procedure CreateParams(var Params: TCreateParams); override;
    {$ENDIF}
  public
    { Public declarations }
    {$IFDEF LEVEL4}
    procedure CreateParams(var Params: TCreateParams); override;
    {$ENDIF}
    function GetShortDispName(Const FileName : String ) : String;
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  ProgressParentHWND: THandle;
  frmProgressDialog: TfrmProgressDlg;

implementation

{$R *.DFM}

uses ezsystem, fMain;

Function TfrmProgressDlg.GetShortdispName(Const FileName : String ) : String;
var
 aTmp: array[0..50] of char;
begin
 FillChar(aTmp,sizeof(aTmp),0);
 if GetShortPathName(PChar(FileName),aTmp, sizeof(atmp)-1)=0 then
   Result:= FileName
 else
   Result:=StrPas(aTmp);
end;

procedure TfrmProgressDlg.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams( Params );
  with Params do
  begin
    Style := Style or WS_OVERLAPPED;
    WndParent := ProgressParentHWND;
  end;
end;

end.
