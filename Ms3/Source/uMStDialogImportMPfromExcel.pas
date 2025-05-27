unit uMStDialogImportMPfromExcel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, Contnrs, ComObj, Mask, JvExMask, JvSpin, ValEdit,
  EzLib,
  uMStClassesMPIntf, uMStClassesProjectsMP;

type
  TRowRec = record
    NObj: Integer;
    NSubObj: Integer;
    NPt: Integer;
    X: Double;
    Y: Double;
    Category: string;
    Addr: string;
    NumProj: string;
    NameProj: string;
    Rotangle: string;
    Diam: string;
    PipeCount: string;
    Voltage: string;
    Material: string;
    Top: string;
    Bottom: string;
    Floor: string;
    Owner: string;
  end;

type
  TmstMPExcelDialogForm = class(TForm)
    Label1: TLabel;
    edFileName: TEdit;
    btnSelectFile: TButton;
    OpenDialog1: TOpenDialog;
    GroupBox1: TGroupBox;
    StringGrid1: TStringGrid;
    Label2: TLabel;
    spnSkipRows: TJvSpinEdit;
    btnImport: TButton;
    btnCancel: TButton;
    Label3: TLabel;
    grdColumns: TStringGrid;
    ValueListEditor1: TValueListEditor;
    procedure btnSelectFileClick(Sender: TObject);
    procedure spnSkipRowsChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ValueListEditor1GetPickList(Sender: TObject; const KeyName: string; Values: TStrings);
    procedure btnImportClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FSkipRows: Integer;
    FRowCnt: Integer;
    FColCnt: Integer;
    FData: array of array of string;
    FList: TObjectList;
    FMCK36: Boolean;
    FExchangeXY: Boolean;
    FCurrObj: TmstMPObject;
    FMP: ImstMPModule;
    function ProcessFileName(var XlFileName:string; const Ext: string): Boolean;
    function OpenExcelFile(const XlFileName:string): Boolean;
    procedure ReloadGrid();
    function GetColName(const Col: Integer): string;
    function GetColNum(const ColName: string): Integer;
    procedure PrepareColumnsGrid();
    procedure AddColumnToGrid(const aColName: string);
    function CheckDataParams(): Boolean;
    function PrepareObjectList(): Boolean;
    function GetMPObjectCount: Integer;
    function GetMPObjects(Index: Integer): TmstMPObject;
    procedure GetAssignedCol(const aKey: string; var ColName: string; var ColNum: Integer);
    procedure CheckFields(const aRow: Integer; var aRowRec: TRowRec);
    procedure SetSemanticFields(aMPObj: TmstMPObject; const aRowRec: TRowRec);
    procedure CopySemanticFields(Source, Target: TmstMPObject);
    function CheckObjectLayers(): Boolean;
    function CheckLayer(MpObj: TmstMPObject): Boolean;
  public
    function Execute(MP: ImstMPModule; aImport: ImstMPExcelImport): Boolean;
    //
    property MPObjects[Index: Integer]: TmstMPObject read GetMPObjects;
    property MPObjectCount: Integer read GetMPObjectCount;
  end;

var
  mstMPExcelDialogForm: TmstMPExcelDialogForm;

implementation

{$R *.dfm}

uses
  EzEntities,
  uCommonUtils, uGeoUtils,
  uEzEntityCSConvert;

const
  KeyNum1 = 'Номер объекта';
  KeyNum2 = 'Номер подобъекта';
  KeyNum3 = 'Номер точки';
  KeyX = 'Координата X';
  KeyY = 'Координата Y';
  KeyLayer = 'Слой';
  KeyAddr = 'Адрес';
  KeyNumProj = 'Номер проекта';
  KeyNameProj = 'Название проекта';
  KeyRotangle = 'Угол поворота';
  KeyDiam = 'Диаметр';
  KeyPipeCount = 'Количество проводов/труб';
  KeyVoltage = 'Напряжение';
  KeyMaterial = 'Материал';
  KeyTop = 'Верх';
  KeyBottom = 'Низ';
  KeyFloor = 'Дно';
  KeyOwner = 'Балансодержатель';
