unit uMStDialogMPIntersections;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ToolWin, ImgList, Menus,
  //
  JvExForms, JvScrollBox, JvScrollPanel, JvExControls, JvSpeedButton, JvExStdCtrls, JvGroupBox,
  //
  uGeoTypes,
  uMStFramesMPIntersectItem, uEzIntersection, uEzGeometry, uMStClassesProjectsMP,
  uMStClassesProjectsMPIntersect, uMStModuleApp, uMStClassesMPIntf, uMStKernelClasses,
  uMStClassesProjects;

type
  TMStMPIntersectionsDialog = class(TForm, ImstMPObjEventSubscriber, ImstCoordView)
    Button1: TButton;
    JvGroupBox1: TJvGroupBox;
    JvGroupBox2: TJvGroupBox;
    JvScrollBox1: TJvScrollBox;
    Label1: TLabel;
    edID: TEdit;
    edAddress: TEdit;
    Label3: TLabel;
    edProjectNum: TEdit;
    Label5: TLabel;
    JvSpeedButton3: TJvSpeedButton;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N3: TMenuItem;
    N2: TMenuItem;
    ImageList1: TImageList;
    btnRefresh: TJvSpeedButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
  private
    FFound: TmpIntersectionInfo;
    FFrames: TList;
    FMP: ImstMPModule;
    FObjList: ImstMPModuleObjList;
    procedure AddListItems(const Idx: Integer);
    function GetObjText(const ObjId: Integer): string;
    procedure GenerateGUI();
    //
    procedure DisplayIntersectItem(Sender: TmstMPIntersectItemFrame; const ObjId: Integer);
    procedure DisplayIntersectItemProperties(Sender: TmstMPIntersectItemFrame; const ObjId: Integer);
    procedure LocateIntersectItem(Sender: TmstMPIntersectItemFrame; const ObjId: Integer);
    procedure SetDisplayingItem(Sender: TmstMPIntersectItemFrame; const ObjId: Integer);
  private
    procedure ClearFrames();
    procedure DoFullUpdate();
    procedure RemoveFrame(const ObjId: Integer);
    procedure UpdateSemanticsFrame(const ObjId: Integer);
  private
    // ImstMPObjEventSubscriber
    procedure Notify(const ObjId: Integer; Op: TRowOperation);
  private
    // ImstCoordView
    procedure CoordSystemChanged(const Value: TCoordSystem);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    //
    procedure Prepare(aMP: ImstMPModule; aObjList: ImstMPModuleObjList; aFound: TmpIntersectionInfo);
    procedure UpdateData(const ObjId: Integer; Obj1, Obj2: TmstMPObject);
  end;

implementation

{$R *.dfm}

{ TMStMPIntersectionsDialog }

procedure TMStMPIntersectionsDialog.AddListItems(const Idx: Integer);
var
  Frame: TmstMPIntersectItemFrame;
  I: Integer;
  ObjId: Integer;
  Lst: TEzIntersectionList;
  Itm: TEzIntersection;
  S: string;
  TheObj: TmstMPObject;
begin
  Frame := nil;
  ObjId := FFound.ObjectIds[Idx];
  Lst := FFound.IntersectLists[Idx];
  for I := 0 to Lst.Count - 1 do
  begin
    Itm := Lst.Items[I];
    //
    Frame := TmstMPIntersectItemFrame.Create(Self);
    Frame.Name := Frame.Name + IntToStr(FFrames.Count);
    Frame.ObjId := ObjId;
    S := SegmentsArrangementNames[Itm.Arragement];
    S[1] := AnsiUpperCase(S[1])[1];
    Frame.Title := IntToStr(Idx + 1) + '. ' + S;
    TheObj := FMP.GetObjByDbId(ObjId, False);
    if TheObj = nil then
    begin
      S := 'данные отсутствуют';
      Frame.Address := S;
      Frame.ProjectNumber := S;
    end
    else
    begin
      Frame.Address := TheObj.Address;
      Frame.ProjectNumber := TheObj.DocNumber;
    end;
    Frame.CoordSystem := mstClientAppModule.ViewCoordSystem;
    case Itm.Arragement of
      saCollinear:
        begin
          // не пересекаются
          // точки не назначаем
        end;
      saCommonPart: 
        begin
          // должно быть две точки
          Frame.Point1 := Itm.Point1;
          Frame.Point2 := Itm.Point2;
        end;
      saEqual:
        begin
          // совпадают - есть две точки
          Frame.Point1 := Itm.Point1;
          Frame.Point2 := Itm.Point2;
        end;
      saIntersection:
        begin
          // пересечение - одна точка
          Frame.Point1 := Itm.Point1;
        end;
      saTouch:
        begin
          // пересечение - одна точка
          Frame.Point1 := Itm.Point1;

        end;
      saConnect:
        begin
          // пересечение - одна точка
          Frame.Point1 := Itm.Point1;

        end;
    end;
    //
