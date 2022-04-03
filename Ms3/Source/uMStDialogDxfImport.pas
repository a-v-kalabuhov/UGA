unit uMStDialogDxfImport;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, Dialogs,
  Messages, Buttons, ExtCtrls, EzBaseGIS, EzBasicCtrls, Grids, ImgList, DB,
  EzDxfImport, EzCmdLine,
  uGC,
  uMStConsts,
  uMStKernelIBX,
  uMStClassesProjects,
  uMStModuleApp,
  uMStDialogMissingLayers;

type
  TMStDxfImportDialog = class(TForm)
    DrawBox1: TEzDrawBox;
    Panel1: TPanel;
    OKBtn: TButton;
    CancelBtn: TButton;
    CmdLine1: TEzCmdLine;
    ZoomWBtn: TSpeedButton;
    ZoomIn: TSpeedButton;
    ZoomOut: TSpeedButton;
    BtnHand: TSpeedButton;
    grdLayers: TStringGrid;
    Splitter1: TSplitter;
    Label1: TLabel;
    ZoomAll: TSpeedButton;
    ImageList1: TImageList;
    SpeedButton1: TSpeedButton;
    Button1: TButton;
    chbCK36: TCheckBox;
    procedure BtnHandClick(Sender: TObject);
    procedure ZoomWBtnClick(Sender: TObject);
    procedure ZoomInClick(Sender: TObject);
    procedure ZoomOutClick(Sender: TObject);
    procedure grdLayersSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure grdLayersDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure grdLayersMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OKBtnClick(Sender: TObject);
    procedure ZoomAllClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ZoomLayerClick(Sender: TObject);
    procedure grdLayersDblClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FDxfImport: TEzDxfImport;
    FVisible: TBitmap;
    FInVisible: TBitmap;
    FOldWidth, FOldHeight: Integer;
    procedure WMEnterSizeMove(var m: TMessage); message WM_ENTERSIZEMOVE;
    procedure WMExitSizeMove(var m: TMessage); message WM_EXITSIZEMOVE;
    procedure VisibleChange(Sender: TObject; const Filename: string);
    procedure CheckLayers(Missing: TStringList; out ReqLayerCount, ObjCount: Integer);
    procedure DisplayMissingLayers(Missing: TStringList; const ObjCount: Integer); overload;
    procedure DisplayMissingLayers(Missing: TStringList; const ObjCount: Integer; out DoImport: Boolean); overload;
  public
    function Execute(Gis: TEzBaseGis; DxfImport: TEzDxfImport): Integer;
  end;

implementation

{$R *.dfm}

{ TMStDxfImportDialog }

procedure TMStDxfImportDialog.Button1Click(Sender: TObject);
var
  Missing: TStringList;
  ObjCount: Integer;
  ReqLayerCount: Integer;
begin
  Missing := TStringList.Create;
  Missing.Forget();
  //
  CheckLayers(Missing, ReqLayerCount, ObjCount);
  //
  if Missing.Count = ReqLayerCount then
  begin
    ShowMessage('В файле нет ни одного обязательного слоя!');
    Exit;
  end;
  //
  if ObjCount = 0 then
  begin
    ShowMessage('В обязательных слоях нет объектов!');
    Exit;
  end;
  //
  if Missing.Count > 0 then
  begin
    DisplayMissingLayers(Missing, ObjCount);
  end;
  //
  OKBtn.Enabled := True;
end;

procedure TMStDxfImportDialog.CheckLayers(Missing: TStringList; out ReqLayerCount, ObjCount: Integer);
var
  aDb: IDb;
  Layer: TEzBaseLayer;
  Loader: TmstProjectLayerListLoader;
  AllLayers: TmstProjectLayers;
  I: Integer;
