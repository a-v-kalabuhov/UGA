unit Situation;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  StdCtrls, Mask, DBCtrls, ImgList, ComCtrls, IBSQL, Math, ActnList,
  ExtCtrls, Db, IBCustomDataSet, IBQuery, IBUpdateSQL, GeoObjects, FR_Class,
  Printers;

type
  TSituationForm = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    ImageList: TImageList;
    ActionList: TActionList;
    actNew: TAction;
    actDelete: TAction;
    actEdit: TAction;
    PageControl: TPageControl;
    tshData: TTabSheet;
    tshPreview: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    dbeDocNumber: TDBEdit;
    dbeDocDate: TDBEdit;
    dbeCustomer: TDBEdit;
    dbeAdderss: TDBEdit;
    gbStation: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    dbeX: TDBEdit;
    dbeY: TDBEdit;
    gbPoints: TGroupBox;
    lvPoints: TListView;
    btnAdd: TButton;
    btnDelete: TButton;
    btnEdit: TButton;
    PictPanel: TPanel;
    PaintBox: TPaintBox;
    btnPrint: TButton;
    ibqPoints: TIBQuery;
    ibusPoints: TIBUpdateSQL;
    ibqPointsT_SITUATION_ID: TIntegerField;
    ibqPointsID: TSmallintField;
    ibqPointsPOINT_CORNER: TFloatField;
    ibqPointsPOINT_LENGTH: TFloatField;
    ibqPointsX: TFloatField;
    ibqPointsY: TFloatField;
    ibqPointsDEGREE_CORNER: TStringField;
    ibqPointsDEGREE_AZIMUTH: TStringField;
    ibqPointsAZIMUTH: TFloatField;
    ibqPointsNAME: TIBStringField;
    ibqPointsHEIGHT: TFloatField;
    ibqPointsCOMMENT: TIBStringField;
    dsPoints: TDataSource;
    dbeExcutor: TDBEdit;
    Label8: TLabel;
    GroupBox1: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    dbeXOrientir: TDBEdit;
    dbeYOrientir: TDBEdit;
    dbeAzimuth: TDBEdit;
    Label7: TLabel;
    Button1: TButton;
    procedure btnOkClick(Sender: TObject);
    procedure actNewExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actNewUpdate(Sender: TObject);
    procedure actDeleteUpdate(Sender: TObject);
    procedure actEditUpdate(Sender: TObject);
    procedure actEditExecute(Sender: TObject);
    procedure dbeXExit(Sender: TObject);
    procedure ibqPointsCalcFields(DataSet: TDataSet);
    procedure btnPrintClick(Sender: TObject);
    procedure PaintBoxPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    _ReadOnly: Boolean;
    SituationId: Integer;
    GeoStructure: TGeoStructure;
    procedure ReadPoints(New: Boolean = False);
    procedure InitializeArray;
//    procedure Print;
    procedure InitIBX;
  public
  end;

  function ShowTSituation(ReadOnly: Boolean = False): Boolean;

implementation

{$R *.DFM}

uses
  uGC,
  //Project
  Situations, ADB6, SituationPoint, AProc6, Geodesy, //TSituationRpt2,
  AGraph6, AString6, APrinter6, uKisPrintModule, uKisConsts;

function ShowTSituation(ReadOnly: Boolean=False): Boolean;
const
  Indent = 5;
begin
  with TSituationForm.Create(Application) do
  try
    PageControl.ActivePageIndex := 0;
    SituationId:=dbeDocNumber.DataSource.DataSet.FieldByName(SF_ID).AsInteger;
    ibqPoints.ParamByName(SF_T_SITUATION_ID).AsInteger := SituationId;
    ibqPoints.Open;
    _ReadOnly := ReadOnly;
    ReadPoints;
    //создание и инициализация GeoStructure
    GeoStructure := IObject(TGeoStructure.Create).AObject as TGeoStructure;
    SetLength(GeoStructure.GeoContours, 2);
    GeoStructure.GeoContours[0].Connected := False;
    GeoStructure.GeoContours[0].Visible := True;
    GeoStructure.GeoContours[0].Color := clRed;
    GeoStructure.GeoContours[0].PointSize := 0.5;

    GeoStructure.GeoContours[1].Connected := False;
    GeoStructure.GeoContours[1].Visible := True;
    GeoStructure.GeoContours[1].Color := clBlack;
    GeoStructure.GeoContours[1].PointSize := 0.5;

    GeoStructure.Canvas:=PaintBox.Canvas;
    GeoStructure.SetParams(1, 1, 0,
      Rect(Indent, Indent, PaintBox.Width - Indent, PaintBox.Height - Indent),
      True);
    InitializeArray;

    Result := ShowModal = mrOk;
  finally
    Free;
  end;