//    Self.InsertControl(Frame);
    Frame.Parent := JvScrollBox1;
    Frame.Width := Self.ClientWidth - 20;
    Frame.Left := 3;
    Frame.Top := Frame.Height * FFrames.Count + 2;
    FFrames.Add(Frame);
//    Frame.Align := alTop;
//    Frame.Visible := True;
    Frame.OnDisplayItem := DisplayIntersectItem;
    Frame.OnItemProperties := DisplayIntersectItemProperties;
    Frame.OnLocateItem := LocateIntersectItem;
  end;
  //
  if Assigned(Frame) then
  begin
//    JvScrollBox1.VertScrollBar.Size := Frame.Top + Frame.Height;
  end;
end;

procedure TMStMPIntersectionsDialog.btnRefreshClick(Sender: TObject);
begin
  DoFullUpdate();
end;

procedure TMStMPIntersectionsDialog.Button1Click(Sender: TObject);
begin
  TMPSettings.ClearIntersection();
  mstClientAppModule.RepaintViewports;
  Close;
end;

procedure TMStMPIntersectionsDialog.ClearFrames;
var
  I: Integer;
  Tmp: TObject;
begin
  for I := FFrames.Count - 1 downto 0 do
  begin
    Tmp := FFrames[I];
    Tmp.Free;
  end;
  FFrames.Clear;
end;

procedure TMStMPIntersectionsDialog.CoordSystemChanged(const Value: TCoordSystem);
var
  I: Integer;
  Frame: TmstMPIntersectItemFrame;
begin
  for I := 0 to FFrames.Count - 1 do
  begin
    Frame := FFrames[I];
    Frame.CoordSystem := Value;
  end;
end;

constructor TMStMPIntersectionsDialog.Create(AOwner: TComponent);
begin
  inherited;
  FFrames := TList.Create;
end;

destructor TMStMPIntersectionsDialog.Destroy;
begin
  FFrames.Free;
  inherited;
end;

procedure TMStMPIntersectionsDialog.DisplayIntersectItem(Sender: TmstMPIntersectItemFrame; const ObjId: Integer);
begin
  SetDisplayingItem(Sender, ObjId);
  FMP.LoadToGis(ObjId, True, False);
end;

procedure TMStMPIntersectionsDialog.DisplayIntersectItemProperties(Sender: TmstMPIntersectItemFrame; const ObjId: Integer);
begin
  SetDisplayingItem(Sender, ObjId);
  FMP.EditObjProperties(ObjId);
end;

procedure TMStMPIntersectionsDialog.DoFullUpdate;
var
  TmpFound: TmpIntersectionInfo;
  TheObj: TmstMPObject;
  S: string;
begin
  if not FMP.CanFindIntersections(FFound.ObjId) then
  begin
    ShowMessage('Поиск пересечений не доступен для объектов данного типа!');
    // Удалить все фреймы
    // в панели объекта написать - ошибка
    Exit;
  end;
  // ищем список объектов
  // - архив не ищем
  // - ищем среди всех, а не только загруженных
  TmpFound := FMP.FindIntersects(FFound.ObjId);
  try
    if TmpFound.Count = 0 then
    begin
      // если не нашли, то показываем сообщение
      ShowMessage('Пересечения не обнаружены!');
      // Удалить все фреймы
      // в панели объекта написать - не обнаружено
    end
    else
    begin
      // если нашли, то показываем окно
      FFound.Free;
      FFound := TmpFound;
      //
      TheObj := FMP.GetObjByDbId(FFound.ObjId, False);
      if TheObj = nil then
      begin
        S := 'данные отсутствуют';
        edAddress.Text := S;
        edProjectNum.Text := S;
      end
      else
      begin
        edAddress.Text := TheObj.Address;
        edProjectNum.Text := TheObj.DocNumber;
      end;
      //
      ClearFrames();
      GenerateGUI();
    end;
  finally
