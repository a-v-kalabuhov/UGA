unit uMStDialogMPLineColors;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, uDBGrid, IBCustomDataSet, IBUpdateSQL, DB, IBQuery, IBDatabase,
  uMStConsts, ComCtrls,
  uMStModuleMPColorSettings, Spin;

type
  TmstMPLineColorsDialog = class(TForm)
    btnClose: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    dbgLines: TkaDBGrid;
    btnEdit: TButton;
    Button1: TButton;
    dbgEdging: TkaDBGrid;
    Button2: TButton;
    Label1: TLabel;
    edLineWidth: TSpinEdit;
    Label2: TLabel;
    edEdgingWidth: TSpinEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnEditClick(Sender: TObject);
    procedure dbgLinesCellColors(Sender: TObject; Field: TField; var Background, FontColor: TColor;
      State: TGridDrawState; var FontStyle: TFontStyles);
    procedure dbgEdgingLogicalColumn(Sender: TObject; Column: TColumn; var Value: Boolean);
    procedure dbgEdgingCellClick(Column: TColumn);
    procedure dbgEdgingCellColors(Sender: TObject; Field: TField; var Background, FontColor: TColor;
      State: TGridDrawState; var FontStyle: TFontStyles);
    procedure dbgEdgingKeyPress(Sender: TObject; var Key: Char);
    procedure Button2Click(Sender: TObject);
    procedure dbgEdgingGetLogicalValue(Sender: TObject; Column: TColumn; var Value: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    FSettings: TmstMPColorSettingsModule;
  public
    procedure Execute();
  end;

implementation

{$R *.dfm}

procedure TmstMPLineColorsDialog.btnEditClick(Sender: TObject);
begin
  FSettings.EditLine;
end;

procedure TmstMPLineColorsDialog.Button2Click(Sender: TObject);
begin
  FSettings.EditEdging;
end;

procedure TmstMPLineColorsDialog.Execute;
var
  SaveChanges: Boolean;
begin
  if FSettings = nil then
    FSettings := TmstMPColorSettingsModule.Create(Self);
  SaveChanges := False;
  FSettings.OpenSettings;
  try
    dbgLines.DataSource := FSettings.LinesDataSource;
    dbgEdging.DataSource := FSettings.EdgingDataSource;
    edLineWidth.Value := TmstMPColorSettingsModule.LinePenWidth;
    edEdgingWidth.Value := TmstMPColorSettingsModule.EdgingWidth;
    SaveChanges := ShowModal = mrOK;
    if SaveChanges then
    begin
      TmstMPColorSettingsModule.LinePenWidth := edLineWidth.Value;
      TmstMPColorSettingsModule.EdgingWidth := edEdgingWidth.Value;
    end;
  finally
    FSettings.CloseSettings(SaveChanges);
  end;
end;

procedure TmstMPLineColorsDialog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TmstMPLineColorsDialog.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;
end;

procedure TmstMPLineColorsDialog.dbgEdgingCellClick(Column: TColumn);
begin
  if Column.FieldName = SF_HAS_BACKCOLOR then
  begin
    FSettings.SwitchCurrentStatusEdging;
  end;
end;

procedure TmstMPLineColorsDialog.dbgEdgingCellColors(Sender: TObject; Field: TField; var Background, FontColor: TColor;
  State: TGridDrawState; var FontStyle: TFontStyles);
var
  ColorHex: string;
  ColorInt: Integer;
  R, G, B, V: Byte;
begin
  if not Assigned(Field) then
    Exit;
  if Field.FieldName = SF_BACKCOLOR then
  begin
    ColorHex := Field.AsString;
    if not TryStrToInt(ColorHex, ColorInt) then
      ColorInt := clBlack;
    Background := ColorInt;
    R := GetRValue(Background);
    G := GetGValue(Background);
    B := GetBValue(Background);
    V := Round((R + G + B) / 3);
    if V < 140 then
      FontColor := clWhite
    else
      FontColor := clBlack;
  end;
end;

procedure TmstMPLineColorsDialog.dbgEdgingGetLogicalValue(Sender: TObject; Column: TColumn; var Value: Boolean);
begin
  if Column.FieldName = SF_HAS_BACKCOLOR then
  begin
    Value := Column.Field.AsInteger = 1;
  end;
end;

procedure TmstMPLineColorsDialog.dbgEdgingKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #32 then
    if dbgEdging.CurrentCol.FieldName = SF_HAS_BACKCOLOR then
      FSettings.SwitchCurrentStatusEdging;
end;

procedure TmstMPLineColorsDialog.dbgEdgingLogicalColumn(Sender: TObject; Column: TColumn; var Value: Boolean);
begin
  Value := Column.FieldName = SF_HAS_BACKCOLOR;
end;

procedure TmstMPLineColorsDialog.dbgLinesCellColors(Sender: TObject; Field: TField; var Background, FontColor: TColor;
  State: TGridDrawState; var FontStyle: TFontStyles);
var
  ColorHex: string;
  ColorInt: Integer;
  R, G, B, V: Byte;
begin
  if not Assigned(Field) then
    Exit;
  if Field.FieldName = SF_LINE_COLOR then
  begin
    ColorHex := Field.AsString;
    if not TryStrToInt(ColorHex, ColorInt) then
      ColorInt := clBlack;
    Background := ColorInt;
    R := GetRValue(Background);
    G := GetGValue(Background);
    B := GetBValue(Background);
    V := Round((R + G + B) / 3);
    if V < 140 then
      FontColor := clWhite
    else
      FontColor := clBlack;
  end;
end;

end.
