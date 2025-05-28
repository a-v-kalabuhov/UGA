unit uMStFormMapImages;

interface

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, ShellApi,
  Dialogs, ComCtrls, ShellCtrls, StdCtrls, ExtCtrls, Buttons, ImgList, Menus, Contnrs,
  //
  uGC, uGeoUtils, uFileUtils,
  //
  uMStKernelClasses;

type
  TmstFormMapImages = class(TForm)
    tvLocal: TShellTreeView;
    lvLocal: TShellListView;
    mLog: TMemo;
    StatusBar: TStatusBar;
    Splitter1: TSplitter;
    Panel1: TPanel;
    cbDelete: TCheckBox;
    Splitter2: TSplitter;
    lvServer: TListView;
    Splitter3: TSplitter;
    btnUpload: TBitBtn;
    btnLocalDelete: TBitBtn;
    btnServerDelete: TBitBtn;
    ImageList: TImageList;
    btnServerRefresh: TBitBtn;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N3991: TMenuItem;
    N8: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure btnServerRefreshClick(Sender: TObject);
    procedure btnLocalDeleteClick(Sender: TObject);
    procedure btnUploadClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnServerDeleteClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N3991Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
  private
    procedure DeleteLocalFile();
    procedure DeleteRemoteFile();
    procedure FindDuplicates();
    procedure LoadMapsToListView;
    procedure UploadMapToServer();
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  mstFormMapImages: TmstFormMapImages;

implementation

uses
  uMStModuleApp;