//    FreeAndNil(Found);
  end;
end;

procedure TMStMPIntersectionsDialog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FObjList.UnSubscribe(Self as ImstMPObjEventSubscriber);
  mstClientAppModule.CoordViews.UnSubscribe(Self as ImstCoordView);
  FMP.IntersectionsDialogClosed(Self);
  FreeAndNil(FFound);
end;

procedure TMStMPIntersectionsDialog.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  mstClientAppModule.AppSettings.WriteFormPosition(Application, Self);
end;

procedure TMStMPIntersectionsDialog.FormCreate(Sender: TObject);
begin
  mstClientAppModule.AppSettings.ReadFormPosition(Application, Self);
end;

procedure TMStMPIntersectionsDialog.FormShow(Sender: TObject);
begin
  GenerateGUI();
end;

procedure TMStMPIntersectionsDialog.GenerateGUI;
var
  I: Integer;
begin
  for I := 0 to FFound.Count - 1 do
    AddListItems(I);
end;

function TMStMPIntersectionsDialog.GetObjText(const ObjId: Integer): string;
var
  TheObj: TmstMPObject;
begin
  TheObj := FMP.GetObjByDbId(ObjId, False);
  if TheObj = nil then
    Result := 'данные отсутствуют'
  else
  begin
    Result := TheObj.MPObjectGuid + sLineBreak;
    Result := Result + TheObj.Address + sLineBreak;
    Result := Result + 'Проект №: ' + TheObj.DocNumber + sLineBreak;
    Result := Result + 'Заявка №: ' + TheObj.RequestNumber + sLineBreak; 
  end;
//  Result := 'Found ' + IntToStr(Idx);
end;

procedure TMStMPIntersectionsDialog.LocateIntersectItem(Sender: TmstMPIntersectItemFrame; const ObjId: Integer);
var
  ObjList: ImstMPModuleObjList;
  Browser: ImstMPBrowser;
begin
  SetDisplayingItem(Sender, ObjId);
  //
  ObjList := mstClientAppModule.ObjList;
  Browser := ObjList.Browser();
  if Assigned(Browser) then
    Browser.LocateObj(ObjId);
end;

procedure TMStMPIntersectionsDialog.N1Click(Sender: TObject);
begin
  FMP.LoadToGis(FFound.ObjId, True, False);
end;

procedure TMStMPIntersectionsDialog.N2Click(Sender: TObject);
begin
  FMP.EditObjProperties(FFound.ObjId);
end;

procedure TMStMPIntersectionsDialog.N3Click(Sender: TObject);
var
  ObjList: ImstMPModuleObjList;
  Browser: ImstMPBrowser;
begin
  ObjList := mstClientAppModule.ObjList;
  Browser := ObjList.Browser();
  if Assigned(Browser) then
    Browser.LocateObj(FFound.ObjId);
end;

procedure TMStMPIntersectionsDialog.Notify(const ObjId: Integer; Op: TRowOperation);
begin
  case Op of
    rowInsert:
      begin
      end;
    rowUpdate:
      begin
        UpdateSemanticsFrame(ObjId);
      end;
    rowDelete:
      begin
        RemoveFrame(ObjId);
      end;
  end;
end;

procedure TMStMPIntersectionsDialog.Prepare;
var
  TheObj: TmstMPObject;
  S: string;
begin
  FMP := aMP;
  FObjList := aObjList;
  FFound := aFound;
  //
  mstClientAppModule.CoordViews.Subscribe(Self as ImstCoordView);
  //
  edID.Text := IntToStr(aFound.ObjId);
  TheObj := FMP.GetObjByDbId(aFound.ObjId, False);
  if TheObj = nil then
  begin
    S := 'данные отсутствуют';
    edAddress.Text := S;
    edProjectNum.Text := S;
  end
  else
  begin
    edAddress.Text := TheObj.Address;
    edProjectNum.Text := TheObj.DocNumber;
  end;
  //
  FObjList.Subscribe(Self as ImstMPObjEventSubscriber);
