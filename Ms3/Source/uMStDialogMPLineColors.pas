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
    function GetColorHex(Dollar: Boolean): string;
    procedure UpdateCustomColors;
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
  UpdateCustomColors;
  //
  ibqLineColors.Edit;
  ClrHex := GetColorHex(True);
  ClrInt := StrToInt(ClrHex);
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

function TmstMPLineColorsDialog.GetColorHex(Dollar: Boolean): string;
var
  ColorHex: string;
  ColorInt: Integer;
begin
  ColorHex := ibqLineColorsLINE_COLOR.Value;
  if TryStrToInt(ColorHex, ColorInt) then
  begin
    Result := ColorHex;
    if Length(Result) > 0 then
    begin
      if (not Dollar) and (Result[1] = '$') then
      begin
        Result[1] := ' ';
        Result := Trim(Result);
      end;
    end;
  end
  else
  begin
    Result := '000000';
    if Dollar then
      Result := '$' + Result;
  end;
end;

procedure TmstMPLineColorsDialog.ibqLineColorsLINE_COLORGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text := GetColorHex(True);
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
    if V < 140 then
      FontColor := clWhite
    else
      FontColor := clBlack;
  end;
end;

procedure TmstMPLineColorsDialog.UpdateCustomColors;
var
  Bkm: Pointer;
  ColorList: TStringList;
  ColorHex: string;
  ColorName: string;
  I: Integer;
begin
  ColorList := TStringList.Create;
  try
    Bkm := ibqLineColors.GetBookmark;
    ibqLineColors.DisableControls;
    try
      ibqLineColors.First;
      while not ibqLineColors.Eof do
      begin
        ColorHex := GetColorHex(False);
        if ColorList.IndexOfName(ColorHex) < 0 then
        begin
          ColorName := ibqLineColorsNAME.AsString;
          ColorList.Add(ColorHex + '=' + ColorName);
        end;
        ibqLineColors.Next;
      end;
    finally
      ibqLineColors.EnableControls;
      ibqLineColors.GotoBookmark(Bkm);
    end;
    //
    ColorList.Sort;
    for I := 0 to ColorList.Count - 1 do
    begin
      ColorHex := ColorList.Names[I];
      ColorName := ColorList.ValueFromIndex[I];
      ColorList.Strings[I] := 'Color' + Char(Ord('A') + I) + '=' + ColorHex;
    end;
    //
    ColorDialog1.CustomColors.Clear;
    for I := 0 to ColorList.Count - 1 do
      ColorDialog1.CustomColors.Add(ColorList[I]);
  finally
    ColorList.Free;
  end;
end;

end.
