unit uMStDialogMPLineColors;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, uDBGrid, IBCustomDataSet, IBUpdateSQL, DB, IBQuery, IBDatabase,
  uMStConsts;

type
  TmstMPLineColorsDialog = class(TForm)
    kaDBGrid1: TkaDBGrid;
    btnClose: TButton;
    btnEdit: TButton;
    ColorDialog1: TColorDialog;
    DataSource1: TDataSource;
    ibtLineColors: TIBTransaction;
    ibqLineColors: TIBQuery;
    updLineColors: TIBUpdateSQL;
    ibqLineColorsID: TIntegerField;
    ibqLineColorsNAME: TIBStringField;
    ibqLineColorsIS_GROUP: TSmallintField;
    ibqLineColorsGROUP_ID: TIntegerField;
    ibqLineColorsLINE_COLOR: TIBStringField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure kaDBGrid1CellColors(Sender: TObject; Field: TField; var Background, FontColor: TColor;
      State: TGridDrawState; var FontStyle: TFontStyles);
    procedure ibqLineColorsLINE_COLORGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  private
    { Private declarations }
  public
    procedure Execute();
  end;

implementation

{$R *.dfm}

procedure TmstMPLineColorsDialog.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TmstMPLineColorsDialog.btnEditClick(Sender: TObject);
var
  ClrHex: string;
  ClrInt: Integer;
begin
  ibqLineColors.Edit;
  ClrHex := ibqLineColorsLINE_COLOR.Value;
  if not TryStrToInt(ClrHex, ClrInt) then
    ClrInt := clBlack;
  ColorDialog1.Color := ClrInt;
  if ColorDialog1.Execute(Self.Handle) then
  begin
    ClrInt := ColorDialog1.Color;
    ClrHex := '$' + IntToHex(ClrInt, 6);
    ibqLineColorsLINE_COLOR.Value := ClrHex;
    ibqLineColors.Post;
  end
  else
    ibqLineColors.Cancel;
  ibtLineColors.CommitRetaining;
end;

procedure TmstMPLineColorsDialog.Execute;
begin
  ibtLineColors.StartTransaction;
  try
    ibqLineColors.Open;
    ShowModal;
  finally
    ibtLineColors.Commit;
  end;
end;

procedure TmstMPLineColorsDialog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TmstMPLineColorsDialog.ibqLineColorsLINE_COLORGetText(Sender: TField; var Text: string; DisplayText: Boolean);
var
  ColorInt: Integer;
begin
  if not TryStrToInt(Text, ColorInt) then
    Text := '$000000';
end;

procedure TmstMPLineColorsDialog.kaDBGrid1CellColors(Sender: TObject; Field: TField; var Background, FontColor: TColor;
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
    if V < 120 then
      FontColor := clWhite
    else
      FontColor := clBlack;
  end;
end;

end.