const
  LETTERS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

procedure TmstMPExcelDialogForm.AddColumnToGrid(const aColName: string);
var
  I: Integer;
begin
  I := ValueListEditor1.InsertRow(aColName, '', True);
  ValueListEditor1.ItemProps[I - 1].ReadOnly := True;
  ValueListEditor1.ItemProps[I - 1].EditStyle := esPickList;
end;

procedure TmstMPExcelDialogForm.btnImportClick(Sender: TObject);
begin
  CheckDataParams();
  // читаем список объектов
  if not PrepareObjectList() then
    Exit;
  if not CheckObjectLayers() then
    Exit;
  ModalResult := mrOK;
end;

procedure TmstMPExcelDialogForm.btnSelectFileClick(Sender: TObject);
const
  XlFiles = '.XLS.XLSX';
var
  XlFileName: string;
  XlExt: string;
begin
  if OpenDialog1.Execute(Handle) then
  begin
    XlFileName := OpenDialog1.Files[0];
    XlExt := AnsiUpperCase(ExtractFileExt(XlFileName));
    if (XlExt = '') or (Pos(XlExt, XlFiles) < 0) then
      if not ProcessFileName(XlFileName, '.xls') then
      if not ProcessFileName(XlFileName, '.xlsx') then
      begin
        ShowMessage('Выбранный файл не обнаружен!');
        Exit;
      end;
    //
    edFileName.Text := XlFileName;
    OpenExcelFile(XlFileName);
  end;
end;

function TmstMPExcelDialogForm.CheckDataParams(): Boolean;
var
  I: Integer;
  S: string;
  ColName: string;
  ColNum1: Integer;
  ColNum2: Integer;
  ColNum3: Integer;
  ColX: Integer;
  ColY: Integer;
  ColLayer: Integer;
  DummyInt: Integer;
  XMax: Double;
  YMax: Double;
  X: Double;
  Y: Double;
