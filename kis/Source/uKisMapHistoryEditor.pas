unit uKisMapHistoryEditor;

{$I KisFlags.pas}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uKisEntityEditor, StdCtrls, ExtCtrls,
  JvBaseDlg, JvDesktopAlert;

type
  TKisMapHistoryEditor = class(TKisEntityEditor)
    Label1: TLabel;
    Label2: TLabel;
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
    edCurrentChangesMapping: TEdit;
    edNewlyBuildingMapping: TEdit;
    edEnginNetMapping: TEdit;
    edTotalSum: TEdit;
    edWorksExecutor: TEdit;
    edDraftWorksExecutor: TEdit;
    edChief: TEdit;
    edDateOfAccept: TEdit;
    gbGraphics: TGroupBox;
    imgSurvey: TImage;
    Label4: TLabel;
    edHorizMapping: TEdit;
    Label5: TLabel;
    edHighRiseMapping: TEdit;
    Label8: TLabel;
    edTacheomMapping: TEdit;
    Label7: TLabel;
    edMensMapping: TEdit;
    btnSetMap: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    FOnUpdateImage: TNotifyEvent;
    procedure SetOnUpdateImage(const Value: TNotifyEvent);
  published
  public
    property OnUpdateImage: TNotifyEvent read FOnUpdateImage write SetOnUpdateImage;
  end;


implementation

{$R *.dfm}

procedure TKisMapHistoryEditor.FormResize(Sender: TObject);
var
  W, H: Integer;
begin
  inherited;
  W := gbGraphics.Width - 16;
  H := gbGraphics.Height - 24;
  if W > H then
    W := H;
  if (imgSurvey.Width <> W) or (imgSurvey.Height <> W) then
  begin
    imgSurvey.Width := W;
    imgSurvey.Height := W;
    //
    if Assigned(FOnUpdateImage) then
      FOnUpdateImage(Self);
  end;
end;

procedure TKisMapHistoryEditor.FormShow(Sender: TObject);
begin
  inherited;
  if Trim(edDateOfAccept.Text) = '' then
    edDateOfAccept.Text := DateToStr(Now);
end;

procedure TKisMapHistoryEditor.SetOnUpdateImage(const Value: TNotifyEvent);
begin
  FOnUpdateImage := Value;
end;

end.
