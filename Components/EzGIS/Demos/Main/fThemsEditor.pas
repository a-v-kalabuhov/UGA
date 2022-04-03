unit fThemsEditor;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, Dialogs,
  Buttons, ExtCtrls, Grids, EzInspect, ezbasegis, ezthematics;

type
  TfrmThematicsEditor = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    CancelBtn: TButton;
    BtnOpen: TSpeedButton;
    BtnSave: TSpeedButton;
    Inspector1: TEzInspector;
    BtnEasy: TSpeedButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Button1: TButton;
    BtnRecalc: TSpeedButton;
    procedure Inspector1PropertyChange(Sender: TObject;
      const PropertyName: String);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOpenClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnEasyClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BtnRecalcClick(Sender: TObject);
  private
    { Private declarations }
    FDrawBox: TEzBaseDrawBox;
    FThematicBuilder: TEzThematicBuilder;
    FFileName: string;
  public
    { Public declarations }
    function Enter( DrawBox: TEzBaseDrawBox; ThematicBuilder: TEzThematicBuilder ): WOrd;
  end;

implementation

{$R *.DFM}

uses
  EzLib, EzConsts, fEasyThematic, fRangesEditor, EzSystem;

type

  { for editing the columns in a table }
  TEzThematicRangesProperty = class(TEzBaseProperty)
  private
    FBuilder: TEzThematicBuilder;
    FDrawBox: TEzBaseDrawBox;
  public
    constructor Create( const PropName: string ); Override;
    Procedure Edit(Inspector: TEzInspector); Override;
    function AsString: string; Override;

    property Builder: TEzThematicBuilder read FBuilder write FBuilder;
    property DrawBox: TEzBaseDrawBox read FDrawBox write FDrawBox;
  end;

{ TEzThematicRangesProperty }

constructor TEzThematicRangesProperty.Create(const PropName: string);
begin
  inherited create(PropName);
  PropType:= ptString;
  UseEditButton:= true;
end;

function TEzThematicRangesProperty.AsString: string;
begin
  Result:= '(Ranges)';
end;

procedure TEzThematicRangesProperty.Edit(Inspector: TEzInspector);
begin
  if ReadOnly then exit;
  with TfrmRangesEditor.create(Application) do
    try
      if Enter(Self.Builder, Self.FDrawBox)= mrOk then
      begin
        Modified:= true;
        if Assigned(OnChange) then OnChange(Self);
      end;
    finally
      free;
    end;
end;


{ TfrmThematicsEditor }

function TfrmThematicsEditor.Enter( DrawBox: TEzBaseDrawBox; ThematicBuilder: TEzThematicBuilder ): WOrd ;
var
  I: Integer;
  bp: TEzBaseProperty;
  ColsStrings: TStringList;
begin
  FDrawBox := DrawBox ;

  ColsStrings:= TStringList.Create;
  try
    RestoreFormPlacement(ExtractFilePath(Application.ExeName) + 'formspos.ini',
      Self, true, ColsStrings);
    //if ColsStrings.Count = 2 then
    //begin
      //Inspector1.ColWidths[0]:= ezlib.IMax(10, StrToInt(ColsStrings.Values['Col0']) )-4;
      //Inspector1.ColWidths[1]:= ezlib.IMax(10, StrToInt(ColsStrings.Values['Col1']) )-4;
      //If Inspector1.ColWidths[0] + Inspector1.ColWidths[1] > Self.ClientWidth Then
      //  ClientWidth:= Inspector1.ColWidths[0] + Inspector1.ColWidths[1] + 10;
      Inspector1.AdjustColWidths;
    //end;
  finally
    ColsStrings.free;
  end;

  FThematicBuilder:= ThematicBuilder;

  if FDrawBox.Gis <> Nil then
  begin

    { now the properties of the TThematicBuilder component }
    bp:= TEzThematicRangesProperty.Create('Ranges');
    TEzThematicRangesProperty(bp).Builder:= Self.FThematicBuilder;
    TEzThematicRangesProperty(bp).DrawBox:= Self.FDrawBox;
    bp.Hint:= 'Edit the thematic ranges';
    Inspector1.AddProperty( bp );

    bp:= TEzEnumerationProperty.Create('LayerName');
    with TEzEnumerationProperty(bp).Strings do
    begin
      for I:= 0 to FDrawBox.Gis.Layers.Count-1 do
        Add(FDrawBox.Gis.Layers[I].Name);
      if (ThematicBuilder.LayerName='') and (FDrawBox.Gis.Layers.Count>0) then
        ThematicBuilder.LayerName:= FDrawBox.Gis.Layers[0].Name;
      bp.ValString:= ThematicBuilder.LayerName;
    end;
    bp.Hint:= 'Define layer name';
    Inspector1.AddProperty( bp );

    bp:= TEzBooleanProperty.Create('ShowThematic');
    bp.ValBoolean:= FThematicBuilder.ShowThematic;
    bp.Hint:= 'Define if thematic is active';
    Inspector1.AddProperty( bp );

    bp:= TEzStringProperty.Create('Title');
    bp.ValString:= FThematicBuilder.Title;
    bp.Hint:= 'Define the title of the thematic';
    Inspector1.AddProperty( bp );

    bp:= TEzBooleanProperty.Create('ApplyPen');
    bp.ValBoolean:= FThematicBuilder.ApplyPen;
    bp.Hint:= 'Define if pen config is used on the layer';
    Inspector1.AddProperty( bp );

    bp:= TEzBooleanProperty.Create('ApplyBrush');
    bp.ValBoolean:= FThematicBuilder.ApplyBrush;
    bp.Hint:= 'Define if brush config is used on the layer';
    Inspector1.AddProperty( bp );

    bp:= TEzBooleanProperty.Create('ApplyColor');
    bp.ValBoolean:= FThematicBuilder.ApplyColor;
    bp.Hint:= 'Define if color config is used on the layer';
    Inspector1.AddProperty( bp );

    bp:= TEzBooleanProperty.Create('ApplySymbol');
    bp.ValBoolean:= FThematicBuilder.ApplySymbol;
    bp.Hint:= 'Define if symbol config is used on the layer';
    Inspector1.AddProperty( bp );

    bp:= TEzBooleanProperty.Create('ApplyFont');
    bp.ValBoolean:= FThematicBuilder.ApplyFont;
    bp.Hint:= 'Define if font config is used on the layer';
    Inspector1.AddProperty( bp );
  end;

  Result:= ShowModal;
