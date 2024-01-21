unit uKisMapHistoryClasses;

interface

uses
  SysUtils, Classes, Contnrs, Controls, Windows, Graphics, Types, DB, Forms,
  ExtCtrls,
  uGraphics,
  uKisEntityEditor, uKisMap500Graphics, uKisClasses;

type
  TKisMapHistoryFigure = class(TKisEntity)
  private
    FPoints: TList;
    FHistoryElementId: Integer;
    FFigureType: Boolean;
    FFigureColor: TColor;
    FExtent: TRect;
    procedure SetHistoryElementId(const Value: Integer);
    procedure SetFigureType(const Value: Boolean);
    procedure SetFigureColor(const Value: TColor);
    function GetPoints(Index: Integer): TPoint;
    procedure ClearPoints;
    procedure DeleteLastPoint(Sender: TObject);
    function GetPointCount: Integer;
    procedure DrawPolyLine(Canvas: TCanvas; const aExtent: TRect);
    procedure DrawPoint(const X, Y: Integer; Canvas: TCanvas);
    procedure CopyPoints(aPoints: TList);
  public
    constructor Create(Mngr: TKisMngr); override;
    destructor Destroy; override;
    //
    procedure AddPoint(X, Y: Integer);
    procedure Copy(Source: TKisEntity); override;
    procedure Load(DataSet: TDataSet); override;
    function Clone: TKisMapHistoryFigure; virtual; abstract;
    procedure Draw(Canvas: TCanvas; const aExtent: TRect);
    function Extent: TRect;
    //
    property Points[Index: Integer]: TPoint read GetPoints;
    property HistoryElementId: Integer read FHistoryElementId write SetHistoryElementId;
    property FigureType: Boolean read FFigureType write SetFigureType;
    property FigureColor: TColor read FFigureColor write SetFigureColor;
    property PointCount: Integer read GetPointCount;
  end;

  /// <summary>
  /// Элемент истории планшета.  
  /// </summary>
  TKisMapHistoryElement = class(TKisVisualEntity)
  private
    FOrderNumber: String;
    FDateOfWorks: String;
    FWorksExecutor: String;
    FHorizontalMapping: String;
    FHighRiseMapping: String;
    FMensMapping: String;
    FTacheometricMapping: String;
    FCurrentChangesMapping: String;
    FNewlyBuildingMapping: String;
    FEnginNetMapping: String;
    FTotalSum: String;
    FDraftWorksExecutor: String;
    FChief: String;
    FDateOfAccept: String;
    FFigures: TObjectList;
    FGraphicsEditor: TKisMap500Graphics;
    FFiguresState: TkisFiguresState;
    FImage: TBitmap;
    FLicensedOrgId: Integer;
    procedure SetOrderNumber(const Value: String);
    procedure SetDateOfWorks(const Value: String);
    procedure SetWorksExecutor(const Value: String);
    procedure SetHorizontalMapping(const Value: String);
    procedure SetHighRiseMapping(const Value: String);
    procedure SetMensMapping(const Value: String);
    procedure SetTacheometricMapping(const Value: String);
    procedure SetCurrentChangesMapping(const Value: String);
    procedure SetNewlyBuildingMapping(const Value: String);
    procedure SetEnginNetMapping(const Value: String);
    procedure SetTotalSum(const Value: String);
    procedure SetDraftWorksExecutor(const Value: String);
    procedure SetChief(const Value: String);
    procedure SetDateOfAccept(const Value: String);
    procedure DrawHistoryElement(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    function GetFigures(Index: Integer): TKisMapHistoryFigure;
    function GetSurveyImage(const ImageWidth, ImageHeight: Integer): TBitmap;
    procedure UpdateEditorBySurveyImage;
    procedure UpdateGraphEditorByState;
    procedure CopyFigures(aFiguresList: TObjectList);
    procedure SetLicensedOrgId(const Value: Integer);
  protected
    procedure SetID(const Value: Integer); override;
    function CreateEditor: TKisEntityEditor; override;
    procedure PrepareEditor(AEditor: TKisEntityEditor); override;
    procedure UnprepareEditor(AEditor: TKisEntityEditor); override;
    procedure LoadDataIntoEditor(AEditor: TKisEntityEditor); override;
    procedure ReadDataFromEditor(AEditor: TKisEntityEditor); override;
    function CheckEditor(AEditor: TKisEntityEditor): Boolean; override;
    function CreateFigureInstance: TKisMapHistoryFigure; virtual; abstract;

    //графическая часть
    procedure EditMap(Sender: TObject);
    procedure PrepareFiguresEditor(Editor: TKisEntityEditor);
    procedure CreateLine(Sender: TObject);
    procedure CreateArea(Sender: TObject);
    procedure CommitFigure(Sender: TObject);
    procedure DeleteLastPoint(Sender: TObject);
    procedure SetFigureColor(Color: TColor);
    procedure EndDrawing(Sender: TObject);
    procedure ClearBitmap(Sender: TObject);
    procedure Draw(Canvas: TCanvas; const aExtent: TRect);
    procedure DrawCrosses(Canvas: TCanvas; const Top, Left, Width, Height: Integer);
    procedure UpdateImage(Sender: TObject);
    procedure UpdateOrgControls();
  public
    constructor Create(Mngr: TKisMngr); override;
    destructor Destroy; override;
    //
    procedure Copy(Source: TKisEntity); override;
    procedure Load(DataSet: TDataSet); override;
    //
    procedure AddFigure(aFigure: TKisMapHistoryFigure);
    procedure PaintFigures(Sender: TObject);
    //
    function PrepareMetafile(Size: Integer; Crosses: Boolean): TMetafile;
    //
    function FigureCount: Integer;
    property Figures[Index: Integer]: TKisMapHistoryFigure read GetFigures;
    //
    property OrderNumber: String read FOrderNumber write SetOrderNumber;
    property DateOfWorks: String read FDateOfWorks write SetDateOfWorks;
    property WorksExecutor: String read FWorksExecutor write SetWorksExecutor;
    property HorizontalMapping: String read FHorizontalMapping write SetHorizontalMapping;
    property HighRiseMapping: String read FHighRiseMapping write SetHighRiseMapping;
    property MensMapping: String read FMensMapping write SetMensMapping;
    property TacheometricMapping: String read FTacheometricMapping write SetTacheometricMapping;
    property CurrentChangesMapping: String read FCurrentChangesMapping write SetCurrentChangesMapping;
    property NewlyBuildingMapping: String read FNewlyBuildingMapping write SetNewlyBuildingMapping;
    property EnginNetMapping: String read FEnginNetMapping write SetEnginNetMapping;
    property TotalSum: String read FTotalSum write SetTotalSum;
    property DraftWorksExecutor: String read FDraftWorksExecutor write SetDraftWorksExecutor;
    property Chief: String read FChief write SetChief;
    property DateOfAccept: String read FDateOfAccept write SetDateOfAccept;
    property GraphicsEditor: TKisMap500Graphics read FGraphicsEditor;
    property LicensedOrgId: Integer read FLicensedOrgId write SetLicensedOrgId;
    //
    property Image: TBitmap read FImage write FImage;
  end;

implementation

uses
  uGC,
  uKisConsts, uKisMapHistoryEditor;

type
  THackControl = class(TCustomControl)
  public
    property Canvas;
  end;
  THackGraphControl = class(TGraphicControl)
  public
    property Canvas;
  end;
  
{ TKisMap500Figure }

procedure TKisMapHistoryFigure.AddPoint(X, Y: Integer);
var
  Point: PPoint;
begin
  New(Point);
  Point^.X := X;
  Point^.Y := Y;
  FPoints.Add(Point);
end;

procedure TKisMapHistoryFigure.ClearPoints;
var
  Point: PPoint;
begin
  while FPoints.Count > 0 do
  begin
    Point := FPoints.Extract(FPoints[0]);
    Dispose(Point);
  end;
end;

procedure TKisMapHistoryFigure.Copy(Source: TKisEntity);
begin
  inherited;
  with Source as TKisMapHistoryFigure do
  begin
    Self.FHistoryElementId := FHistoryElementId;
    Self.FFigureColor := FFigureColor;
    Self.FFigureType := FFigureType;
    Self.FExtent := FExtent;
    Self.CopyPoints(FPoints);
  end;
end;

procedure TKisMapHistoryFigure.CopyPoints(aPoints: TList);
var
  I: Integer;
begin
  ClearPoints;
  for I := 0 to Pred(aPoints.Count) do
    with PPoint(aPoints[I])^ do
      AddPoint(X, Y);
end;

constructor TKisMapHistoryFigure.Create(Mngr: TKisMngr);
begin
  inherited;
  FFigureColor := clBlack;
  FPoints := TList.Create;
end;

procedure TKisMapHistoryFigure.DeleteLastPoint(Sender: TObject);
begin
  if FPoints.Count > 0 then
  begin
    Dispose(FPoints.Items[Pred(FPoints.Count)]);
    FPoints.Delete(Pred(FPoints.Count));
  end;
end;

destructor TKisMapHistoryFigure.Destroy;
begin
  ClearPoints;
  FPoints.Free;
  inherited;
end;

procedure TKisMapHistoryFigure.DrawPoint(const X, Y: Integer; Canvas: TCanvas);
begin
  Canvas.Brush.Style := bsSolid;
  Canvas.Ellipse(X - 3, Y - 3, X + 3, Y + 3);
end;

procedure TKisMapHistoryFigure.Draw(Canvas: TCanvas; const aExtent: TRect);
var
  PointBeg, PointFin: PPoint;
  W, H: Double;
begin
  Canvas.Pen.Color := Self.FigureColor;
  DrawPolyLine(Canvas, aExtent);
  W := (FExtent.Right - FExtent.Left) / (aExtent.Right - aExtent.Left);
  H := (FExtent.Bottom - FExtent.Top) / (aExtent.Bottom - aExtent.Top);
  if FigureType and (PointCount > 2) then //область
  begin
    PointFin := FPoints.Last;
    Canvas.MoveTo(Trunc(PointFin^.X / W), Trunc(PointFin^.Y / H));
    PointBeg := FPoints.First;
    Canvas.LineTo(Trunc(PointBeg^.X / W), Trunc(PointBeg^.Y / H));
  end;
end;

procedure TKisMapHistoryFigure.DrawPolyLine(Canvas: TCanvas; const aExtent: TRect);
var
  I: Integer;
  W, H: Double;
  Pts: array of TPoint;
begin
  W := (FExtent.Right - FExtent.Left) / (aExtent.Right - aExtent.Left);
  H := (FExtent.Bottom - FExtent.Top) / (aExtent.Bottom - aExtent.Top);
  case PointCount of
  0 : Exit;
  1 :
    begin
      with Points[0] do
      begin
        Canvas.MoveTo(Trunc(X / W), Trunc(Y / H));
        DrawPoint(Trunc(X / W), Trunc(Y / H), Canvas);
      end;
    end;
  else
    begin
      SetLength(Pts, PointCount);
      for I := 0 to PointCount - 1 do
        with Points[I] do
          Pts[I] := Point(Trunc(X / W), Trunc(Y / H));
      //
      Canvas.Brush.Style := bsDiagCross;
      Canvas.Brush.Color := FFigureColor;
      try
        if FFigureType then
          Canvas.Polygon(Pts)
        else
          Canvas.Polyline(Pts);
        for I := 0 to PointCount - 1 do
          DrawPoint(Pts[I].X, Pts[I].Y, Canvas);
      finally
        Canvas.Brush.Style := bsClear;
      end;
    end;
  end;
end;

function TKisMapHistoryFigure.Extent: TRect;
begin
  Result := FExtent;
end;

function TKisMapHistoryFigure.GetPointCount: Integer;
begin
  Result := FPoints.Count;
end;

function TKisMapHistoryFigure.GetPoints(Index: Integer): TPoint;
begin
  Result := PPoint(FPoints[Index])^;
end;

procedure TKisMapHistoryFigure.Load(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
  { DONE : Добавить получение идентификатора для фикуры из бд }
    ID := FieldByName(SF_ID).AsInteger;
    FHistoryElementId := FieldByName(SF_HISTORY_ELEMENT_ID).AsInteger;
    FFigureColor := FieldByName(SF_FIGURE_COLOR).AsInteger;
    FFigureType := Boolean(FieldByName(SF_FIGURE_TYPE).AsInteger);
    FExtent.Left := FieldByName(SF_EXTENT_LEFT).AsInteger;
    FExtent.Top := FieldByName(SF_EXTENT_TOP).AsInteger;
    FExtent.Right := FieldByName(SF_EXTENT_RIGHT).AsInteger;
    FExtent.Bottom := FieldByName(SF_EXTENT_BOTTOM).AsInteger;
  end;
end;

procedure TKisMapHistoryFigure.SetFigureColor(const Value: TColor);
begin
  if FFigureColor <> Value then
  begin
    FFigureColor := Value;
    Modified := True;
  end;
end;

procedure TKisMapHistoryFigure.SetFigureType(const Value: Boolean);
begin
  if FFigureType <> Value then
  begin
    FFigureType := Value;
    Modified := True;
  end;
end;

procedure TKisMapHistoryFigure.SetHistoryElementId(const Value: Integer);
begin
  if FHistoryElementId <> Value then
  begin
    FHistoryElementId := Value;
    Modified := True;
  end;
end;

{ TKisMapHistory }

procedure TKisMapHistoryElement.AddFigure(aFigure: TKisMapHistoryFigure);
begin
  FFigures.Add(aFigure);
end;

function TKisMapHistoryElement.CheckEditor(AEditor: TKisEntityEditor): Boolean;
var
  D: TDateTime;
begin
  Result := False;
  if EntityEditor is TKisMapHistoryEditor then
  with EntityEditor as TKisMapHistoryEditor do
  begin
    if (Length(Trim(edOrderNumber.Text)) = 0) then
    begin
      MessageBox(Handle, 'Проверьте номер разрешения!', PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edOrderNumber.SetFocus;
      Exit;
    end;
    if not TryStrToDate(edDateOfWorks.Text, D) then
    begin
      MessageBox(Handle, 'Проверьте дату производства работе!', PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edDateOfWorks.SetFocus;
      Exit;
    end;
    if not TryStrToDate(edDateOfAccept.Text, D) then
    begin
      MessageBox(Handle, 'Проверьте дату приемки работ геослужбой!', PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edDateOfAccept.SetFocus;
      Exit;
    end;
    if (Length(Trim(edWorksExecutor.Text)) = 0) then
    begin
      //MessageBox(Handle, 'Проверьте исполнителя полевых работ!', PChar(S_WARN), MB_OK + MB_ICONWARNING);
      //edWorksExecutor.SetFocus;
      //Exit;
    end;
    if (Length(Trim(edDraftWorksExecutor.Text)) = 0) then
    begin
      //MessageBox(Handle, 'Проверьте исполнителя чертежных работ!', PChar(S_WARN), MB_OK + MB_ICONWARNING);
      //edDraftWorksExecutor.SetFocus;
      //Exit;
    end;
    if (Length(Trim(edChief.Text)) = 0) then
    begin
      MessageBox(Handle, 'Проверьте наименование организации!',
        PChar(S_WARN), MB_OK + MB_ICONWARNING);
//      MessageBox(Handle, PChar('Проверьте начальника партии (группы), принявшего работу'), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edChief.SetFocus;
      Exit;
    end;
    if (Length(Trim(edMensMapping.Text)) = 0) then
    begin
      MessageBox(Handle, 'Проверьте адрес!', PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edMensMapping.SetFocus;
      Exit;
    end;

 {   if (Length(Trim(edHorizMapping.Text)) = 0) then begin
      MessageBox(Handle, PChar('Проверьте горизонтальную съемку'), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edHorizMapping.SetFocus;
      Exit;
    end;
    if (Length(Trim(edHighRiseMapping.Text)) = 0) then begin
      MessageBox(Handle, PChar('Проверьте высотную съемку'), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edHighRiseMapping.SetFocus;
      Exit;
    end;
    if (Length(Trim(edTacheomMapping.Text)) = 0) then begin
      MessageBox(Handle, PChar('Проверьте тахеометрическую съемку'), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edTacheomMapping.SetFocus;
      Exit;
    end;
}
    if (Length(Trim(edCurrentChangesMapping.Text)) = 0) then
    begin
      //MessageBox(Handle, 'Проверьте обследование и съемку текущих изменений!', PChar(S_WARN), MB_OK + MB_ICONWARNING);
      //edCurrentChangesMapping.SetFocus;
      //Exit;
    end;
{
    if (Length(Trim(edNewlyBuildingMapping.Text)) = 0) then begin
      MessageBox(Handle, PChar('Проверьте исполнительную съемку вновь выстроеннных зданий'), PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edNewlyBuildingMapping.SetFocus;
      Exit;
    end;
}    
    if (Length(Trim(edEnginNetMapping.Text)) = 0) then
    begin
      //MessageBox(Handle, 'Проверьте исполнительную съемку инженерных сетей!', PChar(S_WARN), MB_OK + MB_ICONWARNING);
      //edEnginNetMapping.SetFocus;
      //Exit;
    end;
    if (Length(Trim(edTotalSum.Text)) = 0) then
    begin
      MessageBox(Handle, 'Проверьте общую площадь!', PChar(S_WARN), MB_OK + MB_ICONWARNING);
      edTotalSum.SetFocus;
      Exit;
    end;
  end;
  Result := true;
end;

procedure TKisMapHistoryElement.CommitFigure(Sender: TObject);
begin
  FFiguresState := fsView;
  UpdateGraphEditorByState;
end;

procedure TKisMapHistoryElement.Copy(Source: TKisEntity);
begin
  inherited;
  with Source as TKisMapHistoryElement do
  begin
    Self.FOrderNumber := FOrderNumber;
    Self.FDateOfWorks := FDateOfWorks;
    Self.FWorksExecutor := FWorksExecutor;
    Self.FHorizontalMapping := FHorizontalMapping;
    Self.FHighRiseMapping := FHighRiseMapping;
    Self.FMensMapping := FMensMapping;
    Self.FTacheometricMapping := FTacheometricMapping;
    Self.FCurrentChangesMapping := FCurrentChangesMapping;
    Self.FNewlyBuildingMapping := FNewlyBuildingMapping;
    Self.FEnginNetMapping := FEnginNetMapping;
    Self.FTotalSum := FTotalSum;
    Self.FDraftWorksExecutor := FDraftWorksExecutor;
    Self.FChief := FChief;
    Self.FDateOfAccept := FDateOfAccept;
    Self.FLicensedOrgId := FLicensedOrgId;
    Self.CopyFigures(FFigures);
  end;
end;

procedure TKisMapHistoryElement.CopyFigures(aFiguresList: TObjectList);
var
  I: Integer;
begin
  FFigures.Clear;
  for I := 0 to Pred(aFiguresList.Count) do
  begin
    FFigures.Add(TKisMapHistoryFigure(aFiguresList[I]).Clone);
  end;
end;

function TKisMapHistoryElement.CreateEditor: TKisEntityEditor;
begin
  Result := TKisMapHistoryEditor.Create(Application);
end;

procedure TKisMapHistoryElement.DrawHistoryElement(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (FFigures.Count > 0) and (FFiguresState <> fsView) then
  begin
    Figures[Pred(FFigures.Count)].AddPoint(X, Y);
    if Sender is TPaintBox then
       TPaintBox(Sender).Repaint;
  end;
end;

procedure TKisMapHistoryElement.ClearBitmap(Sender: TObject);
var
  X1, Y1, X2, Y2: Integer;
begin
  if Sender is TPaintBox then
  with TPaintBox(Sender) do
  begin
    X1 := Top;
    Y1 := Left;
    X2 := Top + Width;
    Y2 := Left + Height;
    Canvas.Brush.Color := clWindow;
    Canvas.FillRect(Rect(X1, Y1, X2, Y2));
  end;
end;

procedure TKisMapHistoryElement.Draw(Canvas: TCanvas; const aExtent: TRect);
var
  I: Integer;
begin
  for I := 0 to Pred(FFigures.Count) do
    Figures[I].Draw(Canvas, aExtent);
end;

procedure TKisMapHistoryElement.DrawCrosses(Canvas: TCanvas;
  const Top, Left, Width, Height: Integer);
var
  I, Nx, Ny, X, Y, J, Divisor, N: Integer;
begin
  N := 4;
  Divisor := N + 1;
  Canvas.Pen.Color := clNavy;
  Nx := Trunc(Width / Divisor);
  Ny := Trunc(Height / Divisor);
  X := Left;
  for I := 1 to N do
  begin
    X := X + Nx;
    Y := Top;
    for J := 1 to N do
    begin
      Y := Y + Ny;
      Canvas.MoveTo(X, Y);
      Canvas.LineTo(X + 7, Y);
      Canvas.MoveTo(X + 3, Y - 3);
      Canvas.LineTo(X + 3, Y + 4);
    end;
  end;
end;

procedure TKisMapHistoryElement.EditMap(Sender: TObject);
var
  OldCount: Integer;
begin
  OldCount := FFigures.Count;
  FGraphicsEditor := TKisMap500Graphics.Create(Application);
  GraphicsEditor.Caption := 'Графическая часть';
  PrepareFiguresEditor(GraphicsEditor);
  Draw(GraphicsEditor.PaintBox.Canvas, GraphicsEditor.PaintBox.ClientRect);
  if GraphicsEditor.ShowModal = mrOK then
  begin
    Self.Modified := OldCount <> FFigures.Count;
    UpdateEditorBySurveyImage;
  end;
end;

procedure TKisMapHistoryElement.EndDrawing(Sender: TObject);
begin

end;

function TKisMapHistoryElement.FigureCount: Integer;
begin
  Result := FFigures.Count;
end;

function TKisMapHistoryElement.GetFigures(Index: Integer): TKisMapHistoryFigure;
begin
  Result := TKisMapHistoryFigure(FFigures[Index]);
end;

procedure TKisMapHistoryElement.Load(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    ID := FieldByName(SF_ID).AsInteger;
    Chief := FieldByName(SF_CHIEF).AsString;
    CurrentChangesMapping := FieldByName(SF_CURRENT_CHANGES_MAPPING).AsString;
    DateOfAccept := FieldByName(SF_DATE_OF_ACCEPT).AsString;
    DateOfWorks := FieldByName(SF_DATE_OF_WORKS).AsString;
    DraftWorksExecutor := FieldByName(SF_DRAFT_WORKS_EXECUTOR).AsString;
    EnginNetMapping := FieldByName(SF_ENGIN_NET_MAPPING).AsString;
    HighRiseMapping := FieldByName(SF_HIGH_RISE_MAPPING).AsString;
    HorizontalMapping := FieldByName(SF_HORIZONTAL_MAPPING).AsString;
    MensMapping := FieldByName(SF_MENS_MAPPING).AsString;
    NewlyBuildingMapping := FieldByName(SF_NEWLY_BUILDING_MAPPING).AsString;
    OrderNumber := FieldByName(SF_ORDER_NUMBER).AsString;
    TacheometricMapping := FieldByName(SF_TACHEOMETRIC_MAPPING).AsString;
    TotalSum := FieldByName(SF_TOTAL_SUM).AsString;
    WorksExecutor := FieldByName(SF_EXECUTOR).AsString;
    Self.Modified := True;
  end;
end;

procedure TKisMapHistoryElement.LoadDataIntoEditor(AEditor: TKisEntityEditor);
begin
  inherited;
  with AEditor as TKisMapHistoryEditor do
  begin
    edOrderNumber.Text := OrderNumber;
    edDateOfWorks.Text := DateOfWorks;
    edHorizMapping.Text := HorizontalMapping;
    edHighRiseMapping.Text := HighRiseMapping;
    edMensMapping.Text := MensMapping;
    edTacheomMapping.Text := TacheometricMapping;
    edCurrentChangesMapping.Text := CurrentChangesMapping;
    edNewlyBuildingMapping.Text := NewlyBuildingMapping;
    edEnginNetMapping.Text := EnginNetMapping;
    edTotalSum.Text := TotalSum;
    edWorksExecutor.Text := WorksExecutor;
    edDraftWorksExecutor.Text := DraftWorksExecutor;
    edChief.Text := Chief;
    edDateOfAccept.Text := DateOfAccept;
    if Assigned(FImage) then
      imgSurvey.Picture.Bitmap := FImage;
    btnSetMap.Enabled := not Assigned(FImage);
    edOrg.Text := '';
    OrgName := '';
  end;
end;

procedure TKisMapHistoryElement.PaintFigures(Sender: TObject);
var
  aCanvas: TCanvas;
  Ctrl: TControl;
begin
  aCanvas := nil;
  if Sender is TPaintBox then
    aCanvas := TPaintBox(Sender).Canvas
  else
  if Sender is TGraphicControl then
    aCanvas := THackGraphControl(Sender).Canvas
  else
  if Sender is TCustomControl then
    aCanvas := THackControl(Sender).Canvas;
  //
  if Assigned(aCanvas) then
  begin
    Ctrl := TControl(Sender);
    if Assigned(Image) then
    begin
      aCanvas.StretchDraw(Ctrl.ClientRect, Image);
    end
    else
    begin
      ClearBitmap(Sender);
      Draw(aCanvas, Ctrl.ClientRect);
    end;
    DrawCrosses(aCanvas, 0, 0, Ctrl.ClientWidth, Ctrl.ClientHeight);
  end;
end;

procedure TKisMapHistoryElement.PrepareEditor(AEditor: TKisEntityEditor);
begin
  inherited;
  with AEditor as TKisMapHistoryEditor do
  begin
     btnSetMap.OnClick := EditMap;
     OnUpdateImage := UpdateImage;
     UpdateEditorBySurveyImage;
     UpdateOrgControls();
  end;
end;

procedure TKisMapHistoryElement.PrepareFiguresEditor(Editor: TKisEntityEditor);
begin
  with Editor as TKisMap500Graphics do
  begin
    with PaintBox as TPaintBox do
    begin
      btnDrawLine.OnClick := CreateLine;
      btnDrawArea.OnClick := CreateArea;
      btnCommit.OnClick := CommitFigure;
      OnMouseDown := DrawHistoryElement;
      OnPaint := PaintFigures;
      btnDeleteLastPoint.OnClick := DeleteLastPoint;
    end;
    OnSelectColor := SetFigureColor;
    btnBlack.Down := True;
    UpdateGraphEditorByState;
  end;
end;

function TKisMapHistoryElement.PrepareMetafile(Size: Integer; Crosses: Boolean): TMetafile;
var
  aCanvas: TMetafileCanvas;
  I, D: Integer;
  Extent: TRect;
begin
  Result := TMetafile.Create;
  Result.Width := Size;
  Result.Height := Size; 
  aCanvas := TMetafileCanvas.Create(Result, 0);
  try
    Extent := Rect(0, 0, Pred(Size), Pred(Size));
    //
    if Assigned(FImage) then
      aCanvas.StretchDraw(Extent, FImage)
    else
    begin
      aCanvas.Pen.Style := psSolid;
      aCanvas.Pen.Color := clBlack;
      aCanvas.Brush.Style := bsClear;
      aCanvas.Brush.Color := clWhite;
      aCanvas.Rectangle(Extent);
      D := Round(Size / 5);
      for I := 1 to 4 do
      begin
        aCanvas.MoveTo(D * I, 0);
        aCanvas.LineTo(D * I, Pred(Size));
        aCanvas.MoveTo(0, D * I);
        aCanvas.LineTo(Pred(Size), D * I);
      end;
      //
      Draw(aCanvas, Extent);
    end;
    //
    if Crosses then
    begin
      aCanvas.Pen.Style := psSolid;
      aCanvas.Pen.Color := clBlack;
      aCanvas.Pen.Width := 3;
      aCanvas.DrawCrosses(Size, Size);
    end;
  finally
    FreeAndNil(aCanvas);
  end;
end;

procedure TKisMapHistoryElement.ReadDataFromEditor(AEditor: TKisEntityEditor);
begin
  inherited;
  with AEditor as TKisMapHistoryEditor do
  begin
    OrderNumber := Trim(edOrderNumber.Text);
    DateOfWorks := Trim(edDateOfWorks.Text);
    HighRiseMapping := Trim(edHighRiseMapping.Text);
    HorizontalMapping := Trim(edHorizMapping.Text);
    MensMapping := Trim(edMensMapping.Text);
    TacheometricMapping := Trim(edTacheomMapping.Text);
    CurrentChangesMapping := Trim(edCurrentChangesMapping.Text);
    NewlyBuildingMapping := Trim(edNewlyBuildingMapping.Text);
    EnginNetMapping := Trim(edEnginNetMapping.Text);
    TotalSum := Trim(edTotalSum.Text);
    WorksExecutor := Trim(edWorksExecutor.Text);
    DraftWorksExecutor := Trim(edDraftWorksExecutor.Text);
    Chief := Trim(edChief.Text);
    DateOfAccept := Trim(edDateofAccept.Text);
  end;
end;

procedure TKisMapHistoryElement.SetChief(const Value: String);
begin
  if FChief <> Value then
  begin
    FChief := Value;
    Modified := True;
  end;
end;

procedure TKisMapHistoryElement.SetCurrentChangesMapping(const Value: String);
begin
  if FCurrentChangesMapping <> Value then
  begin
    FCurrentChangesMapping := Value;
    Modified := True;
  end;
end;

procedure TKisMapHistoryElement.SetDateOfAccept(const Value: String);
begin
  if FDateOfAccept <> Value then
  begin
    FDateOfAccept := Value;
    Modified := True;
  end;
end;

procedure TKisMapHistoryElement.SetDateOfWorks(const Value: String);
begin
  if FDateOfWorks <> Value then
  begin
    FDateOfWorks := Value;
    Modified := True;
  end;
end;

procedure TKisMapHistoryElement.SetDraftWorksExecutor(const Value: String);
begin
  if FDraftWorksExecutor <> Value then
  begin
    FDraftWorksExecutor := Value;
    Modified := True;
  end;
end;

procedure TKisMapHistoryElement.SetEnginNetMapping(const Value: String);
begin
  if FEnginNetMapping <> Value then
  begin
    FEnginNetMapping := Value;
    Modified := True;
  end;
end;

procedure TKisMapHistoryElement.SetHighRiseMapping(const Value: String);
begin
  if FHighRiseMapping <> Value then
  begin
    FHighRiseMapping := Value;
    Modified := True;
  end;
end;

procedure TKisMapHistoryElement.SetHorizontalMapping(const Value: String);
begin
  if FHorizontalMapping <> Value then
  begin
    FHorizontalMapping := Value;
    Modified := True;
  end;
end;

procedure TKisMapHistoryElement.SetMensMapping(const Value: String);
begin
  if FMensMapping <> Value then
  begin
    FMensMapping := Value;
    Modified := True;
  end;
end;

procedure TKisMapHistoryElement.SetNewlyBuildingMapping(const Value: String);
begin
  if FNewlyBuildingMapping <> Value then
  begin
    FNewlyBuildingMapping := Value;
    Modified := True;
  end;
end;

procedure TKisMapHistoryElement.SetOrderNumber(const Value: String);
begin
  if FOrderNumber <> Value then
  begin
    FOrderNumber := Value;
    Modified := True;
  end;
end;

procedure TKisMapHistoryElement.SetTacheometricMapping(const Value: String);
begin
  if FTacheometricMapping <> Value then
  begin
    FTacheometricMapping := Value;
    Modified := True;
  end;
end;

procedure TKisMapHistoryElement.SetTotalSum(const Value: String);
begin
  if FTotalSum <> Value then
  begin
    FTotalSum := Value;
    Modified := True;
  end;
end;

procedure TKisMapHistoryElement.SetWorksExecutor(const Value: String);
begin
  if FWorksExecutor <> Value then
  begin
    FWorksExecutor := Value;
    Modified := True;
  end;
end;

procedure TKisMapHistoryElement.CreateArea(Sender: TObject);
var
  Figure: TKisMapHistoryFigure;
begin
  Figure := CreateFigureInstance;
  Figure.FFigureType := True;
  Figure.FExtent := GraphicsEditor.PaintBox.ClientRect;
  Figure.FPoints := TList.Create;
  FFigures.Add(Figure);
  Figure.HistoryElementId := Self.ID;
  FFiguresState := fsNewArea;
  UpdateGraphEditorByState;
end;

procedure TKisMapHistoryElement.CreateLine(Sender: TObject);
var
  Figure: TKisMapHistoryFigure;
begin
  Figure := CreateFigureInstance;
  Figure.FExtent := GraphicsEditor.PaintBox.ClientRect;
  Figure.FigureType := False;
  Figure.FPoints := TList.Create;
  FFigures.Add(Figure);
  Figure.HistoryElementId := Self.ID;
  FFiguresState := fsNewLine;
  UpdateGraphEditorByState;
end;

procedure TKisMapHistoryElement.SetFigureColor(Color: TColor);
begin
  if FFiguresState <> fsView then
  begin
    Figures[Pred(FFigures.Count)].FigureColor := Color;
    GraphicsEditor.PaintBox.Repaint;
  end;
end;

procedure TKisMapHistoryElement.DeleteLastPoint(Sender: TObject);
begin
  if FFiguresState <> fsView then
  begin
    Figures[Pred(FFigures.Count)].DeleteLastPoint(Sender);
    if Figures[Pred(FFigures.Count)].PointCount = 0 then
    begin
      FFigures.Delete(Pred(FFigures.Count));
      FFiguresState := fsView;
      UpdateGraphEditorByState;
    end;
    TKisMap500Graphics(GraphicsEditor).PaintBox.Invalidate;
  end;
end;

function TKisMapHistoryElement.GetSurveyImage(const ImageWidth,
  ImageHeight: Integer): TBitmap;
begin
  Result := TBitmap.Create;
  Result.PixelFormat := pf24bit;
  Result.SetSize(ImageWidth, ImageHeight);
  Draw(Result.Canvas, Rect(0, 0, ImageWidth, ImageHeight));
  DrawCrosses(Result.Canvas, 0, 0, ImageWidth, ImageHeight);
end;

procedure TKisMapHistoryElement.UnPrepareEditor(AEditor: TKisEntityEditor);
begin
  with AEditor as TKisMapHistoryEditor do
   OnUpdateImage := nil;
  inherited;
end;

procedure TKisMapHistoryElement.UpdateEditorBySurveyImage;
var
  Bmp: TBitmap;
begin
  with TKisMapHistoryEditor(EntityEditor) do
  begin
    if Assigned(Image) then
    begin
      Bmp := Image;
      DrawCrosses(Bmp.Canvas, 0, 0, Bmp.Width, Bmp.Height);
    end
    else
      Bmp := GetSurveyImage(imgSurvey.ClientWidth, imgSurvey.ClientHeight);
    imgSurvey.Picture.Bitmap := Bmp;
    imgSurvey.Invalidate;
  end;
end;

constructor TKisMapHistoryElement.Create(Mngr: TKisMngr);
begin
  inherited;
  FFigures := TObjectList.Create;
  FLicensedOrgId := -1;
end;

destructor TKisMapHistoryElement.Destroy;
begin
  FFigures.Free;
  FreeAndNil(FImage);
  inherited;
end;

procedure TKisMapHistoryElement.UpdateGraphEditorByState;
begin
  with GraphicsEditor do
  begin
    btnDrawLine.Down := FFiguresState = fsNewLine;
    btnDrawArea.Down := FFiguresState = fsNewArea;
    btnDrawLine.Enabled := FFiguresState <> fsNewArea;
    btnDrawArea.Enabled := FFiguresState <> fsNewLine;
    btnDeleteLastPoint.Enabled := FFiguresState <> fsView;
    btnCommit.Enabled := FFiguresState <> fsView;
    btnBlack.Enabled := FFiguresState <> fsView;
    btnRed.Enabled := FFiguresState <> fsView;
    btnGreen.Enabled := FFiguresState <> fsView;
    btnPurple.Enabled := FFiguresState <> fsView;
    btnBlue.Enabled := FFiguresState <> fsView;
    btnRed2.Enabled := FFiguresState <> fsView;
    btnSelColor.Enabled := FFiguresState <> fsView;
    if FFiguresState <> fsView then
      PaintBox.Cursor := crCross
    else
      PaintBox.Cursor := crArrow;
  end;
end;

procedure TKisMapHistoryElement.UpdateImage(Sender: TObject);
begin
  UpdateEditorBySurveyImage;
end;

procedure TKisMapHistoryElement.UpdateOrgControls;
begin
  with TKisMapHistoryEditor(EntityEditor) do
  begin
    edOrg.ReadOnly := True;
    edOrg.Color := Color;
    btnOrg.Enabled := not Self.ReadOnly and Assigned(btnOrg.OnClick);
  end;
end;

procedure TKisMapHistoryElement.SetID(const Value: Integer);
var
  I: Integer;
begin
  inherited;
  for I := 0 to Pred(FFigures.Count) do
    Figures[I].HistoryElementId := Value;
end;

procedure TKisMapHistoryElement.SetLicensedOrgId(const Value: Integer);
begin
  if FLicensedOrgId <> Value then
  begin
    FLicensedOrgId := Value;
    Modified := True;
  end;
end;

end.