end;

procedure TMStMPIntersectionsDialog.RemoveFrame(const ObjId: Integer);
var
  Frame: TmstMPIntersectItemFrame;
  I: Integer;
  S: string;
  TheObj: TmstMPObject;
begin
  if ObjId = FFound.ObjId then
  begin
    S := 'данные отсутствуют';
    edAddress.Text := S;
    edProjectNum.Text := S;
    Exit;
  end;
  //
  for I := 0 to FFrames.Count - 1 do
  begin
    Frame := FFrames[I];
    if Frame.ObjId = ObjId then
    begin
      TheObj := FMP.GetObjByDbId(ObjId, False);
      if TheObj = nil then
      begin
        S := 'данные отсутствуют';
        Frame.Address := S;
        Frame.ProjectNumber := S;
      end;
      Exit;
    end;
  end;
end;

procedure TMStMPIntersectionsDialog.SetDisplayingItem(Sender: TmstMPIntersectItemFrame; const ObjId: Integer);
var
  I: Integer;
  Tmp: TmstMPIntersectItemFrame;
begin
  for I := 0 to FFrames.Count - 1 do
  begin
    Tmp := FFrames[I];
    Tmp.Displaying := Tmp = Sender;
  end;
  TMPSettings.FIntersectObjId := ObjId;
  TMPSettings.FIntersectPt1Empty := Sender.IsPoint1Empty;
  if not TMPSettings.FIntersectPt1Empty then
    TMPSettings.FIntersectPt1 := Sender.Point1;
  TMPSettings.FIntersectPt2Empty := Sender.IsPoint2Empty;
  if not TMPSettings.FIntersectPt2Empty then
    TMPSettings.FIntersectPt2 := Sender.Point2;
end;

procedure TMStMPIntersectionsDialog.UpdateData;
var
  I: Integer;
begin
  if ObjId = FFound.ObjId then
  begin
    DoFullUpdate();
    Exit;
  end;
  if Assigned(Obj1) and (Obj1.DatabaseId = FFound.ObjId) then
  begin
    DoFullUpdate();
    Exit;
  end;
  if Assigned(Obj2) and (Obj2.DatabaseId = FFound.ObjId) then
  begin
    DoFullUpdate();
    Exit;
  end;
  //
  if Assigned(Obj1) then
  begin
    I := FFound.IndexOfObjectId(Obj1.DatabaseId);
    if I >= 0 then
    begin
      DoFullUpdate();
      Exit;
    end;
  end;
  //
  if Assigned(Obj2) then
  begin
    I := FFound.IndexOfObjectId(Obj2.DatabaseId);
    if I >= 0 then
    begin
      DoFullUpdate();
      Exit;
    end;
  end;
end;

procedure TMStMPIntersectionsDialog.UpdateSemanticsFrame(const ObjId: Integer);
var
  Frame: TmstMPIntersectItemFrame;
  I: Integer;
  S: string;
  TheObj: TmstMPObject;
begin
  if ObjId = FFound.ObjId then
  begin
    TheObj := FMP.GetObjByDbId(ObjId, False);
    if TheObj = nil then
    begin
      S := 'данные отсутствуют';
      edAddress.Text := S;
      edProjectNum.Text := S;
    end
    else
    begin
      edAddress.Text := TheObj.Address;
      edProjectNum.Text := TheObj.DocNumber;
    end;
    Exit;
  end;
  //
  for I := 0 to FFrames.Count - 1 do
  begin
    Frame := FFrames[I];
    if Frame.ObjId = ObjId then
    begin
      TheObj := FMP.GetObjByDbId(ObjId, False);
      if TheObj = nil then
      begin
        S := 'данные отсутствуют';
        Frame.Address := S;
        Frame.ProjectNumber := S;
      end
      else
      begin
        Frame.Address := TheObj.Address;
        Frame.ProjectNumber := TheObj.DocNumber;
      end;
      Exit;
    end;
  end;
end;

end.
