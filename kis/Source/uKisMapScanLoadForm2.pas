unit uKisMapScanLoadForm2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtDlgs, Contnrs,
  //
  VirtualTrees,
  //
  uGC, uGeoTypes, uGeoUtils, uFileUtils,
  //
  uKisAppModule, uKisMapScanIntf, uKisImagesViewFactory, uKisScanOrders, uKisTakeBackFiles, uMapScanFiles,
  uKisConsts, uKisMapScans, uKisIntf, uKisImageViewer;

type
  TKisMapScanLoadForm2 = class(TForm)
    Label1: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    OpenPictureDialog1: TOpenDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    btnLoad: TBitBtn;
    btnCompare: TBitBtn;
    vstMaps: TVirtualStringTree;
    vstJoin: TVirtualStringTree;
    btnShowJoin: TBitBtn;
    btnAllUnchanged: TButton;
    procedure btnLoadClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure vstMapsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure vstMapsCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure vstMapsAddToSelection(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure btnCompareClick(Sender: TObject);
    procedure vstMapsColumnDblClick(Sender: TBaseVirtualTree;
      Column: TColumnIndex; Shift: TShiftState);
    procedure TabSheet2Show(Sender: TObject);
    procedure vstJoinColumnDblClick(Sender: TBaseVirtualTree;
      Column: TColumnIndex; Shift: TShiftState);
    procedure vstJoinGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure btnShowJoinClick(Sender: TObject);
    procedure btnAllUnchangedClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private type
    TFileInfoRec = record
      FileInfo: TTakeBackFileInfo;
    end;
    TJoinKind = (jkTop, jkRight, jkBottom, jkLeft);
    TJoinInfoRec = record
      Nomenclature1: ShortString;
      Nomenclature2: ShortString;
      Confirmed: Boolean;
      Kind: TJoinKind;
    end;
    TComboEditLink = class(TInterfacedObject, IVTEditLink)
    private
      FColumn: Integer;
      FEdit: TComboBox;
      FForm: TKisMapScanLoadForm2;
      FNode: PVirtualNode;
      FTree: TVirtualStringTree;
    private
      function BeginEdit: Boolean; stdcall;
      function CancelEdit: Boolean; stdcall;
      function EndEdit: Boolean; stdcall;
      function GetBounds: TRect; stdcall;
      function PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean; stdcall;
      procedure ProcessMessage(var Message: TMessage); stdcall;
      procedure SetBounds(R: TRect); stdcall;
    protected
      procedure UpdateComboItems; virtual; abstract;
      procedure UpdateNodeData; virtual; abstract;
      procedure EditCloseUp(Sender: TObject);
      procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
      procedure EditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    public
      constructor Create(aFrm: TKisMapScanLoadForm2);
    end;
    TChangesEditLink = class(TComboEditLink)
    protected
      procedure UpdateComboItems; override;
      procedure UpdateNodeData; override;
    end;
    TFileTypeEditLink = class(TComboEditLink)
    protected
      procedure UpdateComboItems; override;
      procedure UpdateNodeData; override;
    end;
  private
    FFiles: TTakeBackFiles;
    FScans: TMapScanArray;
    function CheckFileHash(): Boolean;
    function FindMap(const Nomenclature: String): TTakeBackFileInfo;
    procedure UpdateButtons(Node: PVirtualNode = nil);
    function CheckJoin1(const File1, File2: TTakeBackFileInfo; const DataKind: TJoinKind): Boolean;
    function CheckJoin2(const File1, File2: TTakeBackFileInfo; const DataKind: TJoinKind): Boolean;
  private
    FNewJoinCheck: Boolean;
    FNewChangesCheck: Boolean;
    function MapHalfRect(Kind: TJoinKind): TRect;
  public
    class function Execute(ScanOrder: TKisScanOrder;
      var Files: TTakeBackFiles; out Scans: TMapScanArray): Boolean;
  end;

implementation

{$R *.dfm}

{ TKisMapScanLoadForm }

procedure TKisMapScanLoadForm2.btnAllUnchangedClick(Sender: TObject);
var
  Node: PVirtualNode;
  Data: ^TFileInfoRec;
begin
  inherited;
  Node := vstMaps.GetFirst();
  while Assigned(Node) do
  begin
    Data := vstMaps.GetNodeData(Node);
    Data.FileInfo.Kind := tbNoChanges;
    Node := Node.NextSibling;
  end;
  vstMaps.Invalidate;
  UpdateButtons;
end;

procedure TKisMapScanLoadForm2.btnCompareClick(Sender: TObject);
var
  N: PVirtualNode;
  Data: ^TFileInfoRec;
  View: IKisImageCompareViewer;
  Editor: IKisTakeBackFileCompareEditor;
  B: Boolean;
begin
  /// показываем форму
  /// на форму надо загрузить оригинальный планшет
  /// ещё надо указать тип файлов заказчика - целый планшет или кусочки
  /// если целый планшет, то показать оригинал и новую версию
  /// если кусочки, то надо показывать такую картину:
  ///  1. оригинальный файл
  ///  2. сшивку оригинала и кусков
  ///  3. превьюшка области изменения на кусках - контуры всё разным цветом
  ///  4. все куски на белом фоне
  N := vstMaps.GetFirstSelected();
  if Assigned(N) then
  begin
    Data := vstMaps.GetNodeData(N);
    B := True;
    if FNewJoinCheck then
      if FNewChangesCheck then
      begin
        Editor := TKisImageViewerFactory.CreateTakeBackFileCompareEditor();
        B := Editor.Execute(AppModule, Data.FileInfo);
      end
      else
      begin
        View := TKisImageViewerFactory.CreateImageCompareViewer();
        B := View.CompareTakeBackFile(Data.FileInfo);
      end;
    if B then
    begin
      vstMaps.InvalidateNode(N);
      UpdateButtons;
    end;
  end;
end;

procedure TKisMapScanLoadForm2.btnLoadClick(Sender: TObject);
var
  ImgFile: String;
  Data: ^TFileInfoRec;
  Node: PVirtualNode;
begin
  Node := vstMaps.GetFirstSelected();
  if Assigned(Node) then
  begin
    Data := vstMaps.GetNodeData(Node);
    if Data.FileInfo.Kind <> tbNoChanges then //[tbEntireMap, tbZones] then
      if OpenPictureDialog1.Execute(Handle) then
      begin
        ImgFile := OpenPictureDialog1.Files[0];
        if FileExists(ImgFile) and (Data.FileInfo.FileName <> ImgFile) then
        begin
          Data.FileInfo.FileName := ImgFile;
          Data.FileInfo.Confirmed := False;
          vstMaps.InvalidateNode(Node);
          UpdateButtons;
        end;
      end;
  end;
end;

procedure TKisMapScanLoadForm2.btnOKClick(Sender: TObject);
begin
  if CheckFileHash() then
    ModalResult := mrOk;
end;

procedure TKisMapScanLoadForm2.btnShowJoinClick(Sender: TObject);

  procedure LogFileNotFound(const aNomen: string);
  var
    DataStr: TStringList;
    I: Integer;
  begin
    DataStr := TStringList.Create;
    DataStr.Forget;
    DataStr.Append('Список планшетов:');
    for I := 0 to FFiles.Count - 1 do
      DataStr.Append(FFiles[I].Nomenclature);
    AppModule.LogError('Файл ' + aNomen + ' не обнаружен!', 'No class',
      'No message', 'No class', 'TKisMapScanLoadForm2',
      DataStr
    );
  end;

var
  N: PVirtualNode;
  Data: ^TJoinInfoRec;
  File1, File2: TTakeBackFileInfo;
begin
  /// показываем форму
  /// на форму надо загрузить оригинальный планшет
  /// ещё надо указать тип файлов заказчика - целый планшет или кусочки
  /// если целый планшет, то показать оригинал и новую версию
  /// если кусочки, то надо показывать такую картину:
  ///  1. оригинальный файл
  ///  2. сшивку оригинала и кусков
  ///  3. превьюшка области изменения на кусках - контуры всё разным цветом
  ///  4. все куски на белом фоне
  N := vstJoin.GetFirstSelected();
  if Assigned(N) then
  begin
    Data := vstJoin.GetNodeData(N);
    File1 := FindMap(Data.Nomenclature1);
    File2 := FindMap(Data.Nomenclature2);
    if File1 = nil then
    begin
      MessageBox(Handle, PChar('Файл ' + Data.Nomenclature1 + ' не обнаружен!'), S_WARN, MB_OK);
      LogFileNotFound(Data.Nomenclature1);
      Exit;
    end;
    if File2 = nil then
    begin
      MessageBox(Handle, PChar('Файл ' + Data.Nomenclature2 + ' не обнаружен!'), S_WARN, MB_OK);
      LogFileNotFound(Data.Nomenclature2);
      Exit;
    end;
    //
    if not File1.Confirmed then
    begin
      MessageBox(Handle, PChar('Файл ' + File1.Nomenclature + ' не проверен!'), S_WARN, MB_OK);
      Exit;
    end;
    if not File2.Confirmed then
    begin
      MessageBox(Handle, PChar('Файл ' + File2.Nomenclature + ' не проверен!'), S_WARN, MB_OK);
      Exit;
    end;
    if (File1.Kind = tbNoChanges) and (File2.Kind = tbNoChanges) then
    begin
      MessageBox(Handle, 'Файлы не были изменены!', S_WARN, MB_OK);
      Exit;
    end;
    if FNewJoinCheck then
    begin
      Data.Confirmed := CheckJoin2(File1, File2, Data.Kind);
    end
    else
    begin
      Data.Confirmed := CheckJoin1(File1, File2, Data.Kind);
    end;
    vstJoin.InvalidateNode(N);
  end;
end;

function TKisMapScanLoadForm2.CheckFileHash: Boolean;
var
  I, A: Integer;
  NoChangesList: TStringList;
begin
  NoChangesList := TStringList.Create;
  NoChangesList.Forget;
  //
  SetLength(FScans, FFiles.Count);
  for I := 0 to FFiles.Count - 1 do
  begin
    FScans[I].Clear;
    FScans[I].PrepareFileName(AppModule, FFiles[I].Nomenclature);
    FScans[I].PrepareHash(sfkDB);
    FScans[I].TakeBackKind := FFiles[I].Kind;
    case FFiles[I].Kind of
      tbNoChanges:
        begin
          FScans[I].MD5HashNew := FScans[I].MD5HashOld;
          FScans[I].State := FScans[I].State + [sfsHashNew];
        end;
      tbEntireMap:
        begin
          FScans[I].FullFileName := FFiles[I].FileName;
          FScans[I].PrepareHash(sfkUpload);
        end;
      tbZones:
        begin
          FScans[I].FullFileName := FFiles[I].MergedFile;
          FScans[I].ComparedFileName := FFiles[I].FileName;
          FScans[I].PrepareHash(sfkUpload);
          FScans[I].PrepareHash(sfkDiff);
          FScans[I].State := FScans[I].State + [sfsDiffZone];
        end;
    end;
    if FFiles[I].Kind <> tbNoChanges then
      if FScans[I].MD5HashOld = FScans[I].MD5HashNew then
        NoChangesList.AddObject(FScans[I].Nomenclature, TObject(I));
  end;
  //
  Result := True;
//  Exit;
  if NoChangesList.Count > 0 then
  begin
    NoChangesList.Insert(0, 'Планшеты не имеют изменений: ');
    NoChangesList.Append('');
    NoChangesList.Append('Пометить их как "Без изменений"?');
    NoChangesList.Append('Да - пометить и принять, Нет - принять как есть,');
    NoChangesList.Append('Отмена - не помечать и не принимать');
    A := MessageBox(Handle, PChar(NoChangesList.Text), 'Внимание!', MB_YESNOCANCEL + MB_ICONQUESTION);
    case A of
    ID_YES:
      begin
        for I := 0 to NoChangesList.Count - 1 do
        begin
          A := Integer(NoChangesList.Objects[I]);
          FScans[A].Clear;
          FScans[A].PrepareFileName(AppModule, FFiles[A].Nomenclature);
          FScans[A].PrepareHash(sfkDB);
          FScans[A].TakeBackKind := tbNoChanges;
          FScans[A].MD5HashNew := FScans[A].MD5HashOld;
          FScans[A].State := FScans[A].State + [sfsHashNew];
        end;
      end;
    ID_NO:
      begin

      end;
    ID_CANCEL:
      Result := False;
    end;
  end;
end;

class function TKisMapScanLoadForm2.Execute(ScanOrder: TKisScanOrder;
  var Files: TTakeBackFiles; out Scans: TMapScanArray): Boolean;
var
  Frm: TKisMapScanLoadForm2;
  I, J: Integer;
  aFile: TTakeBackFileInfo;
  N: PVirtualNode;
  Data: ^TFileInfoRec;
  Data2: ^TJoinInfoRec;
  Map: TNomenclature;
  NeighbourMap, Map2: TNomenclature;
begin
  Frm := TKisMapScanLoadForm2.Create(Application);
  try
    Frm.Label1.Caption := 'Заявка №' + ScanOrder.OrderNumber + ' от ' + ScanOrder.OrderDate;
    Frm.Label1.Font.Style := [fsBold];
    //
    if not Assigned(Files) then
      Files := TTakeBackFiles.Create;
    //
    ScanOrder.Maps.First;
    while not ScanOrder.Maps.Eof do
    begin
      aFile := Files.Add;
      aFile.Nomenclature := ScanOrder.Maps.FieldByName(SF_NOMENCLATURE).AsString;;
      ScanOrder.Maps.Next;
    end;
    //
    for I := 0 to Files.Count - 1 do
    begin
      N := Frm.vstMaps.AddChild(nil);
      Data := Frm.vstMaps.GetNodeData(N);
      Data.FileInfo := Files.Items[I];
      Data.FileInfo.Kind := tbZones;
    end;
    //
    Frm.vstMaps.SortTree(0, sdAscending);
    //
    if Files.Count = 1 then
    begin
      N := Frm.vstMaps.GetFirst();
      Frm.vstMaps.Selected[N] := True;
    end;
    //
    Frm.UpdateButtons;
    //
    Frm.vstJoin.Clear;
    if Files.Count > 0 then
    begin
      for I := 0 to Files.Count - 1 do
      begin
        Map.Init(Files[I].Nomenclature, False);
        if Map.Valid then
        begin
          NeighbourMap := Map.Neighbour[n4Left];
          for J := I + 1 to Files.Count - 1 do
          begin
            Map2.Init(Files[J].Nomenclature, False);
            if (NeighbourMap.Top500 = Map2.Top500)
               and
               (NeighbourMap.Left500 = Map2.Left500)
            then
            begin
              N := Frm.vstJoin.AddChild(nil);
              Data2 := Frm.vstJoin.GetNodeData(N);
              Data2.Nomenclature1 := Files[I].Nomenclature;
              Data2.Nomenclature2 := Files[J].Nomenclature;//NeighbourMap.Nomenclature;
              Data2.Confirmed := False;
              Data2.Kind := jkRight;
            end;
          end;
          //
          NeighbourMap := Map.Neighbour[n4Right];
          for J := I + 1 to Files.Count - 1 do
          begin
            Map2.Init(Files[J].Nomenclature, False);
            if (NeighbourMap.Top500 = Map2.Top500)
               and
               (NeighbourMap.Left500 = Map2.Left500)
            then
            begin
              N := Frm.vstJoin.AddChild(nil);
              Data2 := Frm.vstJoin.GetNodeData(N);
              Data2.Nomenclature1 := Files[I].Nomenclature;
              Data2.Nomenclature2 := Files[J].Nomenclature;//NeighbourMap.Nomenclature;
              Data2.Confirmed := False;
              Data2.Kind := jkLeft;
            end;
          end;
          //
          NeighbourMap := Map.Neighbour[n4Top];
          for J := I + 1 to Files.Count - 1 do
          begin
            Map2.Init(Files[J].Nomenclature, False);
            if (NeighbourMap.Top500 = Map2.Top500)
               and
               (NeighbourMap.Left500 = Map2.Left500)
            then
            begin
              N := Frm.vstJoin.AddChild(nil);
              Data2 := Frm.vstJoin.GetNodeData(N);
              Data2.Nomenclature1 := Files[I].Nomenclature;
              Data2.Nomenclature2 := Files[J].Nomenclature;//NeighbourMap.Nomenclature;
              Data2.Confirmed := False;
              Data2.Kind := jkBottom;
            end;
          end;
          //
          NeighbourMap := Map.Neighbour[n4Bottom];
          for J := I + 1 to Files.Count - 1 do
          begin
            Map2.Init(Files[J].Nomenclature, False);
            if (NeighbourMap.Top500 = Map2.Top500)
               and
               (NeighbourMap.Left500 = Map2.Left500)
            then
            begin
              N := Frm.vstJoin.AddChild(nil);
              Data2 := Frm.vstJoin.GetNodeData(N);
              Data2.Nomenclature1 := Files[I].Nomenclature;
              Data2.Nomenclature2 := Files[J].Nomenclature;//NeighbourMap.Nomenclature;
              Data2.Confirmed := False;
              Data2.Kind := jkTop;
            end;
          end;
        end;
      end;
    end;
    //
    Frm.FFiles := Files;
    //
    Result := Frm.ShowModal = mrOk;
    //
    SetLength(Scans, Length(Frm.FScans));
    for I := 0 to Length(Scans) - 1 do
      Scans[I] := Frm.FScans[I];
  finally
    FreeAndNil(Frm);
  end;
end;

function TKisMapScanLoadForm2.CheckJoin1(const File1, File2: TTakeBackFileInfo; const DataKind: TJoinKind): Boolean;
var
  Bmp: TBitmap;
  Bmp1: TBitmap;
  Bmp2: TBitmap;
  BmpFile: string;
  TmpFile: string;
  S: string;
  View: IKisImageViewer;
begin
  Result := False;
  BmpFile := '';
  try
    Bmp := TMapImage.CreateMapImage();
    try
      Bmp1 := TBitmap.Create;
      try
        if File1.Kind = tbEntireMap then
          Bmp1.LoadFromFile(File1.FileName)
        else if File1.Kind = tbZones then
          Bmp1.LoadFromFile(File1.MergedFile);
        //
        case DataKind of
          jkTop:
            begin
              Bmp.Canvas.CopyRect(MapHalfRect(jkTop), Bmp1.Canvas, MapHalfRect(jkBottom));
            end;
          jkRight:
            begin
              Bmp.Canvas.CopyRect(MapHalfRect(jkRight), Bmp1.Canvas, MapHalfRect(jkLeft));
            end;
          jkBottom:
            begin
              Bmp.Canvas.CopyRect(MapHalfRect(jkBottom), Bmp1.Canvas, MapHalfRect(jkTop));
            end;
          jkLeft:
            begin
              Bmp.Canvas.CopyRect(MapHalfRect(jkLeft), Bmp1.Canvas, MapHalfRect(jkRight));
            end;
        end;
      finally
        FreeAndNil(Bmp1);
      end;
      //
      Bmp2 := TBitmap.Create;
      try
        if File2.Kind = tbEntireMap then
          Bmp2.LoadFromFile(File2.FileName)
        else if File2.Kind = tbZones then
          Bmp2.LoadFromFile(File2.MergedFile);
        //
        case DataKind of
          jkTop:
            begin
              Bmp.Canvas.CopyRect(MapHalfRect(jkBottom), Bmp2.Canvas, MapHalfRect(jkTop));
            end;
          jkRight:
            begin
              Bmp.Canvas.CopyRect(MapHalfRect(jkLeft), Bmp2.Canvas, MapHalfRect(jkRight));
            end;
          jkBottom:
            begin
              Bmp.Canvas.CopyRect(MapHalfRect(jkTop), Bmp2.Canvas, MapHalfRect(jkBottom));
            end;
          jkLeft:
            begin
              Bmp.Canvas.CopyRect(MapHalfRect(jkRight), Bmp2.Canvas, MapHalfRect(jkLeft));
            end;
        end;
      finally
        FreeAndNil(Bmp2);
      end;
      //
      TmpFile := TFileUtils.CreateTempFile(AppModule.AppTempPath);
      BmpFile := ChangeFileExt(TmpFile, '.bmp');
      TFileUtils.RenameFile(TmpFile, BmpFile);
      Bmp.SaveToFile(BmpFile);
    finally
      FreeAndNil(Bmp);
    end;
    View := TKisImageViewerFactory.CreateImageViewer;
    View.AllowSave := False;
    S := 'Стыковка ' + File1.Nomenclature + ' и ' + File2.Nomenclature;
    if View.ConfirmImage(S, BmpFile) then
      Result := True;
  finally
    TFileUtils.DeleteFile(BmpFile);
  end;
end;

function TKisMapScanLoadForm2.CheckJoin2(const File1, File2: TTakeBackFileInfo; const DataKind: TJoinKind): Boolean;
var
  S: string;
  aViewer: IKisImagesView;
  ResultFile, SourceFile, DiffFile: string;
  X, Y: Integer;
  ImgRect: TRect;
begin
  aViewer := TKisImagesViewFactory.CreateViewer();
//  aViewer.AddImage(aFileName, 'Source', 'Оригинальный планшет', Rect(0, 0, 250, 250));
//  if HasDiff then
//    aViewer.AddImage(aFileName, 'Diff', 'Область изменений', Rect(0, 0, 250, 250));
//  aViewer.AddImage(aFileName, 'Result', 'Принятый планшет', Rect(0, 0, 250, 250));
  // для первого файла берём три его картинки
  // это загруженная картинка от пользователя
  ResultFile := '';
  SourceFile := '';
  DiffFile := '';
  if File1.Kind = tbEntireMap then
    ResultFile := File1.FileName
  else
  if File1.Kind = tbNoChanges then
    ResultFile := theMapScansStorage.GetFileName(AppModule, File1.Nomenclature, sfnRaster)
  else
  if File1.Kind = tbZones then
    ResultFile := File1.MergedFile;
  //
  SourceFile := theMapScansStorage.GetFileName(AppModule, File1.Nomenclature, sfnRaster);
  //
  if File1.Kind = tbZones then
    DiffFile := File1.FileName;
  //
  TGeoUtils.MapTopLeft(File1.Nomenclature, X, Y);
  ImgRect.Top := X;
  ImgRect.Left := Y;
  ImgRect.Bottom := X - 250;
  ImgRect.Right := Y + 250;
  aViewer.AddImage(SourceFile, 'Source', 'Исходные планшеты', ImgRect);
  if FileExists(DiffFIle) then
    aViewer.AddImage(DiffFIle, 'Diff', 'Область изменений', ImgRect);
  aViewer.AddImage(ResultFile, 'Result', 'Результат', ImgRect);
  aViewer.AddNomenclature(File1.Nomenclature);
  //
  ResultFile := '';
  SourceFile := '';
  DiffFile := '';
  if File2.Kind = tbEntireMap then
    ResultFile := File2.FileName
  else
  if File2.Kind = tbNoChanges then
    ResultFile := theMapScansStorage.GetFileName(AppModule, File2.Nomenclature, sfnRaster)
  else
  if File2.Kind = tbZones then
    ResultFile := File2.MergedFile;
  //
  SourceFile := theMapScansStorage.GetFileName(AppModule, File2.Nomenclature, sfnRaster);
  //
  if File2.Kind = tbZones then
    DiffFile := File2.FileName;
  //
  TGeoUtils.MapTopLeft(File2.Nomenclature, X, Y);
  ImgRect.Top := X;
  ImgRect.Left := Y;
  ImgRect.Bottom := X - 250;
  ImgRect.Right := Y + 250;
  aViewer.AddImage(SourceFile, 'Source', 'Оригинальные планшеты', ImgRect);
  if FileExists(DiffFIle) then
    aViewer.AddImage(DiffFIle, 'Diff', 'Область изменений', ImgRect);
  aViewer.AddImage(ResultFile, 'Result', 'Результат', ImgRect);
  aViewer.AddNomenclature(File2.Nomenclature);
  //
  S := 'Стыковка ' + File1.Nomenclature + ' и ' + File2.Nomenclature;
  Result := aViewer.CheckJoin(AppModule, S);
end;

function TKisMapScanLoadForm2.FindMap(
  const Nomenclature: String): TTakeBackFileInfo;
var
  N: PVirtualNode;
  Data: ^TFileInfoRec;
begin
  Result := nil;
  N := vstMaps.GetFirst();
  while Assigned(N) do
  begin
    Data := vstMaps.GetNodeData(N);
    if Data.FileInfo.Nomenclature = Nomenclature then
    begin
      Result := Data.FileInfo;
      N := nil;
    end
    else
      N := N.NextSibling;
  end;
end;

procedure TKisMapScanLoadForm2.FormCreate(Sender: TObject);
begin
  FNewJoinCheck := True;
//  FNewJoinCheck := False;
  FNewChangesCheck := True;
//  FNewChangesCheck := False;
  vstMaps.NodeDataSize := SizeOf(TFileInfoRec);
  vstJoin.NodeDataSize := SizeOf(TJoinInfoRec);
  PageControl1.ActivePageIndex := 0;
end;

procedure TKisMapScanLoadForm2.FormShow(Sender: TObject);
var
  N: PVirtualNode;
begin
  N := vstMaps.GetFirst();
  if Assigned(N) then
    vstMaps.Selected[N] := True;
  N := vstJoin.GetFirst();
  if Assigned(N) then
    vstJoin.Selected[N] := True;
end;

function TKisMapScanLoadForm2.MapHalfRect(Kind: TJoinKind): TRect;
begin
  case Kind of
    jkTop:
      Result := Rect(0, 0, SZ_MAP_PX, SZ_MAP_HALF_PX);
    jkRight:
      Result := Rect(SZ_MAP_HALF_PX, 0, SZ_MAP_PX, SZ_MAP_PX);
    jkBottom:
      Result := Rect(0, SZ_MAP_HALF_PX, SZ_MAP_PX, SZ_MAP_PX);
    jkLeft:
      Result := Rect(0, 0, SZ_MAP_HALF_PX, SZ_MAP_PX);
  end;
end;

procedure TKisMapScanLoadForm2.TabSheet2Show(Sender: TObject);
begin
  // надо убедиться что все планшеты из списка уже проверены
  // если нет, то не давать 
end;

procedure TKisMapScanLoadForm2.UpdateButtons;
var
  Count: Integer;
  Data: ^TFileInfoRec;
  S: string;
begin
  Count := vstMaps.TotalCount;
  /// кнопка отркыть доступна, если есть изменения
  if not Assigned(Node) then
    Node := vstMaps.GetFirstSelected();
  if Assigned(Node) then
  begin
    Data := vstMaps.GetNodeData(Node);
    if Data.FileInfo.Confirmed then
      S := 'Посмотреть'
    else
      S := 'Проверить';
    btnCompare.Caption := S;
    //
    case Data.FileInfo.Kind of
    tbNone :
      begin
        btnLoad.Enabled := True;
        btnCompare.Enabled := Data.FileInfo.FileName <> '';
      end;
    tbNoChanges :
      begin
        btnLoad.Enabled := False;
        btnCompare.Enabled := False;
      end;
    tbEntireMap :
      begin
        btnLoad.Enabled := True;
        btnCompare.Enabled := Data.FileInfo.FileName <> '';
      end;
    tbZones :
      begin
        btnLoad.Enabled := True;
        btnCompare.Enabled := Data.FileInfo.FileName <> '';
      end;
    end;
  end;
  //
  Node := vstMaps.GetFirst();
  while Assigned(Node) do
  begin
    Data := vstMaps.GetNodeData(Node);
    case Data.FileInfo.Kind of
    tbNone :
      begin
      end;
    tbNoChanges :
      begin
        Dec(Count);
      end;
    tbEntireMap :
      begin
        if Data.FileInfo.Confirmed then
          Dec(Count);
      end;
    tbZones :
      begin
        if Data.FileInfo.Confirmed then
          Dec(Count);
      end;
    end;
    Node := Node.NextSibling;
  end;
  btnOK.Enabled := (Count = 0);
end;

procedure TKisMapScanLoadForm2.vstJoinColumnDblClick(
  Sender: TBaseVirtualTree; Column: TColumnIndex; Shift: TShiftState);
begin
  btnShowJoin.Click;
end;

procedure TKisMapScanLoadForm2.vstJoinGetText(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var CellText: WideString);
var
  Data: ^TJoinInfoRec;
begin
  Data := Sender.GetNodeData(Node);
  case Column of
  0 :
      begin
        CellText := Data.Nomenclature1;
      end;
  1 :
      begin
        CellText := Data.Nomenclature2;
      end;
  2 :
      begin
        if Data.Confirmed then
          CellText := 'Да'
        else
          CellText := '';
      end;
  end;
end;

procedure TKisMapScanLoadForm2.vstMapsAddToSelection(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  UpdateButtons(Node);
end;

procedure TKisMapScanLoadForm2.vstMapsColumnDblClick(Sender: TBaseVirtualTree;
  Column: TColumnIndex; Shift: TShiftState);
begin
  case Column of
  2, 3 :
         vstMaps.EditNode(vstMaps.GetFirstSelected(), Column);
  4 :    btnLoad.Click;
  end;
end;

procedure TKisMapScanLoadForm2.vstMapsCreateEditor(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
begin
  case Column of
  2 :  EditLink := TChangesEditLink.Create(Self);
  3 :  EditLink := TFileTypeEditLink.Create(Self);
  4 :  begin
         EditLink := nil;
         btnLoad.Click;
       end;
  end;
end;

procedure TKisMapScanLoadForm2.vstMapsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  Data: ^TFileInfoRec;
begin
  Data := Sender.GetNodeData(Node);
  case Column of
  0 :
      begin
        CellText := Data.FileInfo.Nomenclature;
      end;
  1 :
      begin
        if Data.FileInfo.Confirmed then
          CellText := 'Да'
        else
          CellText := '';
      end;
  2 :
      begin
        case Data.FileInfo.Kind of
        tbNone : CellText := '';
        tbNoChanges : CellText := 'Без изменений';
        else
          CellText := 'Есть';
        end;
      end;
  3 :
      begin
        case Data.FileInfo.Kind of
        tbEntireMap : CellText := 'Планшет';
        tbZones : CellText := 'Область изменений';
        else
          CellText := '';
        end;
      end;
  4 :
      begin
        CellText := Data.FileInfo.FileName;
      end;
  end;
end;

{ TKisMapScanLoadForm2.TChangesEditLink }

function TKisMapScanLoadForm2.TComboEditLink.BeginEdit: Boolean;
begin
  Result := True;
  FEdit.Show;
  FEdit.SetFocus;
end;

function TKisMapScanLoadForm2.TComboEditLink.CancelEdit: Boolean;
begin
  Result := True;
  FEdit.Hide;
end;

constructor TKisMapScanLoadForm2.TComboEditLink.Create(aFrm: TKisMapScanLoadForm2);
begin
  inherited Create;
  FForm := aFrm;
end;

procedure TKisMapScanLoadForm2.TComboEditLink.EditCloseUp(Sender: TObject);
begin
  FTree.EndEditNode;
end;

procedure TKisMapScanLoadForm2.TComboEditLink.EditKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  CanAdvance: Boolean;
begin
  CanAdvance := True;
  case Key of
    VK_ESCAPE:
      begin
        Key := 0;//ESC will be handled in EditKeyUp()
      end;
    VK_RETURN:
      if CanAdvance then
      begin
        FTree.EndEditNode;
        Key := 0;
      end;
    VK_UP, VK_DOWN:
      begin
        CanAdvance := Shift = [];
        CanAdvance := CanAdvance and not FEdit.DroppedDown;
        if CanAdvance then
        begin
          PostMessage(FTree.Handle, WM_KEYDOWN, Key, 0);
          Key := 0;
        end;
      end;
  end;
end;

procedure TKisMapScanLoadForm2.TComboEditLink.EditKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      begin
        FTree.CancelEditNode;
        Key := 0;
      end;
  end;
end;

function TKisMapScanLoadForm2.TComboEditLink.EndEdit: Boolean;
begin
  Result := True;
  UpdateNodeData;
  FTree.InvalidateNode(FNode);
  FEdit.Hide;
  FTree.SetFocus;
  FForm.UpdateButtons;
end;

function TKisMapScanLoadForm2.TComboEditLink.GetBounds: TRect;
begin
  Result := FEdit.BoundsRect;
end;

function TKisMapScanLoadForm2.TComboEditLink.PrepareEdit(
  Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean;
var
  Txt: WideString;
begin
  Result := True;
  FTree := Tree as TVirtualStringTree;
  FNode := Node;
  FColumn := Column;
  FEdit := TComboBox.Create(nil);
  FEdit.Parent := Tree;
  FEdit.Visible := False;
  FEdit.Style := csDropDownList;
  FEdit.OnKeyDown := EditKeyDown;
  FEdit.OnKeyUp := EditKeyUp;
  FEdit.OnCloseUp := EditCloseUp;
  UpdateComboItems;
  //
  Txt := '';
  FTree.OnGetText(FTree, Node, Column, ttNormal, Txt);
  FEdit.ItemIndex := FEdit.Items.IndexOf(Txt);
end;

procedure TKisMapScanLoadForm2.TComboEditLink.ProcessMessage(
  var Message: TMessage);
begin
  FEdit.WindowProc(Message);
end;

procedure TKisMapScanLoadForm2.TComboEditLink.SetBounds(R: TRect);
var
  Dummy: Integer;
begin
  FTree.Header.Columns.GetColumnBounds(FColumn, Dummy, R.Right);
  FEdit.BoundsRect := R;
end;

{ TKisMapScanLoadForm2.TChangesEditLink }

procedure TKisMapScanLoadForm2.TChangesEditLink.UpdateComboItems;
begin
  inherited;
  FEdit.Items.Add('Без изменений');
  FEdit.Items.Add('Есть');
end;

procedure TKisMapScanLoadForm2.TChangesEditLink.UpdateNodeData;
var
  Data: ^TFileInfoRec;
begin
  inherited;
  Data := FTree.GetNodeData(FNode);
  case FEdit.ItemIndex of
  0 :  Data.FileInfo.Kind := tbNoChanges;
  1 :  if Data.FileInfo.Kind = tbNoChanges then
         Data.FileInfo.Kind := tbNone;
  else Data.FileInfo.Kind := tbNone;
  end;
  FForm.UpdateButtons;
end;

{ TKisMapScanLoadForm2.TFileTypeEditLink }

procedure TKisMapScanLoadForm2.TFileTypeEditLink.UpdateComboItems;
begin
  inherited;
  FEdit.Items.Add('Планшет');
  FEdit.Items.Add('Область изменений');
end;

procedure TKisMapScanLoadForm2.TFileTypeEditLink.UpdateNodeData;
var
  Data: ^TFileInfoRec;
begin
  inherited;
  Data := FTree.GetNodeData(FNode);
  case FEdit.ItemIndex of
  0 :  Data.FileInfo.Kind := tbEntireMap;
  1 :  Data.FileInfo.Kind := tbZones;
  end;
  FForm.UpdateButtons;
end;

end.
