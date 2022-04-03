unit uKisHistoryListEditor;

{$I KisFlags.pas}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uKisEntityEditor, StdCtrls, ExtCtrls, JvBaseDlg, JvDesktopAlert;

type
  TKisMapHistoryEditor = class(TKisEntityEditor)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    edOrderNumber: TEdit;
    edDateOfWorks: TEdit;
    gbArea: TGroupBox;
    Panel1: TPanel;
    edHighRiseMapping: TEdit;
    Panel2: TPanel;
    edMensMapping: TEdit;
    edTacheomMapping: TEdit;
    edCurrentChangesMapping: TEdit;
    edNewlyBuildingMapping: TEdit;
    edEnginNetMapping: TEdit;
    edTotalSum: TEdit;
    edWorksExecutor: TEdit;
    edDraftWorksExecutor: TEdit;
    edChief: TEdit;
    edDateOfAccept: TEdit;
    edHorizMapping: TEdit;
    gbGraphics: TGroupBox;
    btnSetMap: TButton;
    imgSurvey: TImage;
    procedure FormShow(Sender: TObject);
  end;


implementation

{$R *.dfm}

procedure TKisMapHistoryEditor.FormShow(Sender: TObject);
begin
  inherited;
  if Trim(edDateOfAccept.Text) = '' then
    edDateOfAccept.Text := DateToStr(Now);
end;

end.