begin
  Result := False;
  // если не назначены колонки номеров, то генерируем ошибку
  GetAssignedCol(KeyNum1, ColName, ColNum1);
  if ColNum1 < 0 then
  begin
    ShowMessage('Не назначена обязательная колонка "' + KeyNum1 + '"');
    ValueListEditor1.Row := 1;
    ValueListEditor1.SetFocus;
    Exit;
  end;
  GetAssignedCol(KeyNum2, ColName, ColNum2);
  if ColNum2 < 0 then
  begin
    ShowMessage('Не назначена обязательная колонка "' + KeyNum2 + '"');
    ValueListEditor1.Row := 2;
    ValueListEditor1.SetFocus;
    Exit;
  end;
  GetAssignedCol(KeyNum3, ColName, ColNum3);
  if ColNum3 < 0 then
  begin
    ShowMessage('Не назначена обязательная колонка "' + KeyNum3 + '"');
    ValueListEditor1.Row := 3;
    ValueListEditor1.SetFocus;
    Exit;
  end;
  // если не назначены колонки координат, то генерируем ошибку
  GetAssignedCol(KeyX, ColName, ColX);
  if ColX < 0 then
  begin
    ShowMessage('Не назначена обязательная колонка "' + KeyX + '"');
    ValueListEditor1.Row := 4;
    ValueListEditor1.SetFocus;
    Exit;
  end;
  GetAssignedCol(KeyY, ColName, ColY);
  if ColY < 0 then
  begin
    ShowMessage('Не назначена обязательная колонка "' + KeyY + '"');
    ValueListEditor1.Row := 5;
    ValueListEditor1.SetFocus;
    Exit;
  end;
  GetAssignedCol(KeyLayer, ColName, ColLayer);
  if ColLayer < 0 then
  begin
    ShowMessage('Не назначена обязательная колонка "' + KeyLayer + '"');
    ValueListEditor1.Row := 6;
    ValueListEditor1.SetFocus;
    Exit;
  end;
  // пробегаем по данным
  XMax := -1000000;
  YMax := -1000000;
  for I := FSkipRows to Length(FData) - 1 do
  begin
    // если номера указаны не как номера, то генерируем ошибку
    S := FData[I, ColNum1 - 1];
    if not TryStrToInt(S, DummyInt) then
    begin
      ShowMessage('Неверное значение номера объекта!');
      StringGrid1.Row := I;
      StringGrid1.Col := ColNum1;
      Exit;
    end;
    S := FData[I, ColNum2 - 1];
    if not TryStrToInt(S, DummyInt) then
    begin
      ShowMessage('Неверное значение номера подобъекта!');
      StringGrid1.Row := I;
      StringGrid1.Col := ColNum2;
      Exit;
    end;
    S := FData[I, ColNum3 - 1];
    if not TryStrToInt(S, DummyInt) then
    begin
      ShowMessage('Неверное значение номера точки!');
      StringGrid1.Row := I;
      StringGrid1.Col := ColNum3;
      Exit;
    end;
    // смотрим координаты, если они указаны неверно, то генериреум ошибку
    S := FData[I, ColX - 1];
    if not StrIsFloat(S, X) then
    begin
      ShowMessage('Неверное значение координаты X!');
      StringGrid1.Row := I;
      StringGrid1.Col := ColX;
      Exit;
    end;
    if XMax < X then
      XMax := X;
    S := FData[I, ColY - 1];
    if not StrIsFloat(S, Y) then
    begin
      ShowMessage('Неверное значение координаты Y!');
      StringGrid1.Row := I;
      StringGrid1.Col := ColY;
      Exit;
    end;
    if YMax < Y then
      YMax := Y;
  end;
  //
  FExchangeXY := False;
  FMCK36 := False;
  if YMax > 1000000 then
  begin
    if XMax > 400000 then
      FMCK36 := True;
  end
  else
  if XMax > 1000000 then
  begin
    if YMax > 400000 then
    begin
      FExchangeXY := True;
      FMCK36 := True;
    end;
  end;
  //
  Result := True;
end;

procedure TmstMPExcelDialogForm.CheckFields(const aRow: Integer; var aRowRec: TRowRec);
var
  ColName: string;
  ColNum: Integer;
  Dbl: Double;
