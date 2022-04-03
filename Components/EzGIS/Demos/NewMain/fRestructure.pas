unit fRestructure;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{   NOTE: This is only a sample of how to restructure       }
{***********************************************************}

{$I EZ_FLAG.PAS}
interface

uses
  Windows, SysUtils, Classes, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, DBGrids, DB, DBCtrls,
  Dialogs, EzBasegis, EzBasicCtrls, ComCtrls, Ezbase,
  EzTable, Grids ;

Type
  TfrmRestructDlg = Class(TForm)
    DataSource1: TDataSource;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    DBNavigator1: TDBNavigator;
    DBGrid2: TDBGrid;
    List1: TListBox;
    Button1: TBitBtn;
    Button2: TBitBtn;
    Bevel1: TBevel;
    LblStatus: TLabel;
    Button3: TBitBtn;
    OKBtn: TButton;
    CancelBtn: TButton;
    BtnRegen: TButton;
    procedure DBGrid1ColEnter(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure DBGrid2ColEnter(Sender: TObject);
    procedure BtnRegenClick(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure DBNavigator1Click(Sender: TObject; Button: TNavigateBtn);
  private
    { Private declarations }
    DesignList:TList;
    FLayer: TEzBaseLayer;

    bFieldsModified: boolean;
    bIndexModified: boolean;
    FullName: String;
    FDesignTable: TDataset;
    FChangingValue: Boolean;
    procedure dsDesignBeforePost(DataSet: TDataSet);
    procedure dsDesignAfterDelete(DataSet: TDataSet);
    procedure dsDesignBeforeEdit(DataSet: TDataSet);
    procedure dsDesignBeforeDelete(DataSet: TDataSet);
    procedure FillWithDBInfo(  const Filename: String; DesignList, IndexList: TList  );
  public
    { Public declarations }
    rest_type: integer;
    IndexList: TList;
    function Enter(Layer: TEzBaseLayer): Word;
  end;

implementation

{$R *.DFM}

Uses
  EzConsts, EzSystem, fAddIdx, Ezimpl;

type

  PIndexingRec = ^TIndexingRec;
  TIndexingRec = record
     IndexName      : string;
     KeyExpression  : string;
     ForExpression  : string;
     Unique         : TEzIndexUnique;
     SortStatus     : TEzSortStatus;
  end;

  PDesignRecord = ^TDesignRecord;
  TDesignRecord = record
     FieldName    : string[10];
     FieldType    : Char;
     FieldSize    : Integer;
     FieldDec     : Integer;
     Recno        : Integer;
     IsNewField   : Boolean;
     NewFieldName : string[10];
  End;

resourcestring
  SUnspecifiedFieldType= 'Field type is wrong !';
  SRestructureCaption= 'Restructure DBF file of layer %s';
  SRestMsg1= 'Type the field name (10 chars max),' + CrLf +
      'beginning with A-Z. Use only A-Z, 0-9, or _.';
  SRestmsg2= 'Press F2 and then click in button to select field type.';
  SRestMsg3= 'Field size (1 - 254).';
  SRestMsg4= 'Number of digits after decimal point.';
  SRestLongWarning= ' It is highly recommended that ' + CrLf +
     'you backup your files before proceed.' + CrLf +
     'Also, it is needed that any other user is accesing the same files' + CrLf +
     'at same time in other PC if you are working on a network.' + CrLf +
     'Are you sure you want to proceed ?';
  SNewIndexTitle= 'Index name';
  SNewIndexQuery= 'Please type the name for new index';
  SDuplicateIndex= 'Duplicated index name !';
  SInvalidDBFExpression= 'Wrong DBF expression !';
  SIncorrectFieldName= 'Field name wrong !';
  SIncorrectFieldType= 'Field type is wrong !' + CrLf +
                       'Must be: C=CHAR,L=LOGIC,D=DATE,N=NUMERIC,M=MEMO,B=BINARY,G=GRAPHIC';
  SIncorrectFieldSize= 'Field size is wrong !' + CrLf + 'Must be between 1-254';
  SIncorrectDecimals= 'Number of decimals for field is wrong !' + CrLf +
                      'Must be 0-10';
  SFieldNameCaption= 'Type the field name (10 chars or less' + CrLf +
                     'beginning with a letter). use only A-Z, 0-9, or _.';
  SFieldSelectF2= 'Press F2 and click the button to select the field type.';
  SFieldSizeCaption= 'Type field size (1 - 254).';
  SFieldDecCaption= 'Type number of decimals for field.';
  SIndexRegenInfo= 'Indexes has been regenerated !';

  SRestAborted = 'There was a problem trying to restore original data.' + CrLf +
                 'Restructure aborted' + CrLf +
                 'Error: %s';
const
  Digits = ['0'..'9'];
  PrimaryIdentChars = ['A'..'Z', '_', #127..#255];
  IdentChars = PrimaryIdentChars + Digits;

// restructure main procedure
function DoRestructure( Layer: TEzBaseLayer; DesignList, IndexList: TList;
  NewFieldList: TStringList ): Boolean;
Var
  FDest, FSource: Integer;
  Recno,cnt,I,J:integer;
  Source,Destination:String;
  TmpTable,SourceTable,DestTable: TEzBaseTable;
  S,FullName, filename, TemporaryDir : String;
  MapSource,MapDest:TStringList;
  DesignRecord: PDesignRecord;
  IndexRecord: PIndexingRec;
  usevisualbar: boolean;
  FieldList: TStringList;
  TempPath : array[0..1023] of char;
  Gis: TEzBaseGis;
  NRecs: Integer;

begin

  Result:= True;

  FullName := Layer.FileName;

  GetTempPath(1023, TempPath);
  TemporaryDir := AddSlash(TempPath);

  Gis:= Layer.Layers.Gis;

  with ezbasegis.basetableclass.CreateNoOpen( Gis ) do
    try
      DBDropTable( TemporaryDir + Layer.Name );
    finally
      free;
    end;

  FieldList:= TStringList.Create;
  for I:= 0 to NewFieldList.Count-1 do
  begin
     J:= AnsiPos(';', NewFieldList[I]);
     if J = 0 then J:= Length(NewFieldList[I]);
     FieldList.Add( Copy(NewFieldList[I],1,J-1) );
  end;

  { Check for duplicated field names }
  For I:= 0 To FieldList.Count-1 Do
     For J:=0 To FieldList.Count-1 Do
        If (I <> J) And (FieldList[I] = FieldList[J]) Then
        Begin
          ShowMessage(Format('Field %s is duplicated !',[FieldList[I]]));
          FieldList.Free;
          Result:= False;
          Exit;
        End;
  FieldList.Free;

  Screen.Cursor := crHourglass;

  try
    with ezbasegis.basetableclass.CreateNoOpen( Gis ) do
      try
        DBCreateTable( TemporaryDir + Layer.Name, NewFieldList );
      finally
        free;
      end;

    { Indexes }
    if IndexList.count>0 then
    begin
       Filename:= TemporaryDir + Layer.Name;
       TmpTable:=ezbasegis.BaseTableClass.Create( Gis, FileName, true, true );
       try
          for cnt:= 0 to IndexList.count-1 do
          begin
             IndexRecord:= PIndexingRec(IndexList[cnt]);
             with IndexRecord^ do begin
                 TmpTable.IndexOn( TemporaryDir + Layer.Name,
                                   IndexName,
                                   KeyExpression,
                                   ForExpression,
                                   Unique,
                                   SortStatus );
             end;
          end;
       finally
          TmpTable.Free;
       end;
    end;
  except
    with ezbasegis.basetableclass.CreateNoOpen( Gis ) do
      try
        DBDropTable( TemporaryDir + Layer.Name );
      finally
        free;
      end;
    Screen.Cursor:= crDefault;
    raise;
  end;

  Recno:= 0;
  MapSource:= TStringList.Create;
  MapDest:= TStringList.Create;
  Try
    with ezbasegis.basetableclass.CreateNoOpen( Gis ) do
      try
        if not DBTableExists(FullName) then Exit;
        if not DBTableExists(TemporaryDir + Layer.Name) then Exit;
      finally
        free;
      end;

     Layer.Close;

     SourceTable:= ezbasegis.BaseTableClass.Create( Gis,
       AddSlash(ExtractFilePath(FullName)) + Layer.Name, True, False);
     SourceTable.SetUseDeleted( True );

     DestTable := ezbasegis.BaseTableClass.Create( Gis,
       AddSlash( TemporaryDir ) + Layer.Name, True, False);
     DestTable.SetUseDeleted( True );

     for I:= 0 to DesignList.Count - 1 do
     begin
        DesignRecord:= PDesignRecord(DesignList[I]);
        if not DesignRecord^.IsNewField then
        begin
           MapSource.Add( DesignRecord^.FieldName );
           MapDest.Add( DesignRecord^.NewFieldName );
        end;
     end;
     for I:= 0 to NewFieldList.Count-1 do
     begin
        J:= AnsiPos(';',NewFieldList[I]);
        if J=0 then J:=Length(NewFieldList[I]);
        S:= Copy(NewFieldList[I],1,J-1);
        If MapDest.IndexOf(s) = -1 Then
        Begin
           MapDest.Add( s );
           MapSource.Add( s );
        End;
     end;
     Try
       Try
         UseVisualBar:= SourceTable.RecordCount > 0;
         If UseVisualBar Then
         Begin
            Gis.StartProgress( SRestructuring, 1, SourceTable.RecordCount );
            Recno:= 1;
         End;
         NRecs:=0;
         SourceTable.First;
         While Not SourceTable.Eof Do
         Begin
           Inc(NRecs);
           DestTable.Append(NRecs);
           For cnt:= 0 To MapDest.Count-1 Do
           Begin
              FDest := DestTable.FieldNo(MapDest[cnt]);
              FSource := SourceTable.FieldNo(MapSource[cnt]);
              If Not ( ( FSource = 0 ) or ( FDest = 0 ) ) Then
              Begin
                DestTable.Edit;
                DestTable.AssignFrom( SourceTable, FSource, FDest );
                DestTable.Post;
              End;
           End;
           SourceTable.Next;
           If UseVisualBar Then
           begin
              Inc(Recno);
              Gis.UpdateProgress(Recno);
           end;
         End;
         SourceTable.Active:=false;
         DestTable.Active:=false;
         Gis.EndProgress;

         { erase old files }
         with ezbasegis.basetableclass.CreateNoOpen( Gis ) do
           try
             DBDropTable( FullName );
           finally
             free;
           end;

         Source := TemporaryDir + Layer.Name;
         Destination:= FullName;

         with ezbasegis.basetableclass.CreateNoOpen( Gis ) do
           try
             DBRenameTable( Source, Destination );
           finally
             free;
           end;

       except
         on E:Exception do
         begin
            ShowMessage( Format(SRestAborted, [E.Message]));
            raise;
         end;
       end;
     finally
       SourceTable.Free;
       DestTable.Free;
       Layer.Open;
     end;
  finally
     MapSource.Free;
     MapDest.Free;
     Screen.Cursor:=crDefault;
  end;
end;

procedure TfrmRestructDlg.FillWithDBInfo(  const Filename: String; DesignList, IndexList: TList  );
var
  I,L,D:integer;
  T:Char;
  Fullname, fname:String;
  DesignRecord: PDesignRecord;
  IndexRecord: PIndexingRec;
  ADBFTable: TEzBaseTable;
begin
  FullName := ChangeFileExt(FileName, '');
  ADBFTable := ezbasegis.BaseTableClass.Create(FLayer.Layers.Gis, FullName, true, true);
  try
     for I:= 1 To ADBFTable.FieldCount Do
     begin
        fname := ADBFTable.Field( I );
        T := ADBFTable.FieldType( I );
        L := ADBFTable.FieldLen( I );
        D := ADBFTable.FieldDec( I );
        New( DesignRecord );
        FillChar(DesignRecord^, SizeOf(TDesignRecord),0);
        with DesignRecord^ do
        begin
           FieldName:= fname;
           FieldType:= T;
           FieldSize:= L;
           FieldDec := D;
        end;
        DesignList.Add(DesignRecord);
        DesignRecord^.RecNo:= I;
     end;
     // Indexes
     ADBFTable.Index(FullName, '');
     for I:= 1 to ADBFTable.IndexCount do
     begin
        New( IndexRecord );
        with IndexRecord^ do
        begin
           IndexName := ADBFTable.IndexTagName( I );
           KeyExpression := ADBFTable.IndexExpression( I );
           ForExpression := ADBFTable.IndexFilter( I );

           if ADBFTable.IndexUnique( I ) Then
              Unique := EzBasegis.iuUnique
           else
              Unique := EzBasegis.iuDuplicates;

           if ADBFTable.IndexAscending( I ) Then
              SortStatus := EzBasegis.ssAscending
           else
              SortStatus := EzBasegis.ssDescending;
        end;
        IndexList.Add( IndexRecord );
     end;
  finally
     ADBFTable.Free;
  end;
end;


Procedure ClearIndexList(IndexList: TList);
Var
  I:integer;
Begin
  For I:=0 To IndexList.Count-1 Do
     Dispose( PIndexingRec(IndexList[I]) );
  IndexList.Clear;
End;

Procedure ClearDesignList(DesignList: TList);
Var
  I: integer;
Begin
  For I:= 0 To DesignList.Count-1 Do
     Dispose(PDesignRecord(DesignList[I]));
  DesignList.Clear;
End;

// TfrmRestructDlg class implementation

function TfrmRestructDlg.Enter( Layer: TEzBaseLayer ):word;
var
  I: integer;
  DesignRecord: PDesignRecord;
begin
  FDesignTable:= TEzDesignTable.Create(Self);
  FDesignTable.BeforePost:= dsDesignBeforePost;
  FDesignTable.AfterDelete:= dsDesignAfterDelete;
  FDesignTable.BeforeEdit:= dsDesignBeforeEdit;
  FDesignTable.BeforeDelete:= dsDesignBeforeDelete;
  DataSource1.DataSet:= FDesignTable;

  FLayer := Layer;
  FullName := FLayer.FileName;

  Caption := Format( SRestructureCaption, [FLayer.Name] );

  DesignList := TList.Create;
  IndexList := TList.create;
  FillWithDBInfo(FullName, DesignList, IndexList);

  FDesignTable.Open;

  for I:= 0 to DesignList.Count-1 do
  begin
     DesignRecord := PDesignRecord(DesignList[I]);
     with FDesignTable do
     begin
       Insert;
       FieldByName('FIELDNAME').AsString := DesignRecord^.FieldName;
       FieldByName('TYPE').AsString      := DesignRecord^.FieldType;
       FieldByName('SIZE').AsInteger     := DesignRecord^.FieldSize;
       FieldByName('DEC').AsInteger      := DesignRecord^.FieldDec;
       FieldByName('ORIG_FIELDNO').AsInteger := DesignRecord^.Recno;
       Post;
     end;
  end;
  FDesignTable.First;

  for I:= 0 to IndexList.Count-1 do
     List1.Items.Add(PIndexingRec(IndexList[I])^.IndexName);

  bIndexModified := False;
  bFieldsModified:= False;

  LblStatus.Caption := SRestMsg1;

  Result := ShowModal;
end;

procedure TfrmRestructDlg.DBGrid1ColEnter(Sender: TObject);
Var
  Field: TField;
Begin
  Field:= DBGrid2.SelectedField;
  If Field=Nil Then exit;
  If Field.FieldName = 'FIELDNAME' Then
     LblStatus.Caption:= SRestMsg1
  Else If Field.FieldName = 'TYPE' Then
     LblStatus.Caption:= SRestmsg2
  Else If Field.FieldName = 'SIZE' Then
     LblStatus.Caption:= SRestMsg3
  Else If Field.FieldName = 'DEC' Then
     LblStatus.Caption:= SRestMsg4;
End;

Procedure TfrmRestructDlg.OKBtnClick(Sender: TObject);
Var
  I,bm: Integer;
  DesignRecord:PDesignRecord;
  FieldList: TStringList;
  _Field: string;
  _Type: Char;
  _Len: integer;
  _Dec: integer;

Begin

  If FDesignTable.State in [dsEdit,dsInsert] then FDesignTable.Post;

  If Not (bIndexModified or bFieldsModified) Then
  Begin
     ModalResult:= mrOk;
     Exit;
  End;

  If Application.MessageBox(pchar(SRestLongWarning),pchar(SMsgConfirm),
       MB_YESNO or MB_ICONQUESTION)<>IDYES Then Exit;
  Screen.Cursor := crHourglass;
  bm := FDesignTable.RecNo;
  FDesignTable.DisableControls;
  FieldList:= TStringList.Create;
  Try
    {Create new table}
    FDesignTable.First;
    while not FDesignTable.EOF do
    begin
       _Field := FDesignTable.FieldByName('FIELDNAME').AsString;
       _Type  := AnsiUpperCase(FDesignTable.FieldByName('TYPE').AsString)[1];
       _Len:= 0;
       _Dec:= 0;
       case _Type of
          'C': begin
            _Len   := FDesignTable.FieldByName('SIZE').AsInteger;
          end;
          'L': begin
            _Len   := 1;
          end;
          'D': begin
            _Len   := 8;
          end;
          'N': begin
            _Len   := FDesignTable.FieldByName('SIZE').AsInteger;
            _Dec   := FDesignTable.FieldByName('DEC').AsInteger;
          end;
          'M', 'B':
          begin
          end;
       end;
       FieldList.Add(Format('%s;%s;%d;%d', [_Field, _Type, _Len, _Dec]));

       FDesignTable.Next;
    end;
    For I:= 0 to DesignList.Count - 1 Do
    Begin
       DesignRecord:= PDesignRecord(DesignList[I]);
       DesignRecord^.IsNewField:= True;
       FDesignTable.First;
       While Not FDesignTable.EOF Do
       Begin
          If DesignRecord^.RecNo = FDesignTable.FieldByName('ORIG_FIELDNO').AsInteger Then
          Begin
             DesignRecord^.IsNewField:= False;
             DesignRecord^.NewFieldName := FDesignTable.FieldByName('FIELDNAME').AsString;
             Break;
          End;

          FDesignTable.Next;
       End;
    End;
    if not DoRestructure(FLayer, DesignList, IndexList, FieldList) then
       ModalResult:= mrNone;
  Finally
    FDesignTable.RecNo:= bm;
    FDesignTable.EnableControls;
    FieldList.Free;
    Screen.Cursor:=crDefault;
  End;
End;

Procedure TfrmRestructDlg.FormDestroy(Sender: TObject);
Begin
  ClearDesignList(DesignList);
  DesignList.free;
  ClearIndexList(IndexList);
  IndexList.Free;
  FDesignTable.Close;
End;

Procedure TfrmRestructDlg.Button2Click(Sender: TObject);
Var
  Index: integer;
Begin
  Index:=List1.ItemIndex;
  If Index < 0 Then exit;
  Dispose(PIndexingRec(IndexList[Index]));;
  IndexList.Delete(Index);
  List1.Items.Delete(Index); bIndexModified:=true;
End;

procedure TfrmRestructDlg.Button1Click(Sender: TObject);
var
  cnt:integer;
  IndexRecord: PIndexingRec;
  iname:string;
begin
  with TfrmAddIndex.create(Nil) do
     try
        FDesignTable.DisableControls;
        try
          FDesignTable.first;
          while not FDesignTable.eof do
          begin
             List2.Items.Add(FDesignTable.FieldByName('FIELDNAME').AsString);
             FDesignTable.next;
          end;
        finally
          FDesignTable.EnableControls;
        end;
        if ShowModal = mrOk then
        begin
           if AnsiPos( '+', Edit2.Text ) = 0 then
             iname:= AnsiUpperCase(Edit2.Text);
           if (InputQuery(SNewIndexTitle, SNewIndexQuery, iName) = false) or
              (Length(iName)=0) then
           begin
              Free; Exit;
           end;
           iName:= AnsiUpperCase(iName);
           for cnt:= 0 to IndexList.count-1 do
           begin
              if AnsiCompareText(PIndexingRec(IndexList[cnt])^.IndexName, iName)=0 then
              begin
                 MessageToUser(SDuplicateIndex, smsgerror,MB_ICONERROR);
                 Free; Exit;
              end;
           end;
           if Length(Edit2.Text)=0 then
           begin
              MessageToUser(SInvalidDBFExpression, smsgerror,MB_ICONERROR);
              Free; Exit;
           end;
           New( IndexRecord );
           IndexRecord^.IndexName := iName;
           IndexRecord^.KeyExpression := Edit2.Text;
           IndexRecord^.ForExpression := Edit3.Text;
           if Check1.State = cbChecked then
              IndexRecord^.Unique:=EzBasegis.iuUnique
           else
              IndexRecord^.Unique:=EzBasegis.iuDuplicates;
           if Check2.State = cbChecked then
              IndexRecord^.SortStatus:= EzBasegis.ssDescending
           else
              IndexRecord^.SortStatus:= EzBasegis.ssAscending;
           List1.Items.Add(iName);
           IndexList.Add(IndexRecord);
           bIndexModified:=true;
        end;
     finally
        Free;
     end;
end;

procedure TfrmRestructDlg.Button3Click(Sender: TObject);
var
  IndexRecord: PIndexingRec;
begin
  if List1.ItemIndex < 0 then Exit;
  with TfrmAddIndex.create(Nil) do
     try
        FDesignTable.DisableControls;
        try
          FDesignTable.first;
          while not FDesignTable.eof do
          begin
             List2.Items.Add(FDesignTable.FieldByName('FIELDNAME').AsString);
             FDesignTable.next;
          end;
        finally
          FDesignTable.EnableControls;
        end;
        IndexRecord := PIndexingRec(IndexList[List1.ItemIndex]);
        if IndexRecord^.Unique = EzBasegis.iuUnique then
           Check1.State := cbChecked
        else
           Check1.State := cbUnChecked;
        if IndexRecord^.SortStatus=EzBasegis.ssDescending then
           Check2.State := cbChecked
        else
           Check2.State := cbUnChecked;
        Edit2.Text := IndexRecord^.KeyExpression;
        Edit3.Text := IndexRecord^.ForExpression;
        if ShowModal = mrOk then
        begin
           if Length(Edit2.Text)=0 then
           begin
              MessageToUser(SInvalidDBFExpression, smsgerror,MB_ICONERROR);
              Free; Exit;
           end;
           IndexRecord^.KeyExpression := Edit2.Text; bIndexModified:=true;
           IndexRecord^.ForExpression := Edit3.Text;
           if Check1.State = cbChecked then
              IndexRecord^.Unique:= EzBasegis.iuUnique
           else
              IndexRecord^.Unique:= EzBasegis.iuDuplicates;
           if Check2.State = cbChecked then
              IndexRecord^.SortStatus:= EzBasegis.ssDescending
           else
              IndexRecord^.SortStatus:= EzBasegis.ssAscending;
        end;
     finally
        Free;
     end;
end;

procedure TfrmRestructDlg.dsDesignBeforePost(DataSet: TDataSet);
var
  s: ShortString;
  cnt: integer;
begin
  s:= AnsiUpperCase(FDesignTable.FieldByName('FIELDNAME').AsString);
  if (Length(s)<1) or (Length(s)>10) or not ( s[1] in PrimaryIdentChars )
     or (AnsiPos(' ', s) > 0) then
  begin
     ShowMessage(SIncorrectFieldName);
     SysUtils.Abort;
  end;
  for cnt:=1 to Length(s) do
  begin
     if not (s[cnt] in IdentChars) then
     begin
       ShowMessage(SIncorrectFieldName);
       SysUtils.Abort;
     end;
  end;
  s:= FDesignTable.FieldByName('TYPE').AsString;
  if Length(s)=0 then
  begin
     ShowMessage(SUnspecifiedFieldType);
     SysUtils.Abort;
  end;
  if not (s[1] in ['C','L','D','N','M','B','G']) then
  begin
     ShowMessage(SIncorrectFieldType);
     SysUtils.Abort;
  end;
  if s[1] in ['B','G','M','D'] then
  begin
     FDesignTable.FieldByName('SIZE').AsString:='';
     FDesignTable.FieldByName('DEC').AsString:='';
  end;
  if s[1] in ['C', 'N'] then
  begin
     if s[1] = 'C' then
        FDesignTable.FieldByName('DEC').AsString:='';
     if not (FDesignTable.FieldByName('SIZE').AsInteger in [1..254]) then
     begin
        ShowMessage(SIncorrectFieldSize);
        SysUtils.Abort;
     end;
     if (s[1] = 'N') and not (FDesignTable.FieldByName('DEC').AsInteger in [0..10]) then
     begin
        ShowMessage(SIncorrectDecimals);
        SysUtils.Abort;
     end;
     if ( s[1] = 'N') and (FDesignTable.FieldByName('DEC').AsInteger>0)
        and (FDesignTable.FieldByName('DEC').AsInteger >
        FDesignTable.FieldByName('SIZE').AsInteger-2) then
     begin
        ShowMessage(SIncorrectDecimals);
        SysUtils.Abort;
     end;
  end else
     FDesignTable.FieldByName('SIZE').AsString:='';
  bFieldsModified:= true;
end;

procedure TfrmRestructDlg.DBGrid2ColEnter(Sender: TObject);
var
  Field: TField;
begin
  Field:= DBGrid2.SelectedField;
  if Field = Nil then Exit;
  if Field.FieldName = 'FIELDNAME' then
     LblStatus.Caption:= SFieldNameCaption
  else if Field.FieldName = 'TYPE' then
     LblStatus.Caption:= SFieldSelectF2
  else if Field.FieldName = 'SIZE' then
     LblStatus.Caption:= SFieldSizeCaption
  else if Field.FieldName = 'DEC' then
     LblStatus.Caption:= SFieldDecCaption;
end;

procedure TfrmRestructDlg.BtnRegenClick(Sender: TObject);
var
  cnt: integer;
  IndexRecord: PIndexingRec;
  TmpTable: TEzBaseTable;
begin
  if IndexList.Count = 0 then
  begin
     with ezbasegis.basetableclass.CreateNoOpen( FLayer.Layers.Gis ) do
       try
         DBDropIndex( FullName );
       finally
         free;
       end;
     Exit;
  end;
  Screen.Cursor:=crHourglass;
  TmpTable:= ezbasegis.BaseTableClass.Create( FLayer.Layers.Gis, FullName,true,true );
  Try
     For cnt:= 0 to IndexList.count-1 do
     begin
        IndexRecord:=PIndexingRec(IndexList[cnt]);
        With IndexRecord^ Do
        Begin
            TmpTable.IndexOn( FullName, IndexName, KeyExpression,
               ForExpression, Unique, SortStatus );
        End;
     End;
  Finally
    TmpTable.Free;
  End;
  Screen.Cursor:=crDefault;
  ShowMessage(SIndexRegenInfo);
end;

procedure TfrmRestructDlg.dsDesignAfterDelete(DataSet: TDataSet);
begin
  bFieldsModified:=true;
end;

procedure TfrmRestructDlg.dsDesignBeforeEdit(DataSet: TDataSet);
begin
   //if DataSet.FieldByName('FIELDNAME').AsString='UID' then
   //   Exception.Create('This field cannot be edited');
end;

procedure TfrmRestructDlg.dsDesignBeforeDelete(DataSet: TDataSet);
begin
   //if DataSet.FieldByName('FIELDNAME').AsString='UID' then
   //   Exception.Create('This field cannot be edited');
end;

//After User Select Field Type, Cursor will move to Next Field
//This can prevent to confuing user what he does select field.
procedure TfrmRestructDlg.DataSource1DataChange(Sender: TObject; Field: TField);
Var ALen, Adec : Integer;
    AType : Char;
begin
  if (Field<>Nil) and (FDesignTable<>Nil) and (FDesignTable.Active)then
    if not FChangingValue and (Field.FieldNo=2) and (DataSource1.State=dsInsert) then
    begin
      AType  := AnsiUpperCase(Field.AsString)[1];
      //Set Default Field Value;
      If AType = 'C' Then
      Begin
        ALen   := 40;
        ADec   := 0;
      End Else If AType = 'L' Then
      Begin
        ALen   := 1;
        ADec   := 0;
      End Else If AType = 'D' Then
      Begin
        ALen   := 8;
        ADec   := 0;
      End Else If AType = 'N' Then
      Begin
        ALen   := 12;
        ADec   := 2;
      End Else If AType In ['M', 'B', 'G'] Then
      Begin
        ALen   := 10;
        ADec   := 0;
      End Else
      Begin
        ALen   := 10;
        ADec   := 0;
      End;
      FChangingValue:= TRUE;
      FDesignTable.Fields[2].AsInteger := ALen;
      FDesignTable.Fields[3].AsInteger := ADec;
      DBGrid2.SelectedField := FDesignTable.Fields[2];
      FChangingValue:= FALSE;
    end;
end;

procedure TfrmRestructDlg.DBNavigator1Click(Sender: TObject; Button: TNavigateBtn);
begin
  if Button = nbInsert then
  begin
     FDesignTable.Last;
     FDesignTable.Append;
     FDesignTable.Edit;
  end;
end;

end.
