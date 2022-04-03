unit fEditDB;

{$I EZ_FLAG.PAS}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Grids, EzBasegis, ezcmdline, IniFiles, ExtCtrls, StdCtrls, Buttons,
  EzInspect, Ezbaseexpr, EzActionLaunch;

type

  TfrmEditDB = class(TForm)
    Panel1: TPanel;
    Inspector1: TEzInspector;
    Panel2: TPanel;
    BtnApply: TSpeedButton;
    STLayer: TLabel;
    StRec: TLabel;
    Launcher1: TEzActionLauncher;
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure BtnApplyClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Launcher1Finished(Sender: TObject);
    procedure Launcher1TrackedEntityClick(Sender: TObject;
      const TrackID: String; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer; const WX, WY: Double; Layer: TEzBaseLayer;
      Recno: Integer; var Accept: Boolean);
  private
    { Private declarations }
    FCmdLine: TEzCmdLine;
    FUDFList: TList; // list of custom functions
    FUDFStrings: TStringList;
    LayerRecordCount: Integer;
    FIsDBTable: Boolean;
    FLayer: TEzBaseLayer;
    FRecno: Integer;

    procedure DGridOff;
    procedure PopulateProperties( Recno: Integer );
  public
    { Public declarations }
    function Enter(CmdLine: TEzCmdLine; Layer: TEzBaseLayer): Word;
    function SelDataSet(Layer: TEzBaseLayer; RecNo: Integer): Word;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure ChangeLayer( Layer: TEzBaseLayer );

    property Layer: TEzBaseLayer read FLayer write FLayer;
    property Recno: Integer read FRecno write FRecno;
  end;

var
  EditDBParentHWND: THandle;

implementation

{$R *.DFM}

uses
  ezlib, ezentities, ezConsts, ezSystem, ezBase, fMain, EzExpressions;

{ TfrmEditDB }

function TfrmEditDB.Enter(cmdLine: TEzCmdLine; Layer: TEzBaseLayer): Word;
var
  ColsString: TStrings;
begin
  Launcher1.CmdLine:= CmdLine;

  ColsString:= TStringList.Create;
  try
    RestoreFormPlacement(ExtractFilePath(Application.ExeName) + 'formspos.ini',
      Self, true, ColsString);
    if ColsString.Count = 2 then
    begin
      Inspector1.ColWidths[0]:= StrToInt(ColsString.Values['Col0']);
      Inspector1.ColWidths[1]:= StrToInt(ColsString.Values['Col1']);
    end;
  finally
    ColsString.free;
  end;

  Result:= 0;
  FCmdLine:= cmdLine;
  FLayer := Layer;

  { the title of the first column }
  Inspector1.TitleCaptions.clear;
  Inspector1.TitleCaptions.Add( 'FieldName' );

  ChangeLayer( FLayer );

  Launcher1.TrackEntityClick( 'EDITDB', '', true );

  Self.Show;

end;

procedure TfrmEditDB.ChangeLayer( Layer: TEzBaseLayer );
var
  i: Integer;
  Resolver: TEzMainExpr;
  FieldName: string;
  FieldType: Char;
  bp: TEzBaseProperty;
  ReadOnly: Boolean;