begin
  GetAssignedCol(KeyNum1, ColName, ColNum);
  aRowRec.NObj := StrToInt(FData[aRow][ColNum]);
  GetAssignedCol(KeyNum2, ColName, ColNum);
  aRowRec.NSubObj := StrToInt(FData[aRow, ColNum]);
  GetAssignedCol(KeyNum3, ColName, ColNum);
  if ColNum > 0 then
    aRowRec.NPt := StrToInt(FData[aRow, ColNum])
  else
    aRowRec.NPt := 0;
  GetAssignedCol(KeyX, ColName, ColNum);
  StrIsFloat(FData[aRow, ColNum], Dbl);
  aRowRec.X := Dbl;
  GetAssignedCol(KeyY, ColName, ColNum);
  StrIsFloat(FData[aRow, ColNum], Dbl);
  aRowRec.Y := Dbl;
  GetAssignedCol(KeyLayer, ColName, ColNum);
  if ColNum > 0 then
    aRowRec.Category := FData[aRow, ColNum]
  else
    aRowRec.Category := '';
  GetAssignedCol(KeyAddr, ColName, ColNum);
  if ColNum > 0 then
    aRowRec.Addr := FData[aRow, ColNum]
  else
    aRowRec.Addr := '';
  GetAssignedCol(KeyNumProj, ColName, ColNum);
  if ColNum > 0 then
    aRowRec.NumProj := FData[aRow, ColNum]
  else
    aRowRec.NumProj := '';
  GetAssignedCol(KeyNameProj, ColName, ColNum);
  if ColNum > 0 then
    aRowRec.NameProj := FData[aRow, ColNum]
  else
    aRowRec.NameProj := '';
  GetAssignedCol(KeyRotangle, ColName, ColNum);
  if ColNum > 0 then
    aRowRec.Rotangle := FData[aRow, ColNum]
  else
    aRowRec.Rotangle := '';
  GetAssignedCol(KeyDiam, ColName, ColNum);
  if ColNum > 0 then
    aRowRec.Diam := FData[aRow, ColNum]
  else
    aRowRec.Diam := '';
  GetAssignedCol(KeyPipeCount, ColName, ColNum);
  if ColNum > 0 then
    aRowRec.PipeCount := FData[aRow, ColNum]
  else
    aRowRec.PipeCount := '';
  GetAssignedCol(KeyVoltage, ColName, ColNum);
  if ColNum > 0 then
    aRowRec.Voltage := FData[aRow, ColNum]
  else
    aRowRec.Voltage := '';
  GetAssignedCol(KeyMaterial, ColName, ColNum);
  if ColNum > 0 then
    aRowRec.Material := FData[aRow, ColNum]
  else
    aRowRec.Material := '';
  GetAssignedCol(KeyTop, ColName, ColNum);
  if ColNum > 0 then
    aRowRec.Top := FData[aRow, ColNum]
  else
    aRowRec.Top := '';
  GetAssignedCol(KeyBottom, ColName, ColNum);
  if ColNum > 0 then
    aRowRec.Bottom := FData[aRow, ColNum]
  else
    aRowRec.Bottom := '';
  GetAssignedCol(KeyFloor, ColName, ColNum);
  if ColNum > 0 then
    aRowRec.Floor := FData[aRow, ColNum]
  else
    aRowRec.Floor := '';
  GetAssignedCol(KeyOwner, ColName, ColNum);
  if ColNum > 0 then
    aRowRec.Owner := FData[aRow, ColNum]
  else
    aRowRec.Owner := '';
end;

function TmstMPExcelDialogForm.CheckLayer(MpObj: TmstMPObject): Boolean;
begin
  Result := FMP.Classifier.CategoryNames.IndexOf(MpObj.TempСategory) >= 0;
end;

function TmstMPExcelDialogForm.CheckObjectLayers: Boolean;
var
  I, J: Integer;
  MpObj: TmstMPObject;
  IdList: TIntegerList;
  CatId: Integer;
begin
  Result := False;
  //
  for I := 0 to MPObjectCount - 1 do
  begin
    MpObj := MPObjects[I];
    J := FMP.Classifier.CategoryNames.IndexOf(MpObj.TempСategory);
    if J >= 0 then
    begin
      CatId := Integer(FMP.Classifier.CategoryNames.Objects[J]);
      MpObj.MPLayerId := CatId;
      IdList := FMP.Classifier.GetClassIdList(CatId);
      try
        MpObj.MpClassId := IdList[0];
      finally
        IdList.Free;
      end;
    end;
  end;
//  //
//  LayerNames := TStringList.Create;
//  IdList := FMP.Classifier.GetClassIdList();
//  try
//    for I := 0 to IdList.Count - 1 do
//    begin
//      S := FMP.Classifier.GetClassName(IdList[I]);
//      LayerNames.Add(AnsiUpperCase(S));
//    end;
//    //
//    for I := 0 to MPObjectCount - 1 do
//    begin
//      MpObj := MPObjects[I];
//      J := LayerNames.IndexOf(AnsiUpperCase(MpObj.TempLayer));
//      if J < 0 then
//      begin
//        FoundMIssingLayers := True;
//        MpObj.TempLayerId := 0;
//      end;
//    end;
//  finally
//    IdList.Free;
//    LayerNames.Free;
//  end;
  //
  Result := True;
end;

procedure TmstMPExcelDialogForm.CopySemanticFields(Source, Target: TmstMPObject);
begin
  if Source = nil then
    Exit;
  Target.TempСategory := Source.TempСategory;
  Target.Address := Source.Address;
  Target.DocNumber := Source.DocNumber;
  Target.ProjectName := Source.ProjectName;
  Target.Rotation := Source.Rotation;
  Target.Diameter := Source.Diameter;
  Target.PipeCount := Source.PipeCount;
  Target.Voltage := Source.Voltage;
  Target.Material := Source.Material;
  Target.Top := Source.Top;
  Target.Bottom := Source.Bottom;
  Target.Floor := Source.Floor;
  Target.Owner := Source.Owner;