begin
  ReqLayerCount := 0;
  ObjCount := 0;
  aDb := mstClientAppModule.MapMngr as IDb;
  AllLayers := TmstProjectLayers.Create;
  AllLayers.Forget;
  Loader := TmstProjectLayerListLoader.Create;
  Loader.Forget;
  Loader.Load(aDb, AllLayers);

  for I := 0 to AllLayers.Count - 1 do
  begin
    if AllLayers[I].Required then
    begin
      Inc(ReqLayerCount);
      Layer := DrawBox1.GIS.Layers.LayerByName(AllLayers[I].Name);
      if Layer = nil then
        Missing.Add(AllLayers[I].Name)
      else
        ObjCount := ObjCount + Layer.RecordCount;
    end;
  end;
end;

procedure TMStDxfImportDialog.DisplayMissingLayers(Missing: TStringList; const ObjCount: Integer);
var
  Frm: TMStMissingLayersDialog;
begin
  Frm := TMStMissingLayersDialog.Create(Self);
  try
    Frm.Layers := Missing;
    Frm.ObjectsCount := ObjCount;
    Frm.CanContinue := False;
    Frm.ShowModal;
  finally
    Frm.Free;
  end;
end;

procedure TMStDxfImportDialog.DisplayMissingLayers(Missing: TStringList; const ObjCount: Integer; out DoImport: Boolean);
var
  Frm: TMStMissingLayersDialog;
begin
  Frm := TMStMissingLayersDialog.Create(Self);
  try
    Frm.Layers := Missing;
    Frm.ObjectsCount := ObjCount;
    Frm.CanContinue := True;
    DoImport := Frm.ShowModal = mrOK;
  finally
    Frm.Free;
  end;
end;

function TMStDxfImportDialog.Execute(Gis: TEzBaseGis; DxfImport: TEzDxfImport): Integer;
var
  I: Integer;
begin
  FDxfImport := DxfImport;

  if GIS = nil then
    DrawBox1.GIS := DxfImport.Cad
  else
    ;
  DrawBox1.BeginUpdate;

  DxfImport.Cad.OnVisibleLayerChange := VisibleChange;

  grdLayers.RowCount:= DxfImport.Cad.Layers.Count + 1;

  grdLayers.Cells[ 0, 0 ] := 'Название';
  grdLayers.Cells[ 1, 0 ] := 'Вид.';
  grdLayers.Cells[ 2, 0 ] := 'Кол-во';
  for I := 0 to DxfImport.Cad.Layers.Count - 1 do
  begin
    grdLayers.Cells[ 0, I + 1 ] := DxfImport.Cad.Layers[I].Name;
    grdLayers.Cells[ 2, I + 1 ] := IntToStr(DxfImport.Cad.Layers[I].RecordCount);
  end;

//  FVisible := TBitmap.Create;
//  ImageList1.GetBitmap(0, FVisible);
//  FVisible.Transparent := True;
//  FVisible.TransparentMode := tmAuto;

  FVisible := TBitmap.Create;
  FVisible.Handle := LoadBitmap(HInstance, 'VISIBLE');
  FVisible.Transparent := True;
  FVisible.TransparentMode := tmAuto;

  FInVisible := TBitmap.Create;
  FInVisible.Handle := LoadBitmap(HInstance, 'INVISIBLE');
  FInVisible.Transparent := True;
  FInVisible.TransparentMode := tmAuto;

  Result := ShowModal;
end;

procedure TMStDxfImportDialog.VisibleChange(Sender: TObject; const Filename: string);
begin
  DrawBox1.Repaint;
end;

procedure TMStDxfImportDialog.BtnHandClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('SCROLL','');
end;

procedure TMStDxfImportDialog.ZoomWBtnClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ZOOMWIN','');
end;

procedure TMStDxfImportDialog.ZoomInClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ZOOMIN','');
end;

procedure TMStDxfImportDialog.ZoomLayerClick(Sender: TObject);
var
  S: string;
begin
  S := grdLayers.Cells[0, grdLayers.Row];
  DrawBox1.ZoomToLayerRef(S);
end;