begin
  FLayer:= Layer;
  Inspector1.Visible:= Layer<>nil;
  if Layer=Nil then
  begin
    DGridOff;
    Inspector1.ClearPropertyList;
    Exit;
  end;

  LayerRecordCount:= FLayer.RecordCount;
  STLayer.Caption := Layer.Name;

  if FUDFList= Nil then FUDFList := TList.Create;
  if FUDFStrings= Nil then FUDFStrings := TStringList.Create;

  if FUDFList.Count > 0 then
  begin
    for i := 0 to FUDFList.Count - 1 do
      TEzMainExpr(FUDFList[i]).Free;
    FUDFList.Clear;
    FUDFStrings.Clear;
  end;

  // create the list of custom functions
  {if Layer.UDFs.Count > 0 then
  begin
    for i := 0 to Layer.UDFs.Count - 1 do
    begin
      Resolver := TEzMainExpr.Create(FCmdLine.DrawBox.Gis, Layer);
      Identifier := AnsiUpperCase(FLayer.UDFs[I].Reference);
      FUDFStrings.Add(Identifier);
      Resolver.ExprParse(Identifier);
      FUDFList.Add(Resolver);
    end;
  end; }

  Inspector1.ClearPropertyList;

  for I:= 1 to Layer.DBTable.FieldCount do
  begin
    //FieldName:= Layer.DBTable.Field(I);
    FieldName:= Layer.DBTable.FieldAlias[I];
    ReadOnly:= FieldName = 'UID';
    FieldType:= Layer.DBTable.FieldType(I);
    bp:= Nil;
    case FieldType of
      'C':
        begin
          bp:= TEzStringProperty.Create( FieldName );
        end;
      'F', 'N', 'I':
        begin
          if Layer.DBTable.FieldDec( I ) = 0 then
          begin
            bp:= TEzIntegerProperty.Create( FieldName );
          end else
          begin
            bp:= TEzFloatProperty.Create( FieldName );
            TEzFloatProperty(bp).Digits := 14;
            TEzFloatProperty(bp).Decimals:= Layer.DBTable.FieldDec( I );
          end;
        end;
      'L':
        begin
          bp:= TEzBooleanProperty.Create( FieldName );
        end;
      'D':
        begin
          bp:= TEzDateProperty.Create( FieldName );
        end;
      'T':
        begin
          bp:= TEzTimeProperty.Create( FieldName );
        end;
      'M':
        begin
          bp:= TEzMemoProperty.Create( FieldName );
        end;
      'B', 'G':
        begin
          bp:= TEzGraphicProperty.Create( FieldName );
        end;
    end;
    if bp <> nil then
    begin
      bp.ReadOnly:= Readonly;
      Inspector1.AddProperty( bp );
    end;
  end;

  // create the list of custom functions
  if FUDFList.Count > 0 then
  begin
    for i := 0 to FUDFList.Count - 1 do
    begin
      Resolver := TEzMainExpr(FUDFList[i]);
      bp:= Nil;
      case Resolver.Expression.ExprType of
        ttString:
          begin
            bp:= TEzStringProperty.Create( FUDFStrings[I] );
          end;
        ttFloat:
          begin
            bp:= TEzFloatProperty.Create( FUDFStrings[I] );
          end;
        ttInteger:
          begin
            bp:= TEzIntegerProperty.Create( FUDFStrings[I] );
          end;
        ttBoolean:
          begin
            bp:= TEzBooleanProperty.Create( FUDFStrings[I] );
          end;
      end;
      bp.ReadOnly:= True;
      Inspector1.AddProperty( bp );
    end;
  end;

  Inspector1.Visible:= true;

end;

procedure TfrmEditDB.PopulateProperties( Recno: Integer );
var
  i: Integer;
  FieldName: string;
  FieldType: Char;
  bp: TEzBaseProperty;
  Resolver: TEzMainExpr;
