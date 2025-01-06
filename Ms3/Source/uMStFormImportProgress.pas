unit uMStFormImportProgress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TMStImportProgressForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    ProgressBar1: TProgressBar;
    lElapsed: TLabel;
    lEstimated: TLabel;
  private
    fStartTime: TDateTime;
  public
    procedure Start(const aFilename: string; const Total: Integer);
    procedure Stop();
    procedure UpdateProgress(const Processed, Errors: Integer);
  end;

implementation

{$R *.dfm}

{ TForm2 }

procedure TMStImportProgressForm.Start(const aFilename: string; const Total: Integer);
begin
  ProgressBar1.Min := 0;
  ProgressBar1.Max := Total;
  Label8.Caption := aFilename;
  Label4.Caption := IntToStr(Total);
  Label5.Caption := '0';
  Label6.Caption := '0';
  fStartTime := Now();
end;

procedure TMStImportProgressForm.Stop;
begin
  Close;
end;

procedure TMStImportProgressForm.UpdateProgress(const Processed, Errors: Integer);
var
  I: Integer;
  //Part: Double;
  Elapsed: TDateTime;
  Estimated: TDateTime;
begin
  Label5.Caption := IntToStr(Processed);
  Label6.Caption := IntToStr(Errors);
  I := Processed + Errors;
  ProgressBar1.Position := I;
  if (I >= 10) and (ProgressBar1.Max - I > 10) then
  begin
    Elapsed := Now() - fStartTime;
    lElapsed.Caption := 'Прошло: ' + TimeToStr(Elapsed);
    //Part := I / ProgressBar1.Max;
    Estimated := Elapsed / I * (ProgressBar1.Max - I);
    lEstimated.Caption := 'Осталось: ' + TimeToStr(Estimated);
    lElapsed.Visible := True;
    lEstimated.Visible := True;
  end
  else
  begin
    lElapsed.Visible := False;
    lEstimated.Visible := False;
  end;
  Application.ProcessMessages;
end;

end.
