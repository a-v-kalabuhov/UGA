unit IBCHILD;

{$I KisFlags.pas}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  Grids, JvFormPlacement, ComCtrls, ToolWin, DBActns, StdActns,
  ActnList, ImgList, Menus, Db, IBCustomDataSet, IBQuery, IBDatabase,
  IBUpdateSQL, ExtCtrls, uDBGrid, DBGrids, uLegend, JvComponentBase,
  // Common
  uIBXUtils, uCommonUtils, uSQL, uGC,
  // Project
  AProc6, AGrids6,
  FindDlg, Sort6,
  uKisConsts, uKisAppModule, uKisClasses;

type
  TShowRecordEvent = procedure (var ModalResult: TModalResult) of object;
  TReadCompPropEvent = function (AOwner: TComponent; Component: TComponent;
    const PropertyName: String; DataType: Integer): Variant of object;
  TWriteCompPropEvent = procedure (AOwner, Component: TComponent;
    const PropertyName: String; const Value: Variant) of object;
  TReadSettingEvent = function (const SectionName, PropertyName: String;
    DataType: Integer): Variant of object;
  TWriteSettingEvent = function (const SectionName, PropertyName: String;
    const Value: Variant): Boolean of object;
  TGridPropsEvent = procedure (AOwner: TComponent; Grid: TDBGrid) of object;
  TFormShowMode = (fsmMDIChild, fsmModal, fsmNormal);

  TIBChildForm = class(TForm)
    ImageList: TImageList;
    ActionList: TActionList;
    actFirst: TAction;
    actPrior: TAction;
    actNext: TAction;
    actLast: TAction;
    actInsert: TAction;
    actDelete: TAction;
    ToolBar: TToolBar;
    btnNew: TToolButton;
    btnDel: TToolButton;
    btnShow: TToolButton;
    ToolButton5: TToolButton;
    btnFind: TToolButton;
    btnUnfind: TToolButton;
    btnSort: TToolButton;
    ToolButton10: TToolButton;
    btnFirst: TToolButton;
    btnPrior: TToolButton;
    btnNext: TToolButton;
    btnLast: TToolButton;
    btnRefresh: TToolButton;
    Grid: TkaDBGrid;
    Query: TIBQuery;
    DataSource: TDataSource;
    MainMenu: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    UpdateSQL: TIBUpdateSQL;
    Transaction: TIBTransaction;
    actFind: TAction;
    actUnFind: TAction;
    actSort: TAction;
    actRestoreGrid: TAction;
    actShow: TAction;
    actReopen: TAction;
    actCount: TAction;
    Legend: TkaLegend;
    FormStorage: TJvFormStorage;
    miBigButtons: TMenuItem;
    miView: TMenuItem;
    procedure actFindUpdate(Sender: TObject);
    procedure actUnFindUpdate(Sender: TObject);
    procedure actSortUpdate(Sender: TObject);
    procedure actRestoreGridUpdate(Sender: TObject);
    procedure actShowUpdate(Sender: TObject);
    procedure actReopenUpdate(Sender: TObject);
    procedure actCountUpdate(Sender: TObject);
    procedure actFindExecute(Sender: TObject);
    procedure actUnFindExecute(Sender: TObject);
    procedure actSortExecute(Sender: TObject);
    procedure actRestoreGridExecute(Sender: TObject);
    procedure actCountExecute(Sender: TObject);
    procedure actReopenExecute(Sender: TObject);
    procedure QueryAfterDelete(DataSet: TDataSet);
    procedure QueryAfterPost(DataSet: TDataSet);
    procedure GridDblClick(Sender: TObject);
    procedure actInsertExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actFirstUpdate(Sender: TObject);
    procedure actFirstExecute(Sender: TObject);
    procedure actPriorUpdate(Sender: TObject);
    procedure actPriorExecute(Sender: TObject);
    procedure actNextUpdate(Sender: TObject);
    procedure actNextExecute(Sender: TObject);
    procedure actLastUpdate(Sender: TObject);
    procedure actLastExecute(Sender: TObject);
    procedure actInsertUpdate(Sender: TObject);
    procedure actDeleteUpdate(Sender: TObject);
    procedure QueryBeforeDelete(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
    procedure QueryBeforeOpen(DataSet: TDataSet);
    procedure GridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure miBigButtonsClick(Sender: TObject);
  private
    FAutoCommitAfterPost: Boolean;
    FEditing: Boolean;
    FOnReadAppParam: TReadSettingEvent;
    FOnWriteAppParam: TWriteSettingEvent;
    FOnReadGridProps: TGridPropsEvent;
    FOnWriteGridProps: TGridPropsEvent;
    FBigButtons: Boolean;
    procedure SetStartQuery;
    procedure SetBigButtons(const Value: Boolean);
  protected
    FStartSQL: TStrings;
    procedure DoClose(var Action: TCloseAction); override;
    function GetActionEnabled(Action: TAction): Boolean;
    function CheckSortOrder(const SortOrder: String): Boolean;
    procedure ApplySQLFilters; virtual;
  public
    SelectionMode: Boolean;
    InSearch: Boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ShowForm(const Mode: TFormShowMode=fsmMDIChild): TModalResult;
    property Editing: Boolean read FEditing write FEditing;
    property BigButtons: Boolean read FBigButtons write SetBigButtons;
  published
    property AutoCommitAfterPost: Boolean read FAutoCommitAfterPost
      write FAutoCommitAfterPost default True;
    property OnReadAppParam: TReadSettingEvent read FOnReadAppParam write FOnReadAppParam;
    property OnWriteAppParam: TWriteSettingEvent read FOnWriteAppParam write FOnWriteAppParam;
    property OnReadGridProps: TGridPropsEvent read FOnReadGridProps write FOnReadGridProps;
    property OnWriteGridProps: TGridPropsEvent read FOnWriteGridProps write FOnWriteGridProps;
  end;

implementation

{$R *.DFM}

constructor TIBChildForm.Create(AOwner: TComponent);
var
  SortOrder: String;
begin
  FAutoCommitAfterPost := True;
  FEditing := False;
  inherited Create(AOwner);
  FStartSQL := TStringList.Create;
  OnReadAppParam := AppModule.ReadAppParam;
  OnWriteAppParam := AppModule.SaveAppParam;
  OnReadGridProps := AppModule.ReadGridProperties;
  OnWriteGridProps := AppModule.WriteGridProperties;
  InSearch := False;
  //нормализуем запрос
  Query.AsSQL.Normalize();
  //устанавливем порядок сортировки
  if Assigned(OnReadAppParam) then
    SortOrder := OnReadAppParam(Name, 'SortOrder', varString);
  //устанавливем порядок сортировки
  if Assigned(OnReadAppParam) then
    BigButtons := OnReadAppParam(Name, 'BigButtons', varBoolean);
  if CheckSortOrder(SortOrder) then
    Query.AsSQL.WriteClause(scOrderBy, SortOrder)
  else
    MessageBox(0, PChar('Не удалось восстановить порядок сортировки!'#13#10'Настройте сортировку самостоятельно.'), PChar(S_WARN), MB_OK + MB_ICONWARNING);
  //читаем параметры таблицы
  if Assigned(OnReadGridProps) then
    OnReadGridProps(Self, Grid);
end;

destructor TIBChildForm.Destroy;
begin
  FreeAndNil(FStartSQL);
  inherited;
end;

function TIBChildForm.ShowForm(const Mode: TFormShowMode = fsmMDIChild): TModalResult;
begin
  //закрываем форму
  Result := mrNone;
  FormStyle := fsNormal;
  if Visible then
    Close;
  //открываем запрос
  FStartSQL.Assign(Query.SQL);
  if not Query.Active then
    Query.Open;
  //показваем форму
  case Mode of
    fsmMDIChild: FormStyle := fsMDIChild;
    fsmModal: Result := ShowModal;
    fsmNormal: Show;
  end;
end;

procedure TIBChildForm.DoClose(var Action: TCloseAction);
begin
    if not SelectionMode then
    try
      if Query.Transaction.Active then
        Query.Transaction.Commit;
      //сохраняем порядок сортировки
      if Assigned(OnWriteAppParam) then
        try
          OnWriteAppParam(Name, 'SortOrder', Query.AsSQL.ReadClause(scOrderBy));
          OnWriteAppParam(Name, 'BigButtons', BigButtons);
        except
        end;
      //сохраняем параметры таблицы
      if Assigned(OnWriteGridProps) then
        OnWriteGridProps(Self, Grid);
    except
    end;
    if FormStyle = fsMDIChild then Action := caFree;
  inherited DoClose(Action);
end;

function TIBChildForm.GetActionEnabled(Action: TAction): Boolean;
begin
  if Action = actFirst then
    Result := Query.Active and not Query.Bof
  else
  if Action = actPrior then
    Result := Query.Active and not Query.Bof
  else
  if Action = actNext then
    Result := Query.Active and not Query.Eof
  else
  if Action = actLast then
    Result:=Query.Active and not Query.Eof
  else
  if Action = actInsert then
    Result := Query.Active and Query.CanModify
  else
  if Action = actDelete then
    Result := Query.Active and Query.CanModify and not (Query.Bof and Query.Eof)
  else
  if Action = actFind then
    Result := Query.Active and not(Query.Bof and Query.Eof)
  else
  if Action = actUnFind then
    Result := Query.Active and InSearch
  else
  if Action = actSort then
    Result := Query.Active
  else
  if Action = actRestoreGrid then
    Result := True
  else
  if Action = actShow then
    Result := Query.Active and not(Query.Bof and Query.Eof) and Assigned(actShow.OnExecute)
  else
  if Action = actReopen then
    Result := Query.Active
  else
  if Action = actCount then
    Result := Query.Active
  else
    Result := False;
end;

procedure TIBChildForm.actFindUpdate(Sender: TObject);
begin
  actFind.Enabled:=GetActionEnabled(actFind);
end;

procedure TIBChildForm.actUnFindUpdate(Sender: TObject);
begin
  actUnFind.Enabled:=GetActionEnabled(actUnFind);
end;

procedure TIBChildForm.actSortUpdate(Sender: TObject);
begin
  actSort.Enabled:=GetActionEnabled(actSort);
end;

procedure TIBChildForm.actRestoreGridUpdate(Sender: TObject);
begin
  actRestoreGrid.Enabled:=GetActionEnabled(actRestoreGrid);
end;

procedure TIBChildForm.actShowUpdate(Sender: TObject);
begin
  actShow.Enabled:=GetActionEnabled(actShow);
end;

procedure TIBChildForm.actReopenUpdate(Sender: TObject);
begin
  actReopen.Enabled:=GetActionEnabled(actReopen);
end;

procedure TIBChildForm.actCountUpdate(Sender: TObject);
begin
  actCount.Enabled:=GetActionEnabled(actCount);
end;

procedure TIBChildForm.actFindExecute(Sender: TObject);
begin
  if ShowFindDlg(GetActiveGrid) then InSearch:=True;
end;

procedure TIBChildForm.actUnFindExecute(Sender: TObject);
begin
  SetStartQuery;
end;

procedure TIBChildForm.SetStartQuery;
var
  OrderClause: string;
  Q:TStringList;
begin
  Q := TStringList.Create;
  Q.Forget();
  Q.Assign(FStartSQL);
  OrderClause := UpperCase(Query.AsSQL.ReadClause(scOrderBy));
  TSQLFactory.CreateNew(Q).WriteClause(scOrderBy,OrderClause);
  Query.Reset(Q, AppModule.SQLErrorHandler);
  InSearch := False;
end;

procedure TIBChildForm.actSortExecute(Sender: TObject);
begin
  ShowSort(GetActiveGrid);
end;

procedure TIBChildForm.actRestoreGridExecute(Sender: TObject);
begin
  if MessageBox(0, PChar(S_RESTORE_TABLE), PChar(S_CONFIRM), MB_ICONQUESTION+
    MB_OKCANCEL)=IDOK then
    AGrids6.RestoreGridDefaults(GetActiveGrid);
end;

procedure TIBChildForm.actCountExecute(Sender: TObject);
begin
  Query.FetchAll;
  MessageBox(0, PChar('Число записей: '+IntToStr(Query.RecordCount)), PChar(S_MESS),
    MB_ICONINFORMATION);
end;

procedure TIBChildForm.actReopenExecute(Sender: TObject);
begin
  Query.Close;
  Query.Open;
end;

procedure TIBChildForm.QueryAfterDelete(DataSet: TDataSet);
begin
  Transaction.CommitRetaining;
end;

procedure TIBChildForm.QueryAfterPost(DataSet: TDataSet);
begin
  if AutoCommitAfterPost then Transaction.CommitRetaining;
end;

procedure TIBChildForm.GridDblClick(Sender: TObject);
begin
  actShow.Execute;
end;

procedure TIBChildForm.actInsertExecute(Sender: TObject);
begin
  try
    Query.Insert;
  except
    Transaction.RollbackRetaining;
    raise;
  end;
end;

procedure TIBChildForm.actDeleteExecute(Sender: TObject);
begin
  if Editing then Abort
  else
  if MessageBox(0, PChar(S_CONFIRM_DELETE_RECORD), PChar(S_CONFIRM),  MB_ICONQUESTION + MB_OKCANCEL)=IDOk then
    Query.Delete;
end;

procedure TIBChildForm.actFirstUpdate(Sender: TObject);
begin
  actFirst.Enabled := GetActionEnabled(actFirst);
end;

procedure TIBChildForm.actFirstExecute(Sender: TObject);
begin
  Query.First;
end;

procedure TIBChildForm.actPriorUpdate(Sender: TObject);
begin
  actPrior.Enabled:=GetActionEnabled(actPrior);
end;

procedure TIBChildForm.actPriorExecute(Sender: TObject);
begin
  Query.Prior;
end;

procedure TIBChildForm.actNextUpdate(Sender: TObject);
begin
  actNext.Enabled:=GetActionEnabled(actNext);
end;

procedure TIBChildForm.actNextExecute(Sender: TObject);
begin
  Query.Next;
end;

procedure TIBChildForm.actLastUpdate(Sender: TObject);
begin
  actLast.Enabled:=GetActionEnabled(actLast);
end;

procedure TIBChildForm.actLastExecute(Sender: TObject);
begin
  Query.Last;
end;

procedure TIBChildForm.actInsertUpdate(Sender: TObject);
begin
  actInsert.Enabled:=GetActionEnabled(actInsert);
end;

procedure TIBChildForm.actDeleteUpdate(Sender: TObject);
begin
  actDelete.Enabled:=GetActionEnabled(actDelete);
end;

procedure TIBChildForm.QueryBeforeDelete(DataSet: TDataSet);
begin
  if Editing then Exit;
end;

procedure TIBChildForm.FormShow(Sender: TObject);
begin
  Grid.SetFocus;
end;

function TIBChildForm.CheckSortOrder(const SortOrder: String): Boolean;

  function CheckSortField(var SortField: String): Boolean;
  var
    I: Integer;
    Table, Field, S: String;
  begin
    Result := False;
    Table := '';
    Field := '';
    S := Copy(SortField, Length(SortField) - 4, 5);
    if S = ' DESC' then
      SetLength(SortField, Length(SortField) - 5)
    else
    begin
      S := Copy(SortField, Length(SortField) - 3, 4);
      if S = ' ASC' then
        SetLength(SortField, Length(SortField) - 4);
    end;
    I := Pos('.', SortField);
    if I > 0 then
    begin
      Table := Copy(SortField, 1, Pred(I));
      Field := Copy(SortField, Succ(I), Length(SortField) - I);
      for I := 0 to Pred(Query.Fields.Count) do
      if Query.Fields[I].Origin = SortField then
      begin
        Result := True;
        Exit;
      end;
    end
    else
    begin
      Field := Trim(SortField);
      if StrIsNumber(Field) then
      begin
        I := StrToInt(Field);
        Result := I <= Query.FieldDefs.Count;
        Exit;
      end
      else
        try
          Query.Fields.CheckFieldName(Field);
          Result := True;
        except
          Result := False;
          Exit;
        end;
    end;
  end;

var
  K: Integer;
  SortString, SortField: String;
begin
  Result := SortOrder = '';
  if Result then
    Exit;
  Result := True;
  SortString := Trim(SortOrder);
  K := Pos(',', SortString);
  while (K > 0) or (Length(SortString) > 0) do
  begin
    if K > 0 then
    begin
      SortField := Copy(SortString, 1, Pred(K));
      Delete(SortString, 1, K);
    end
    else
    begin
      SortField := SortString;
      SortString := '';
    end;
    Result := Result and CheckSortField(SortField);
    if not Result then
      Exit;
    K := Pos(',', SortString);
  end;
end;

procedure TIBChildForm.ApplySQLFilters;
begin
  /// Фильтр и не аплится!
end;

procedure TIBChildForm.QueryBeforeOpen(DataSet: TDataSet);
begin
  ApplySQLFilters;
end;

procedure TIBChildForm.GridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Grid.Focused then
  if (ssShift in Shift) then
  case Key of
  VK_LEFT :
    begin
      if Grid.Columns[Grid.SelectedIndex].Width > 30 then
        Grid.Columns[Grid.SelectedIndex].Width := Grid.Columns[Grid.SelectedIndex].Width - 10;
      Key := 0;
    end;
  VK_RIGHT :
    begin
      if Grid.Columns[Grid.SelectedIndex].Width < Grid.ClientWidth then
        Grid.Columns[Grid.SelectedIndex].Width := Grid.Columns[Grid.SelectedIndex].Width + 10;
      Key := 0;
    end;
  end;
end;

procedure TIBChildForm.miBigButtonsClick(Sender: TObject);
begin
  BigButtons := not BigButtons;
end;

procedure TIBChildForm.SetBigButtons(const Value: Boolean);
begin
  if FBigButtons <> Value then
  begin
    FBigButtons := Value;
    miBigButtons.Checked := FBigButtons;
    ToolBar.ShowCaptions := FBigButtons;
    if not ToolBar.ShowCaptions then
    begin
      ToolBar.ButtonWidth := 23;
      ToolBar.ButtonHeight := 23;
    end;
  end;
end;

end.