end;

procedure TfrmThematicsEditor.Inspector1PropertyChange(Sender: TObject;
  const PropertyName: String);
var
  bp: TEzBaseProperty;
begin
  bp:= Inspector1.GetPropertyByName(PropertyName);
  if AnsiCompareText(PropertyName, 'ShowThematic') = 0 then
    FThematicBuilder.ShowThematic:= bp.ValBoolean
  else if AnsiCompareText(PropertyName, 'LayerName') = 0 then
  begin
    if (bp.ValInteger >= 0) and (FDrawBox.Gis.Layers.Count > 0) then
      FThematicBuilder.LayerName:= FDrawBox.Gis.Layers[bp.ValInteger].Name
  end else if AnsiCompareText(PropertyName, 'Title') = 0 then
    FThematicBuilder.Title:= bp.ValString
  else if AnsiCompareText(PropertyName, 'ApplyPen') = 0 then
    FThematicBuilder.ApplyPen:= bp.ValBoolean
  else if AnsiCompareText(PropertyName, 'ApplyBrush') = 0 then
    FThematicBuilder.ApplyBrush:= bp.ValBoolean
  else if AnsiCompareText(PropertyName, 'ApplyColor') = 0 then
    FThematicBuilder.ApplyColor:= bp.ValBoolean
  else if AnsiCompareText(PropertyName, 'ApplySymbol') = 0 then
    FThematicBuilder.ApplySymbol:= bp.ValBoolean
  else if AnsiCompareText(PropertyName, 'ApplyFont') = 0 then
    FThematicBuilder.ApplyFont:= bp.ValBoolean;
end;

procedure TfrmThematicsEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  ColsString: TStrings;
  I: Integer;
begin
  ColsString:= TStringList.Create;
  try
    for I:= 0 to Inspector1.ColCount-1 do
      ColsString.Add(Format('Col%d=%d', [I,Inspector1.ColWidths[I]] ));
    SaveFormPlacement( ExtractFilePath(Application.ExeName) + 'formspos.ini',
      Self, ColsString );
  finally
    ColsString.Free;
  end;
end;

procedure TfrmThematicsEditor.BtnOpenClick(Sender: TObject);
begin
  if not OpenDialog1.Execute then exit;
  FFileName:= OpenDialog1.FileName;
  FThematicBuilder.LoadFromFile( FFileName );
end;

procedure TfrmThematicsEditor.BtnSaveClick(Sender: TObject);
begin
  SaveDialog1.FileName:= FFileName;
  if not SaveDialog1.Execute then exit;
  FFileName:= SaveDialog1.FileName;
  FThematicBuilder.SaveToFile( FFileName );
end;

procedure TfrmThematicsEditor.BtnEasyClick(Sender: TObject);
begin
  if (FDrawBox.Gis = Nil) or (Length(FThematicBuilder.LayerName) = 0) then Exit;
  with TfrmEasyThematic.Create(Nil) do
    try
      Enter( Self.FDrawBox, Self.FThematicBuilder );
    finally
      free;
    end;
end;

procedure TfrmThematicsEditor.Button1Click(Sender: TObject);
begin
  FDrawBox.Gis.RepaintViewports;
  ModalResult:= mrOk;
end;

procedure TfrmThematicsEditor.BtnRecalcClick(Sender: TObject);
begin
  FThematicBuilder.Recalculate(FDrawBox.GIS);
end;

end.