type
  TMapDuplicates = class
  private
    FDuplicates: TStrings;
    FName: string;
    procedure SetName(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;
    // 
    property Name: string read FName write SetName;
    property Duplicates: TStrings read FDuplicates;
  end;

{$R *.dfm}

procedure OpenTextFile(const aFileName: string);
begin
  ShellExecute(Application.Handle, 'open', PChar(aFileName), nil, nil, SW_SHOWNORMAL);
end;

procedure TmstFormMapImages.LoadMapsToListView;
var
  I: Integer;
begin
  StatusBar.Panels[0].Text := Format('Всего загружено: %d планештов', [mstClientAppModule.Maps.Count]);
  with mstClientAppModule do
  try
    lvServer.Items.BeginUpdate;
    lvServer.Items.Clear;
    for I := 0 to Pred(Maps.Count) do
      with lvServer.Items.Add do
      begin
        Caption := Maps[I].MapName;
        ImageIndex := 0;
        StateIndex := 0;
      end;
  finally
    lvServer.Items.EndUpdate;
  end;
end;

procedure TmstFormMapImages.N2Click(Sender: TObject);
begin
  LoadMapsToListView();
end;

procedure TmstFormMapImages.N3991Click(Sender: TObject);
var
  Res: TModalResult;
  Save_Cursor: TCursor;
begin
  Res := MessageBox(Handle,
                    PChar('Удалить из БД все планшеты кроме последних 399?'),
                    PChar('Подтверждение'),
                    MB_YESNO + MB_ICONQUESTION);
  if Res = mrYes then
  begin
    mLog.Clear;
    mLog.Lines.Add('Удаление планшетов:');
    Save_Cursor := Screen.Cursor;
    Screen.Cursor := crHourGlass;
    try
      mstClientAppModule.ClearMapImagesTo399(mLog);
    finally
      Screen.Cursor := Save_Cursor;
    end;
  end;
end;

procedure TmstFormMapImages.N3Click(Sender: TObject);
begin
  UploadMapToServer();
end;

procedure TmstFormMapImages.N4Click(Sender: TObject);
begin
  DeleteLocalFile();
end;

procedure TmstFormMapImages.N7Click(Sender: TObject);
begin
  Close();
end;

procedure TmstFormMapImages.N8Click(Sender: TObject);
begin
  FindDuplicates();
end;

procedure TmstFormMapImages.UploadMapToServer;
var
  I, Uploaded, Errors: Integer;
  L: TStringList;
  S: String;
begin
  Uploaded := 0;
  Errors := 0;
  if lvLocal.SelCount = 0 then
  begin
    ShowMessage('Выберите файл для загрузки!');
  end
  else
  begin
    L := TStringList.Create;
    try
      for I := 0 to Pred(lvLocal.Items.Count) do
        if lvLocal.Items[I].Selected then
          if not lvLocal.Folders[I].IsFolder then
            L.Add(lvLocal.Folders[I].PathName);
      for I := 0 to Pred(L.Count) do
      begin
        if mstClientAppModule.UploadMapImage(L[I], S) then
        begin
          Inc(Uploaded);
        end
        else
        begin
          Inc(Errors);
          mLog.Lines.Add('!!! ================= Ошибка =================');
        end;
        mLog.Lines.Add(S);
        if cbDelete.Checked then
          DeleteFile(L[I]);
      end;
      lvLocal.Refresh;
    finally
      L.Free;
    end;
    mLog.Lines.Add('Всего загружено: ' + IntToStr(Uploaded));
    mLog.Lines.Add('Возникло ошибок: ' + IntToStr(Errors));
  end;
end;

procedure TmstFormMapImages.FindDuplicates;
var
  I, J: Integer;
  Map: TmstMap;
  Duplicates: TObjectList;
  DuplicateNames: TStringList;
  N: TNomenclature;
  ValidName: string;
  MapDups: TMapDuplicates;
  Report: TStringList;
  TempFile, ReportFile: string;
begin
  Duplicates := TObjectList.Create;
  Duplicates.Forget();
  DuplicateNames := TStringList.Create;
  DuplicateNames.Forget();
  for I := 0 to mstClientAppModule.Maps.Count - 1 do
  begin
    Map := mstClientAppModule.Maps[I];
    N.Init(Map.MapName, False);
    ValidName := N.Nomenclature();
    J := DuplicateNames.Indexof(ValidName);
    if J < 0 then
    begin
      J := DuplicateNames.Add(ValidName);
      MapDups := TMapDuplicates.Create;
      MapDups.Name := ValidName;
      DuplicateNames.Objects[J] := MapDups;
      Duplicates.Add(MapDups);
    end
    else
    begin
      MapDups := TMapDuplicates(DuplicateNames.Objects[J]);
    end;
    MapDups.Duplicates.Add(Map.MapName);
  end;
  //
  Report := TStringList.Create;
  Report.Forget();
  for I := 0 to Duplicates.Count - 1 do
  begin
    MapDups := TMapDuplicates(Duplicates[I]);
    if MapDups.Duplicates.Count > 1 then
    begin
      Report.Add(MapDups.Name + ':');
      for J := 0 to MapDups.Duplicates.Count - 1 do
        Report.Add('    ' + MapDups.Duplicates[J]);
    end;
  end;
  //
  if Report.Count = 0 then
  begin
    ShowMessage('Дубликаты планшетов не найдены!');
  end
  else
  begin
    TempFile := TFileUtils.CreateTempFile(mstClientAppModule.AppSettings.SessionDir, 'report');
    ReportFile := ChangeFileExt(TempFile, '.txt');
    if TFileUtils.RenameFile(TempFile, ReportFile) then
    begin
      Report.SaveToFile(ReportFile);
      OpenTextFile(ReportFile);
    end;
  end;
end;

procedure TmstFormMapImages.FormCreate(Sender: TObject);
begin
  mLog.Clear;
end;

procedure TmstFormMapImages.btnServerRefreshClick(Sender: TObject);
begin
  LoadMapsToListView();
end;

procedure TmstFormMapImages.btnLocalDeleteClick(Sender: TObject);
begin
  DeleteLocalFile();
end;

procedure TmstFormMapImages.btnUploadClick(Sender: TObject);
begin
  UploadMapToServer();
end;

procedure TmstFormMapImages.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := Params.ExStyle + WS_EX_APPWINDOW;
end;

procedure TmstFormMapImages.DeleteLocalFile;
var
  I: Integer;
  L: TStringList;
begin
  if lvLocal.SelCount = 0 then
  begin
    ShowMessage('Выберите файл для удаления!');
  end
  else
  begin
    L := TStringList.Create;
    try
      for I := 0 to Pred(lvLocal.Items.Count) do
        if lvLocal.Items[I].Selected then
          if not lvLocal.Folders[I].IsFolder then
            L.Add(lvLocal.Folders[I].PathName);
      for I := 0 to Pred(L.Count) do
        DeleteFile(L[I]);
      lvLocal.Refresh;
    finally
      L.Free;
    end;
  end;
end;

procedure TmstFormMapImages.DeleteRemoteFile;
var
  I, Deleted, Errors: Integer;
  L: TStringList;
  S: String;
begin
  Deleted := 0;
  Errors := 0;
  if lvServer.SelCount = 0 then
  begin
    ShowMessage('Выберите планшет на сервере!');
    lvServer.SetFocus();
  end
  else
  begin
    L := TStringList.Create;
    try
      for I := 0 to Pred(lvServer.Items.Count) do
        if lvServer.Items[I].Selected then
            L.Add(lvServer.Items[I].Caption);
      for I := 0 to Pred(L.Count) do
      begin
        if mstClientAppModule.DeleteMapImage(L[I], S) then
        begin
          Inc(Deleted);
        end
        else
        begin
          Inc(Errors);
          mLog.Lines.Add('!!! ================= Ошибка =================');
        end;
        mLog.Lines.Add(S);
      end;
      lvServer.Refresh;
    finally
      L.Free;
    end;
    mLog.Lines.Add('Всего удалено : ' + IntToStr(Deleted));
    mLog.Lines.Add('Возникло ошибок: ' + IntToStr(Errors));
  end;
end;

procedure TmstFormMapImages.FormShow(Sender: TObject);
begin
  LoadMapsToListView;
end;

procedure TmstFormMapImages.btnServerDeleteClick(Sender: TObject);
begin
  DeleteRemoteFile();
end;

{ TMapDuplicates }

constructor TMapDuplicates.Create;
begin
  FDuplicates := TStringList.Create;
end;

destructor TMapDuplicates.Destroy;
begin
  FDuplicates.Free;
  inherited;
end;

procedure TMapDuplicates.SetName(const Value: string);
begin
  FName := Value;
end;

end.