end;

function TmstMPExcelDialogForm.Execute(MP: ImstMPModule; aImport: ImstMPExcelImport): Boolean;
begin
  SetLength(FData, 0);
  FMP := MP;
  Result := False;
  if ShowModal = mrOK then
    Result := True;
end;

procedure TmstMPExcelDialogForm.FormCreate(Sender: TObject);
begin
  FList := TObjectList.Create;
  PrepareColumnsGrid();
end;

procedure TmstMPExcelDialogForm.FormDestroy(Sender: TObject);
begin
  FList.Free;
end;

procedure TmstMPExcelDialogForm.GetAssignedCol(const aKey: string; var ColName: string; var ColNum: Integer);
begin
  ColNum := -1;
  ColName := ValueListEditor1.Values[aKey];
  if Trim(ColName) = '' then
    Exit;
  ColNum := GetColNum(ColName);
end;

function TmstMPExcelDialogForm.GetColName(const Col: Integer): string;
var
  I: Integer;
  O: Integer;
begin
  Result := '';
  I := Col;
  while I > 0 do
  begin
    O := Col mod 100;
    Result := Result + LETTERS[O];
    I := I div 100;
  end;
end;

function TmstMPExcelDialogForm.GetColNum(const ColName: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 1 to StringGrid1.ColCount - 1 do
    if StringGrid1.Cells[I, 0] = ColName then
    begin
      Result := I;
      Exit;
    end;
end;

function TmstMPExcelDialogForm.GetMPObjectCount: Integer;
begin
  Result := FList.Count;
end;

function TmstMPExcelDialogForm.GetMPObjects(Index: Integer): TmstMPObject;
begin
  Result := TmstMPObject(FList[Index]);
end;

function TmstMPExcelDialogForm.OpenExcelFile(const XlFileName: string): Boolean;
var
  I, J: integer;
  ExcelApp: Variant;
  CellRange: OLEVariant;
  WorkSheet: OLEVariant;
  S: string;
begin
  Result := False;
  //
  ExcelApp := CreateOleObject('Excel.Application');
  try
    ExcelApp.Application.WorkBooks.Add(XlFileName);
    //открываем книгу
    ExcelApp.Workbooks.Open(XlFileName);
    //получаем активный лист
    WorkSheet := ExcelApp.ActiveWorkbook.ActiveSheet;
    //определяем количество строк и столбцов таблицы
    FRowCnt := WorkSheet.UsedRange.Rows.Count;
    FColCnt := WorkSheet.UsedRange.Columns.Count;
    CellRange := WorkSheet.UsedRange.Value;
    //
    SetLength(FData, FRowCnt);
    for I := 0 to FRowCnt - 1 do
      SetLength(FData[I], FColCnt);
    for I := 0 to FRowCnt - 1 do
      for J := 0 to FColCnt - 1 do
      begin
        S := CellRange[I + 1, J + 1];
        FData[I, J] := S;
      end;
    //
    ReloadGrid();
    Result := True;
  finally
    ExcelApp.Quit;
    ExcelApp := Unassigned;
  end;
end;

procedure TmstMPExcelDialogForm.PrepareColumnsGrid;
begin
//  grdColumns.ColCount := 2;
//  grdColumns.RowCount := 19;
//  grdColumns.Cells[0, 0] := 'Поле данных';
//  grdColumns.Cells[1, 0] := 'Колонка файла';
//  grdColumns.Cells[0, 1] := 'Номер объекта';
//  grdColumns.Cells[0, 2] := 'Номер подобъекта';
//  grdColumns.Cells[0, 3] := 'Номер точки';
//  grdColumns.Cells[0, 4] := 'Координата X';
//  grdColumns.Cells[0, 5] := 'Координата Y';
//  grdColumns.Cells[0, 6] := 'Слой';
//  grdColumns.Cells[0, 7] := 'Адрес';
//  grdColumns.Cells[0, 8] := 'Номер проекта';
//  grdColumns.Cells[0, 9] := 'Название проекта';
//  grdColumns.Cells[0, 10] := 'Угол поворота';
//  grdColumns.Cells[0, 11] := 'Диаметр';
//  grdColumns.Cells[0, 12] := 'Количество проводов/труб';
//  grdColumns.Cells[0, 13] := 'Напряжение';
//  grdColumns.Cells[0, 14] := 'Материал';
//  grdColumns.Cells[0, 15] := 'Верх';
//  grdColumns.Cells[0, 16] := 'Низ';
//  grdColumns.Cells[0, 17] := 'Дно';
//  grdColumns.Cells[0, 18] := 'Балансодержатель';
  //
//  ValueListEditor1.TitleCaptions.Text := 'Свойство объекта'#13'Колонка файла';
//  AddColumnToGrid('Номер объекта');
//  AddColumnToGrid('Номер подобъекта');
//  AddColumnToGrid('Номер точки');
//  AddColumnToGrid('Координата X');
//  AddColumnToGrid('Координата Y');
//  AddColumnToGrid('Слой');
//  AddColumnToGrid('Адрес');
//  AddColumnToGrid('Номер проекта');
//  AddColumnToGrid('Название проекта');
//  AddColumnToGrid('Угол поворота');
//  AddColumnToGrid('Диаметр');
//  AddColumnToGrid('Количество проводов/труб');
//  AddColumnToGrid('Напряжение');
//  AddColumnToGrid('Материал');
//  AddColumnToGrid('Верх');
//  AddColumnToGrid('Низ');
//  AddColumnToGrid('Дно');
//  AddColumnToGrid('Балансодержатель');
end;

function TmstMPExcelDialogForm.PrepareObjectList: Boolean;
var
  StartRow: Integer;
  EndRow: Integer;
  I: Integer;
  RowRec1: TRowRec;
  RowRec2: TRowRec;
  FoundNewObj: Boolean;
  FoundNewSubObj: Boolean;
  NewObj: TmstMPObject;
  Ent: TEzPolyLine;
  MpObj: TmstMPObject;
  J: Integer;
begin
  Result := False;
  FList.Clear;
  //
  // перебираем строчки в данных
  // строчку разбираме по колонкам
  // берём из настроек колонок номер столбца
  // из сооответствующего столбца берём данные и анализируем их
  StartRow := FSkipRows;
  EndRow := Length(FData) - 1;
  //
  FCurrObj := nil;
  for I := StartRow to EndRow do
  begin
    // проверяем поля
    CheckFields(I, RowRec2);
    // если проверили, то дальше
    FoundNewObj := FCurrObj = nil;
    // берём текущий номер объекта
    // сравниваем с новым
    // сравниваем номер подобъекта
    if not FoundNewObj then
      FoundNewObj := (RowRec1.NObj <> RowRec2.NObj);
    FoundNewSubObj := (RowRec1.NSubObj <> RowRec2.NSubObj);
    // если не совпадают, то новый объект
    if FoundNewObj or FoundNewSubObj then
    begin
      if Assigned(FCurrObj) then
        if FCurrObj.TempPoints.Count < 2 then
        begin
          ShowMessage('Объекту назначена всего одна точка!');
          StringGrid1.Row := I - 1;
          StringGrid1.Col := 1;
          Exit;
        end;
      //
      NewObj := TmstMPObject.Create();
      if FoundNewSubObj then
        if FoundNewObj then
        begin
          SetSemanticFields(NewObj, RowRec2);
          if not CheckLayer(NewObj) then
          begin
            ShowMessage('Объекту назначен неизвестный слой!');
            StringGrid1.Row := I - 1;
            StringGrid1.Col := 1;
            Exit;
          end;
        end
        else
          CopySemanticFields(FCurrObj, NewObj);
      //
      if FExchangeXY then
        NewObj.TempPoints.Add(RowRec2.Y, RowRec2.X)
      else
        NewObj.TempPoints.Add(RowRec2.X, RowRec2.Y);
      //
      if Assigned(FCurrObj) then
        FList.Add(FCurrObj);
      FCurrObj := NewObj;
      RowRec1 := RowRec2;
    end;
  end;
  //
  if FCurrObj <> nil then
    if FList.Last <> FCurrObj then
      FList.Add(FCurrObj);
  //
  for I := 0 to FList.Count - 1 do
  begin
    MpObj := MPObjects[I];
    // создаём энтити
    Ent := TEzPolyLine.Create(1);
    for J := 0 to MpObj.TempPoints.Count - 1 do
      Ent.Points.Add(MpObj.TempPoints[J]);
    if FMCK36 then
      TEzCSConverter.EntityToVrn(Ent);
    MpObj.EzId := Integer(Ent.EntityId);
  end;
  //
  Result := TRue;
end;

function TmstMPExcelDialogForm.ProcessFileName(var XlFileName: string; const Ext: string): Boolean;
var
  A: string;
begin
  A := ChangeFileExt(XlFileName, Ext);
  Result := FileExists(A);
  if Result then
    XlFileName := A;
end;

procedure TmstMPExcelDialogForm.ReloadGrid;
var
  I, J: Integer;
begin
  StringGrid1.RowCount := FRowCnt + 1;
  StringGrid1.ColCount := FColCnt + 1;
  // заголовки
  for I := 1 to FColCnt do
    StringGrid1.Cells[I, 0] := GetColName(I);
  for I := 1 to FRowCnt do
    StringGrid1.Cells[0, I] := IntToStr(I);
  //выводим данные в таблицу
  for I := 0 to FRowCnt - 1 do
    for J := 0 to FColCnt - 1 do
      StringGrid1.Cells[J + 1, I + 1] := FData[I, J];
//  // если все колонки пустые, то заполняем по порядку
end;

procedure TmstMPExcelDialogForm.SetSemanticFields(aMPObj: TmstMPObject; const aRowRec: TRowRec);
var
  I: Integer;
begin
//  aMPObj.;
//  aMPObj. :=aRowRec.NObj;
//  aMPObj. :=aRowRec.NSubObj;
//  aMPObj. :=aRowRec.NPt;
//  aMPObj. :=aRowRec.X;
//  aMPObj. :=aRowRec.Y;
  aMPObj.TempСategory := aRowRec.Category;
  aMPObj.Address := aRowRec.Addr;
  aMPObj.DocNumber := aRowRec.NumProj;
  aMPObj.ProjectName := aRowRec.NameProj;
  if TryStrToInt(aRowRec.Rotangle, I) then
    aMPObj.Rotation := I;
  if TryStrToInt(aRowRec.Diam, I) then
    aMPObj.Diameter := I;
  if TryStrToInt(aRowRec.PipeCount, I) then
    aMPObj.PipeCount := I;
  if TryStrToInt(aRowRec.Voltage, I) then
    aMPObj.Voltage := I;
  aMPObj.Material := aRowRec.Material;
  aMPObj.Top := aRowRec.Top;
  aMPObj.Bottom := aRowRec.Bottom;
  aMPObj.Floor := aRowRec.Floor;
  aMPObj.Owner := aRowRec.Owner;
end;

procedure TmstMPExcelDialogForm.spnSkipRowsChange(Sender: TObject);
begin
  FSkipRows := Round(spnSkipRows.Value);
  ReloadGrid();
end;

procedure TmstMPExcelDialogForm.ValueListEditor1GetPickList(Sender: TObject; const KeyName: string; Values: TStrings);
var
  I: Integer;
  S: string;
begin
  Values.Add(' ');
  for I := 1 to StringGrid1.ColCount - 1 do
  begin
    S := StringGrid1.Cells[I, 0];
    Values.Add(S);
  end;
end;

end.