procedure TMStDxfImportDialog.ZoomOutClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ZOOMOUT','');
end;

procedure TMStDxfImportDialog.grdLayersSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  grdLayers.Options := grdLayers.Options - [goEditing];
end;

procedure TMStDxfImportDialog.grdLayersDblClick(Sender: TObject);
var
  aCol, aRow: Integer;
  S: string;
begin
  with grdLayers.ScreenToClient(Mouse.CursorPos) do
    grdLayers.MouseToCell(X, Y, aCol, aRow);
  if aRow > 0 then
  begin
    S := grdLayers.Cells[0, grdLayers.Row];
    DrawBox1.ZoomToLayerRef(S);
  end;
end;

procedure TMStDxfImportDialog.grdLayersDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  X,Y: Integer;
  Layer: TEzBaseLayer;
begin
  If ( ACol = 1 ) And ( ARow > 0 ) then
  begin
    X:= Rect.Left + ((Rect.Right - Rect.Left ) - FVisible.Width ) div 2;
    Y:= Rect.Top  + ((Rect.Bottom - Rect.Top ) - FVisible.Height ) div 2;
    Layer:= FDxfImport.Cad.Layers[ARow - 1];
    if Layer.LayerInfo.Visible then
      grdLayers.Canvas.Draw(X,Y,FVisible)
    else
      grdLayers.Canvas.Draw(X,Y,FInVisible)
  end;
end;

procedure TMStDxfImportDialog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FVisible.free;
  FInvisible.free;
end;

procedure TMStDxfImportDialog.grdLayersMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Layer : TEzBaseLayer;
  ACol, ARow: Integer;
  Coord: TGridCoord;
begin
  Coord:= grdLayers.MouseCoord( X, Y );
  ACol := Coord.X;
  ARow := Coord.Y;
  if (ACol=1) And (ARow>0) then
  begin
    Layer := FDxfImport.Cad.Layers[ARow - 1];
    Layer.LayerInfo.Visible := Not Layer.LayerInfo.Visible;
    grdLayers.Invalidate;
  end;
end;

procedure TMStDxfImportDialog.OKBtnClick(Sender: TObject);
var
  Missing: TStringList;
  ObjCount: Integer;
  ReqLayerCount: Integer;
  DoImport: Boolean;
begin
  Missing := TStringList.Create;
  Missing.Forget();
  //
  CheckLayers(Missing, ReqLayerCount, ObjCount);
  //
  if Missing.Count = ReqLayerCount then
  begin
    ShowMessage('В файле нет ни одного обязательного слоя!');
    Exit;
  end;
  //
  if ObjCount = 0 then
  begin
    ShowMessage('В обязательных слоях нет объектов!');
    Exit;
  end;
  //
  if Missing.Count > 0 then
  begin
    DisplayMissingLayers(Missing, ObjCount, DoImport);
  end
  else
    DoImport := True;
  if DoImport then
    ModalResult := mrOk;
end;

procedure TMStDxfImportDialog.SpeedButton1Click(Sender: TObject);
begin
  CmdLine1.Clear;
end;

procedure TMStDxfImportDialog.ZoomAllClick(Sender: TObject);
begin
  DrawBox1.ZoomToExtension;
end;

procedure TMStDxfImportDialog.WMEnterSizeMove(var m: TMessage);
begin
  inherited;
  DrawBox1.BeginUpdate;
  FOldWidth := DrawBox1.Width;
  FOldHeight := DrawBox1.Height;
end;

procedure TMStDxfImportDialog.WMExitSizeMove(var m: TMessage);
begin
  inherited;
  if (DrawBox1.Width = FOldWidth) And (DrawBox1.Height = FOldHeight) then
    DrawBox1.CancelUpdate
  else
    DrawBox1.EndUpdate;
end;

procedure TMStDxfImportDialog.FormShow(Sender: TObject);
begin
  DrawBox1.ZoomToExtension;
  DrawBox1.EndUpdate;
end;

end.