end;

procedure TSituationForm.btnOkClick(Sender: TObject);
begin
  SoftPost(dbeDocNumber.DataSource.DataSet);
  ModalResult := mrOk;
end;

procedure TSituationForm.ReadPoints(New: Boolean=False);
var
  ItemIndex: Integer;

  procedure SetFocused(Item: TListItem);
  begin
    if Assigned(Item) then
    begin
      Item.Selected := True;
      Item.Focused := True;
    end;
  end;
begin
  if lvPoints.Selected = nil then
    ItemIndex := -1
  else
    ItemIndex := lvPoints.Selected.Index;
  with ibqPoints do
  begin
    First;
    lvPoints.Items.BeginUpdate;
    lvPoints.Items.Clear;
    try
      while not Eof do
      begin
        with lvPoints.Items.Add do
        begin
          ImageIndex := 0;
          Data := Pointer(FieldByName(SF_ID).AsInteger);
          Caption := FieldByName(SF_NAME).AsString;
          SubItems.Add(Format(S_COORD_FORMAT, [ibqPointsPOINT_CORNER.AsFloat]));
          SubItems.Add(Format(S_COORD_FORMAT, [ibqPointsPOINT_LENGTH.AsFloat]));
          SubItems.Add(Format(S_COORD_FORMAT, [ibqPointsX.AsFloat]));
          SubItems.Add(Format(S_COORD_FORMAT, [ibqPointsY.AsFloat]));
          SubItems.Add(Format(S_COORD_FORMAT, [ibqPointsHEIGHT.AsFloat]));
          SubItems.Add(Format(S_COORD_FORMAT, [ibqPointsAZIMUTH.AsFloat]));
          SubItems.Add(ibqPointsCOMMENT.AsString);
        end;
        Next;
      end;
      //позиционируем курсор
      if New then
        SetFocused(lvPoints.Items[Pred(lvPoints.Items.Count)])
      else
        if ItemIndex >= 0 then
          if ItemIndex <= Pred(lvPoints.Items.Count) then
            SetFocused(lvPoints.Items[ItemIndex])
          else
            SetFocused(lvPoints.Items[Pred(lvPoints.Items.Count)]);
    finally
      lvPoints.Items.EndUpdate;
    end;
  end;
end;

procedure TSituationForm.actNewExecute(Sender: TObject);
var
  NewId: Integer;
  NewName: String;
begin
  with ibqPoints do
  begin
    Last;
    NewId := Succ(FieldByName(SF_ID).AsInteger);
    NewName := GetNextNumber(FieldByName(SF_NAME).AsString);
    Append;
    FieldByName(SF_ID).AsInteger := NewId;
    FieldByName(SF_T_SITUATION_ID).AsInteger := SituationId;
    FieldByName(SF_NAME).AsString := NewName;
    FieldByName(SF_POINT_LENGTH).AsFloat := 0;
    FieldByName(SF_POINT_CORNER).AsFloat := 0;
    FieldByName(SF_HEIGHT).AsFloat := 0;
    if ShowPoint(ibqPoints) then
      ReadPoints(True);
  end;
end;

procedure TSituationForm.actDeleteExecute(Sender: TObject);
begin
  if (lvPoints.Selected = nil) or
    (MessageBox(0, PChar(S_DELETE_RECORD), PChar(S_Confirm),
                MB_ICONQUESTION + MB_OKCANCEL) <> IDOK) or
    not ibqPoints.Locate(SF_ID, Integer(lvPoints.Selected.Data), []) then Exit;
  ibqPoints.Delete;
  ReadPoints;
end;

procedure TSituationForm.actNewUpdate(Sender: TObject);
begin
  actNew.Enabled := not _ReadOnly;
end;

procedure TSituationForm.actDeleteUpdate(Sender: TObject);
begin
  actDelete.Enabled := not _ReadOnly and Assigned(lvPoints.Selected);
end;