begin
  if FLayer=nil then Exit;

  Inspector1.Visible:= true;

  if FLayer.Recno<>Recno then
    FLayer.Recno:= Recno;
  FLayer.Synchronize;

  StRec.Caption := #32+inttostr(Flayer.RecNo)+'/'+
    inttostr(LayerRecordCount)+#32;

  if FLayer.RecIsDeleted then
  begin
     StRec.Font.Color := clRed;
     Exit;
  end else
     StRec.Font.Color := clBlack;

  for I:= 1 to FLayer.DBTable.FieldCount do
  begin
    FieldName:= FLayer.DBTable.Field(I);
    FieldType:= FLayer.DBTable.FieldType(I);
    bp:= nil;
    case FieldType of
      'C':
        begin
          bp:= Inspector1.GetPropertyByName( FieldName );
          bp.ValString:= TrimRight(FLayer.DBTable.FieldGetN(I));
        end;
      'F', 'N', 'I':
        begin
          if FLayer.DBTable.FieldDec( I ) = 0 then
          begin
            bp:= Inspector1.GetPropertyByName( FieldName );
            bp.ValInteger:= FLayer.DBTable.IntegerGetN(I);
          end else
          begin
            bp:= Inspector1.GetPropertyByName( FieldName );
            bp.ValFloat:= FLayer.DBTable.FloatGetN(I);
          end;
        end;
      'L':
        begin
          bp:= Inspector1.GetPropertyByName( FieldName );
          bp.ValBoolean:= FLayer.DBTable.LogicGetN(I);
        end;
      'D':
        begin
          bp:= Inspector1.GetPropertyByName( FieldName );
          bp.ValDateTime:= FLayer.DBTable.DateGetN(I);
        end;
      'T':
        begin
          bp:= Inspector1.GetPropertyByName( FieldName );
          bp.ValDateTime:= FLayer.DBTable.DateGetN(I);
        end;
      'M':
        begin
          bp:= Inspector1.GetPropertyByName( FieldName );
          TEzMemoProperty(bp).DBTable:= FLayer.DBTable;
          TEzMemoProperty(bp).FieldNo:= I;
        end;
      'B', 'G':
        begin
          bp:= Inspector1.GetPropertyByName( FieldName );
          TEzGraphicProperty(bp).DBTable:= FLayer.DBTable;
          TEzGraphicProperty(bp).FieldNo:= I;
        end;
    end;
    if bp<> nil then bp.Modified:= False;
  end;

  if FUDFList.Count > 0 then
  begin
    for i := 0 to FUDFList.Count - 1 do
    begin
      bp:= Inspector1.GetPropertyByName( FUDFStrings[I] );
      Resolver := TEzMainExpr(FUDFList[i]);
      case Resolver.Expression.ExprType of
        ttString:
          begin
            bp.ValString:= TrimRight(Resolver.Expression.AsString);
          end;
        ttFloat:
          begin
            bp.ValFloat:= Resolver.Expression.AsFloat;
          end;
        ttInteger:
          begin
            bp.ValInteger:= Resolver.Expression.AsInteger;
          end;
        ttBoolean:
          begin
            bp.ValBoolean:= Resolver.Expression.AsBoolean;
          end;
      end;
      if bp<> nil then bp.Modified:= False;
    end;
  end;
  Inspector1.Invalidate;
end;

procedure TfrmEditDB.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams( Params );
  with Params do
  begin
    Style := Style or WS_OVERLAPPED;
    WndParent := EditDBParentHWND;
  end;
end;

procedure TfrmEditDB.FormShow(Sender: TObject);
begin
  if FLayer=nil then
  begin
    Inspector1.Visible := False;
    DGridOff;
  end;
end;

procedure TfrmEditDB.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then Self.Close;
end;

function TfrmEditDB.SelDataSet(Layer: TEzBaseLayer; RecNo: Integer): Word;
var
  IsOther: Boolean;
begin
  result:=0;
  if (Flayer=Nil) and (Layer<>nil) then Enter(FCmdLine, Layer);
  IsOther:= FLayer<>Layer;

  FLayer := Layer;
  if FLayer=nil then
  begin
    DGridOff;
    exit;
  end;
  FRecno:= Recno;
  Flayer.Recno := FRecNo;
  FIsDBTable:= FALSE;

  if IsOther then
  begin
    ChangeLayer( FLayer );
  end;

  if FLayer.DBTable<>nil then
  begin
    Inspector1.TurnOffEditor;
    FIsDBTable:= TRUE;
    PopulateProperties( Recno );
  end;

end;

