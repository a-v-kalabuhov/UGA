unit uMStModuleMPColorSettings;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBUpdateSQL, IBQuery, IBDatabase, Dialogs;

type
  TStatusEntry = record
    StatusId: Integer;
    StatusName: string;
    HasBackColor: Boolean;
    BackColor: Integer;
  end;

  TmstMPColorSettingsModule = class(TDataModule)
    ibtLineColors: TIBTransaction;
    ibqLineColors: TIBQuery;
    ibqLineColorsID: TIntegerField;
    ibqLineColorsNAME: TIBStringField;
    ibqLineColorsIS_GROUP: TSmallintField;
    ibqLineColorsGROUP_ID: TIntegerField;
    ibqLineColorsLINE_COLOR: TIBStringField;
    updLineColors: TIBUpdateSQL;
    dsLineColors: TDataSource;
    ibqLineEdging: TIBQuery;
    updLineEdging: TIBUpdateSQL;
    dsLineEdging: TDataSource;
    ibqLineEdgingID: TIntegerField;
    ibqLineEdgingNAME: TIBStringField;
    ibqLineEdgingHAS_BACKCOLOR: TSmallintField;
    ibqLineEdgingBACKCOLOR: TIntegerField;
    ColorDialog1: TColorDialog;
    procedure ibqLineColorsLINE_COLORGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure ibqLineEdgingBACKCOLORGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  private
    function GetColorHex(const aText: string; const Dollar: Boolean): string;
    procedure UpdateCustomColors;
    class function GetStatus(Idx: Integer): TStatusEntry; static;
    class procedure SetStatus(Idx: Integer; const Value: TStatusEntry); static;
  public
    procedure OpenSettings;
    procedure CloseSettings(const SaveChanges: Boolean);
    function LinesDataSource: TDataSource;
    function EdgingDataSource: TDataSource;
    procedure EditEdging;
    procedure EditLine;
    procedure SwitchCurrentStatusEdging;
    procedure UpdateWidthsettings;
  private
    class var FStatuses: array[0..47] of TStatusEntry;
    class var FCount: Integer;
    class var FEdgingWidth: Integer;
    class var FLinePenWidth: Integer;
    class function GetEdgingWidth: Integer; static;
    class function GetLinePenWidth: Integer; static;
    class procedure SetEdgingWidth(const Value: Integer); static;
    class procedure SetLinePenWidth(const Value: Integer); static;
  public
    class property Status[Idx: Integer]: TStatusEntry read GetStatus write SetStatus;
    class property Count: Integer read FCount;
    class procedure Init();
    //
    class property EdgingWidth: Integer read GetEdgingWidth write SetEdgingWidth;
    class property LinePenWidth: Integer read GetLinePenWidth write SetLinePenWidth;
  end;

implementation

{$R *.dfm}

uses
  uMstModuleApp;

{ TMStSettingsModule }

procedure TmstMPColorSettingsModule.CloseSettings(const SaveChanges: Boolean);
begin
  if not ibtLineColors.Active then
    Exit;
  if SaveChanges then
  begin
    UpdateWidthsettings;
    ibtLineColors.Commit;
    Init();
  end
  else
    ibtLineColors.Rollback;
end;

function TmstMPColorSettingsModule.EdgingDataSource: TDataSource;
begin
  Result := dsLineEdging;
end;

procedure TmstMPColorSettingsModule.EditEdging;
var
  ClrInt: Integer;
begin
  UpdateCustomColors;
  //
  ibqLineEdging.Edit;
  ClrInt := ibqLineEdgingBACKCOLOR.Value;
  ColorDialog1.Color := ClrInt;
  if ColorDialog1.Execute() then
  begin
    ClrInt := ColorDialog1.Color;
    ibqLineEdgingBACKCOLOR.Value := ClrInt;
    ibqLineEdging.Post;
  end
  else
    ibqLineColors.Cancel;
end;

procedure TmstMPColorSettingsModule.EditLine;
var
  ClrHex: string;
  ClrInt: Integer;
begin
  UpdateCustomColors;
  //
  ibqLineColors.Edit;
  ClrHex := GetColorHex(ibqLineColorsLINE_COLOR.Value, True);
  ClrInt := StrToInt(ClrHex);
  ColorDialog1.Color := ClrInt;
  if ColorDialog1.Execute() then
  begin
    ClrInt := ColorDialog1.Color;
    ClrHex := '$' + IntToHex(ClrInt, 6);
    ibqLineColorsLINE_COLOR.Value := ClrHex;
    ibqLineColors.Post;
  end
  else
    ibqLineColors.Cancel;
end;

function TmstMPColorSettingsModule.GetColorHex(const aText: string; const Dollar: Boolean): string;
var
  ColorHex: string;
  ColorInt: Integer;