procedure TSituationForm.actEditUpdate(Sender: TObject);
begin
  actEdit.Enabled := not _ReadOnly and Assigned(lvPoints.Selected);
end;

procedure TSituationForm.actEditExecute(Sender: TObject);
begin
  with ibqPoints do
  begin
    if not Locate(SF_ID, Integer(lvPoints.Selected.Data), []) then
      raise Exception.Create(S_POINT_NOT_FOUND);
    if ShowPoint(ibqPoints) then
      ReadPoints;
  end;
end;

procedure TSituationForm.dbeXExit(Sender: TObject);
begin
  ReadPoints;
end;

procedure TSituationForm.ibqPointsCalcFields(DataSet: TDataSet);
var
  X,Y : Double;
begin
  ibqPointsDEGREE_CORNER.AsString := GetDegreeCorner(DegToRad(ibqPointsPOINT_CORNER.AsFloat));
  CalcTakingSituation(dbeX.Field.AsFloat, dbeY.Field.AsFloat,
                      DegToRad(dbeAzimuth.Field.AsFloat),
                      DegToRad(ibqPointsPOINT_CORNER.AsFloat),
                      ibqPointsPOINT_LENGTH.AsFloat, X, Y);
  ibqPointsX.AsFloat := X;
  ibqPointsY.AsFloat := Y;
  ibqPointsAZIMUTH.AsFloat := RadToDeg(
    GetValidCorner(DegToRad(
          dbeAzimuth.Field.AsFloat + ibqPointsPOINT_CORNER.AsFloat)));
  ibqPointsDEGREE_AZIMUTH.AsString := GetDegreeCorner(DegToRad(ibqPointsAZIMUTH.AsFloat));
end;

procedure TSituationForm.btnPrintClick(Sender: TObject);
begin
//  InitializeArray;
//  PreViewTSituationRpt2(GeoStructure);
  //Print;
end;

procedure TSituationForm.InitializeArray;
begin
  with ibqPoints, GeoStructure do
  begin
    FetchAll; First;
    SetLength(GeoPoints, Succ(RecordCount));
    GeoPoints[0].Caption1 := 'Станция';
    GeoPoints[0].X := Round(100 * dbeX.Field.AsFloat);
    GeoPoints[0].Y := Round(100 * dbeY.Field.AsFloat);
    GeoPoints[0].Contour := 0;
    while not Eof do
    begin
      GeoPoints[RecNo].Tag := FieldByName(SF_ID).AsInteger;
      GeoPoints[RecNo].Caption1 := FieldByName(SF_NAME).AsString;
      GeoPoints[RecNo].X := Round(100 * FieldByName(SF_X).AsFloat);
      GeoPoints[RecNo].Y := Round(100 * FieldByName(SF_Y).AsFloat);
      GeoPoints[RecNo].Contour := 1;
      Next;
    end;
  end;
end;

procedure TSituationForm.PaintBoxPaint(Sender: TObject);
begin
  InitializeArray;
  GeoStructure.Draw;
end;

procedure TSituationForm.InitIBX;
begin
  ibqPoints.Transaction := SituationsForm.Transaction;
end;

procedure TSituationForm.FormCreate(Sender: TObject);
begin
  InitIBX;
end;

procedure TSituationForm.Button1Click(Sender: TObject);
begin
  if not _ReadOnly then
  try
    if (not SituationsForm.QueryY_ORIENTIR.IsNull) and
       (not SituationsForm.QueryX_ORIENTIR.IsNull) then
    begin
      if not SituationsForm.QueryAZIMUTH.IsNull then
      if MessageBox(0, PChar(S_CHANGE_COORDS), PChar(S_Confirm),
                    MB_ICONQUESTION + MB_OKCANCEL) = IDOK then
      begin
        SoftEdit(SituationsForm.Query);
        SituationsForm.QueryAZIMUTH.AsFloat := Arctan((SituationsForm.QueryX.AsFloat - SituationsForm.QueryX_ORIENTIR.AsFloat) / (SituationsForm.QueryY.AsFloat - SituationsForm.QueryY_ORIENTIR.AsFloat));
      end;
    end
    else
      raise EAbort.Create('');
  except
    MessageBox(0, PChar(S_Check_Coords), PChar(S_Error), MB_ICONWARNING + mb_Ok);
  end;
end;

end.