procedure TfrmEditDB.DGridOff;
begin
  Inspector1.Visible:= false;
  STLayer.Caption:= '';
  StRec.Caption:= ' 0/0 ';
end;

procedure TfrmEditDB.BtnApplyClick(Sender: TObject);
var
  bp: TEzBaseProperty;
  I: Integer;
  FieldName: string;
  Fieldtype:char;
begin
  IF FLayer = Nil then Exit;
  FLayer.DBTable.Recno:= FRecno;
  FLayer.Synchronize;
  FLayer.DBTable.Edit;
  for I:= 1 to FLayer.DBTable.FieldCount do
  begin
    if FLayer.DBTable.FieldType(I) in ['B','G'] then
    begin
    end else
    begin
      FieldName:= Layer.DBTable.FieldAlias[I];
      bp:= Inspector1.GetPropertyByName( FieldName );
      if (bp= Nil) or bp.ReadOnly or Not bp.Modified then Continue;
      FieldType:= Layer.DBTable.FieldType(I);
      case FieldType of
        'C':
          begin
            FLayer.DBTable.StringPutN(I, bp.ValString);
          end;
        'F', 'N', 'I':
          begin
            if Layer.DBTable.FieldDec( I ) = 0 then
            begin
              FLayer.DBTable.IntegerPutN(I, bp.ValInteger);
            end else
            begin
              FLayer.DBTable.FloatPutN(I, bp.ValFloat);
            end;
          end;
        'L':
          begin
            FLayer.DBTable.LogicPutN(I, bp.ValBoolean);
          end;
        'D', 'T':
          begin
            FLayer.DBTable.DatePutN(I, bp.ValDateTime);
          end;
        'M', 'B', 'G':
          begin
            // memos/binaries are saved immediately when edited
            {cb:= Length(bp.ValString);
            FLayer.DBTable.MemoSaveN( I, PChar(bp.ValString), cb );}
          end;
      end;
      bp.Modified:= false;
    end;
  end;
  FLayer.DBTable.Post;
  Inspector1.SetModifiedStatus(false);
  Inspector1.Invalidate;
end;

procedure TfrmEditDB.FormClose(Sender: TObject; var Action: TCloseAction);
var
  I: Integer;
  ColsString: TStringList;
begin
  ColsString:= TStringList.Create;
  try
    for I:= 0 to Inspector1.ColCount-1 do
      ColsString.Add(Format('Col%d=%d', [I,Inspector1.ColWidths[I]] ));
    SaveFormPlacement( ExtractFilePath(Application.ExeName) + 'formspos.ini', Self, ColsString );
  finally
    ColsString.Free;
  end;

  { dispose the last action "EDITDB" }
  if FCmdLine.CurrentActionID = 'EDITDB' then
    FCmdLine.Pop;

  Action:= caFree;
end;

procedure TfrmEditDB.FormDestroy(Sender: TObject);
var
  I:Integer;
begin
  if FUDFList <> Nil then
  begin
    for i := 0 to FUDFList.Count - 1 do
      TEzMainExpr(FUDFList[i]).Free;
    FreeAndNil(FUDFList);
    FreeAndNil(FUDFStrings);
  end;
end;

procedure TfrmEditDB.FormResize(Sender: TObject);
begin
  Inspector1.AdjustColWidths;
end;

procedure TfrmEditDB.Launcher1Finished(Sender: TObject);
begin
  Release;  { do not use Close. Close causes access violation error }
end;

procedure TfrmEditDB.Launcher1TrackedEntityClick(Sender: TObject;
  const TrackID: String; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer; const WX, WY: Double; Layer: TEzBaseLayer; Recno: Integer;
  var Accept: Boolean);
begin
  if Layer <> FLayer then
  begin
    FLayer:= Layer;
    ChangeLayer(FLayer);
  end;
  FRecno:= Recno;
  SelDataSet(FLayer, FRecNo);
end;

end.

