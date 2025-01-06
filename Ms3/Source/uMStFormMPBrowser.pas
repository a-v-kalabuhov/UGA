unit uMStFormMPBrowser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  EzBaseGIS;

type
  TmstMPBrowserForm = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FDrawBox: TEzBaseDrawBox;
    procedure PrepareDataSet();
    procedure SetDrawBox(const Value: TEzBaseDrawBox);
  public
    procedure Browse();
    //
    property DrawBox: TEzBaseDrawBox read FDrawBox write SetDrawBox;
  end;

var
  mstMPBrowserForm: TmstMPBrowserForm;

implementation

{$R *.dfm}

{ TmstMPBrowserForm }

procedure TmstMPBrowserForm.Browse;
begin
  if not Visible then
  begin
    PrepareDataSet();
    Show;
  end;
end;

procedure TmstMPBrowserForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  mstMPBrowserForm := nil;
  Action := caFree;
end;

procedure TmstMPBrowserForm.PrepareDataSet;
begin

end;

procedure TmstMPBrowserForm.SetDrawBox(const Value: TEzBaseDrawBox);
begin
  FDrawBox := Value;
end;

end.