begin
  ColorHex := aText;
  if TryStrToInt(ColorHex, ColorInt) then
  begin
    Result := ColorHex;
    if Length(Result) > 0 then
    begin
      if Dollar then
        if Result[1] <> '$' then
          Result := '$' + Result;
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

class function TmstMPColorSettingsModule.GetEdgingWidth: Integer;
begin
  Result := FEdgingWidth;
end;

class function TmstMPColorSettingsModule.GetLinePenWidth: Integer;
begin
  Result := FLinePenWidth;
end;

class function TmstMPColorSettingsModule.GetStatus(Idx: Integer): TStatusEntry;
begin
  Result := FStatuses[Idx];
end;

procedure TmstMPColorSettingsModule.ibqLineColorsLINE_COLORGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text := GetColorHex(Sender.AsString, True);
end;

procedure TmstMPColorSettingsModule.ibqLineEdgingBACKCOLORGetText(Sender: TField; var Text: string; DisplayText: Boolean);
var
  I: Integer;
  S: string;
begin
  I := Sender.AsInteger;
  S := '$' + IntToHex(I, 6);
  Text := GetColorHex(S, True);
end;

class procedure TmstMPColorSettingsModule.Init;
var
  Module: TmstMPColorSettingsModule;
  Entry: TStatusEntry;
begin
  FCount := 0;
  Module := TmstMPColorSettingsModule.Create(nil);
  try
    Module.OpenSettings;
    while not Module.ibqLineEdging.Eof do
    begin
      Entry.StatusId := Module.ibqLineEdgingID.AsInteger;
      Entry.StatusName := Module.ibqLineEdgingNAME.AsString;
      Entry.HasBackColor := Module.ibqLineEdgingHAS_BACKCOLOR.AsInteger = 1;
      Entry.BackColor := Module.ibqLineEdgingBACKCOLOR.AsInteger;
      FStatuses[FCount] := Entry;
      Module.ibqLineEdging.Next;
      Inc(FCount);
    end;
    Module.CloseSettings(False);
  finally
    Module.Free;
  end;
end;

function TmstMPColorSettingsModule.LinesDataSource: TDataSource;
begin
  Result := dsLineColors; 
end;

procedure TmstMPColorSettingsModule.OpenSettings;
begin
  if ibtLineColors.Active then
    Exit;
  ibtLineColors.StartTransaction;
  //
  ibqLineColors.Open;
  ibqLineEdging.Open;
end;

class procedure TmstMPColorSettingsModule.SetEdgingWidth(const Value: Integer);
begin
  FEdgingWidth := Value;
end;

class procedure TmstMPColorSettingsModule.SetLinePenWidth(const Value: Integer);
begin
  FLinePenWidth := Value;
end;

class procedure TmstMPColorSettingsModule.SetStatus(Idx: Integer; const Value: TStatusEntry);
begin
  FStatuses[Idx] := Value;
end;

procedure TmstMPColorSettingsModule.SwitchCurrentStatusEdging;
begin
  ibqLineEdging.Edit;
  try
    if ibqLineEdgingHAS_BACKCOLOR.Value = 1 then
      ibqLineEdgingHAS_BACKCOLOR.Value := 0
    else
      ibqLineEdgingHAS_BACKCOLOR.Value := 1;
  finally
    ibqLineEdging.Post;
  end;
end;

procedure TmstMPColorSettingsModule.UpdateCustomColors;
var
  Bkm: Pointer;
  ColorList: TStringList;
  ColorHex: string;
  ColorName: string;
  I: Integer;
  Cint: Integer;
begin
  ColorList := TStringList.Create;
  try
    Bkm := ibqLineColors.GetBookmark;
    ibqLineColors.DisableControls;
    try
      ibqLineColors.First;
      while not ibqLineColors.Eof do
      begin
        ColorHex := GetColorHex(ibqLineColorsLINE_COLOR.Value, False);
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
    Bkm := ibqLineEdging.GetBookmark;
    ibqLineEdging.DisableControls;
    try
      ibqLineEdging.First;
      while not ibqLineEdging.Eof do
      begin
        Cint := ibqLineEdgingBACKCOLOR.Value;
        ColorHex := GetColorHex(IntToHex(Cint, 6), False);
        if ColorList.IndexOfName(ColorHex) < 0 then
        begin
          ColorName := ibqLineEdgingNAME.AsString;
          ColorList.Add(ColorHex + '=' + ColorName);
        end;
        ibqLineEdging.Next;
      end;
    finally
      ibqLineEdging.EnableControls;
      ibqLineEdging.GotoBookmark(Bkm);
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

procedure TmstMPColorSettingsModule.UpdateWidthsettings;
begin
  mstClientAppModule.MapMngr.SaveSettingValue('MP_LINE_WIDTH', IntToStr(TmstMPColorSettingsModule.LinePenWidth));
  mstClientAppModule.MapMngr.SaveSettingValue('MP_EDGING_WIDTH', IntToStr(TmstMPColorSettingsModule.EdgingWidth));
end;

end.
