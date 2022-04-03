unit uProgressModule;

interface

uses
  SysUtils, Classes, Windows, ukaProgressForm, Forms;

type
  TkaProgressModule = class(TDataModule)
  private
    FMax: Cardinal;
    FView: TkaProgressForm;
    FProgress: Cardinal;
    FText: String;
    procedure CreateView;
    procedure SetProgress(const Value: Cardinal);
    procedure SetMax(const Value: Cardinal);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure StartProgress;
    procedure StopProgress;
    function InProgress: Boolean;
    property Progress: Cardinal read FProgress write SetProgress;
    property Max: Cardinal read FMax write SetMax;
    property Text: String read FText write Ftext;
  end;

implementation

{$R *.dfm}

{ TkaProggressModule }

constructor TkaProgressModule.Create(AOwner: TComponent);
begin
  inherited;
  FView := nil;
  FMax := 100;
  FProgress := 0;
  FText := '';
end;

procedure TkaProgressModule.CreateView;
begin
  if FView = nil then
  begin
    FView := TkaProgressForm.Create(nil);
    FView.Caption := 'Подождите...';
  end;
  FView.ProgressBar.Min := 0;
  FView.ProgressBar.Max := FMax;
  FView.ProgressBar.Position := FProgress;
  FView.Text.Caption := FText;
  if InProgress then
    FView.BringToFront;
end;

destructor TkaProgressModule.Destroy;
begin
  if Assigned(FView) then
    FView.Release;
  FView := nil;
  inherited;
end;

function TkaProgressModule.InProgress: Boolean;
begin
  Result := Assigned(FView) and FView.Visible;
end;

procedure TkaProgressModule.SetMax(const Value: Cardinal);
begin
  if FMax <> Value then
  begin
    FMax := Value;
    if FProgress = FMax then
    begin
      StopProgress;
    end
    else
      CreateView;
    Application.ProcessMessages;
  end;
end;

procedure TkaProgressModule.SetProgress(const Value: Cardinal);
begin
  if FProgress <> Value then
  begin
    FProgress := Value;
    if FProgress = FMax then
    begin
      StopProgress;
    end
    else
      CreateView;
    Application.ProcessMessages;
  end;
end;

procedure TkaProgressModule.StartProgress;
var
  I, FC: Integer;
begin
  CreateView;
  if not FView.Visible then
  begin
    FView.Show;
    FView.BringToFront;
    FC := Pred(Screen.FormCount);
    for I := 0 to FC do
    if Screen.Forms[I] <> FView then
    begin
      Screen.Forms[I].Enabled := False;
    end;
  end;
  Application.ProcessMessages;
end;

procedure TkaProgressModule.StopProgress;
var
  I, FC: Integer;
begin
  CreateView;
  FView.Hide;
  FC := Pred(Screen.FormCount);
  for I := 0 to FC do
    Screen.Forms[I].Enabled := True;
end;

end.
