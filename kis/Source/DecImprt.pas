unit DecImprt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, FileCtrl, ExtCtrls, ComCtrls, Db,
  IBDatabase, IBSQL, IBCustomDataSet, IBQuery, Variants,
  //
  JvComponentBase, JvFormPlacement,
  //
  uCommonUtils, uClasses, uDB,
  //
  uKisConsts;

type
  TDecreeImportForm = class(TForm)
    pnlBottom: TPanel;
    AutoBox: TGroupBox;
    NoBox: TCheckBox;
    DateBox: TCheckBox;
    ImportBtn: TButton;
    DelBtn: TButton;
    pnlLeft: TPanel;
    DriveBox: TDriveComboBox;
    DirBox: TDirectoryListBox;
    FileBox: TFileListBox;
    FilterBox: TFilterComboBox;
    cbConvert: TCheckBox;
    FormStorage: TJvFormStorage;
    memText: TMemo;
    cbDelete: TCheckBox;
    edtNumberOrder: TEdit;
    udNumberOrder: TUpDown;
    Query: TIBSQL;
    Transaction: TIBTransaction;
    ibsInsert: TIBSQL;
    ibsUpdate: TIBSQL;
    Label1: TLabel;
    cbDecreeType: TComboBox;
    ibqDecreeTypes: TIBQuery;
    procedure ImportBtnClick(Sender: TObject);
    procedure DelBtnClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure cbConvertClick(Sender: TObject);
    procedure FileBoxClick(Sender: TObject);
    procedure memTextExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    CurDataSet: TDataSet;
//    procedure UpdateFileBox;
    procedure LoadFile;
    procedure SaveFile;
  public
  end;

function DecreeImportShow(DataSet: TDataSet): Boolean;
function GetNumber(Sts: TStrings): String;
function GetDate(Sts: TStrings): TDateTime;
function GetHeader(Sts: TStrings): String;

implementation

{$R *.DFM}

uses
  AProc6, AString6, AFile6, DecReplace,
  uKisAppModule;

function DecreeImportShow(DataSet: TDataSet): Boolean;
begin
  with TDecreeImportForm.Create(Application) do
  try
  	FileBox.Mask := FilterBox.Mask;
    CurDataSet := DataSet;
    //заполняем типы нормативных актов
    with ibqDecreeTypes do begin
      Open;
      while not Eof do begin
        cbDecreeType.Items.Add(FieldByName(SF_NAME).AsString);
        Next;
      end;
    end;
    if cbDecreeType.Items.Count > N_ZERO then
       cbDecreeType.ItemIndex := N_ZERO;
	  Result := (ShowModal = mrOk);
  finally
		Free;
	end;
end;

procedure TDecreeImportForm.ImportBtnClick(Sender: TObject);
var
  I, DecreeTypeId: Integer;
  SourceFile, TempFile, NewNumber, DocNumber: string;
  DocDate: TDateTime;
  Sts, StsOld: TStrings;
  RecordExists: Boolean;
begin
  if MessageBox(Self.Handle, PChar(S_IMPORT_ACTS
    + IntToStr(FileBox.SelCount)), PChar(S_CONFIRM),
    MB_ICONQUESTION + MB_OKCANCEL) <> IDOK
  then
    Exit;
  CurDataSet.Last;
  NewNumber:=CurDataSet.FieldByName(SF_INT_NUMBER).AsString;
  //Transaction.StartTransaction;
  Sts:=TStringList.Create;
  StsOld:=TStringList.Create;
  with FileBox do
  try
    SetHgCursor;
    //находим тип документа
    ibqDecreeTypes.RecNo:=cbDecreeType.ItemIndex+1;
    DecreeTypeId:=ibqDecreeTypes.FieldByName(SF_ID).AsInteger;
    TempFile := AFile6.GetTempFileName;
    for I := N_ZERO to Pred(Items.Count) do
      if Selected[I] then
      begin
      //проверяем наличие текстового файла
        SourceFile := Directory + '\' + Items.Strings[I];
        if not FileExists(SourceFile) then
        if MessageBox(Self.Handle, PChar(S_FILE + SourceFile + S_NOT_FOUND),
          PChar(S_WARN), MB_ICONWARNING + MB_OKCANCEL) = ID_CANCEL
        then
          Break
        else
          Continue;
				//конвертируем исходный файл во временный
        if cbConvert.Checked then
          OEMFile(SourceFile,True,TempFile)
        else
          AFile6.CopyFile(SourceFile,TempFile);
        Sts.LoadFromFile(TempFile);
        DocNumber:=GetNumber(Sts);
        DocDate:=GetDate(Sts);
        //проверяем наличие в базе этого документа
        with Query do
        begin
          SQL.Clear;
          SQL.Add('SELECT CONTENT FROM DECREES WHERE DOC_DATE='+
            QuotedStr(DateToStr(DocDate))+' AND DOC_NUMBER='+QuotedStr(DocNumber));
          ExecQuery;
          try
            RecordExists := not Eof;
            if RecordExists then StsOld.Text := Fields[N_ZERO].AsString;
          finally
            Close;
          end;
        end;
        if RecordExists then
          if ShowDecReplace(StsOld, Sts) then
            with ibsUpdate do
            begin
              //заменяем запись
              Params.ByName(SF_DOC_DATE).AsDate:=DocDate;
              Params.ByName(SF_DOC_NUMBER).AsString:=DocNumber;
              Params.ByName(SF_DECREE_TYPES_ID).AsInteger:=DecreeTypeId;
              Params.ByName(SF_HEADER).AsString:=GetHeader(Sts);
              Params.ByName(SF_CONTENT).Value:=Sts.Text;
              ExecQuery;
            end
          else Continue
        else
        begin
          //добавляем запись
          with ibsInsert do
          begin
            try
              Params.ByName(SF_ID).AsInteger := AppModule.GetID(ST_DECREES, Transaction);
            finally
            end;
            Params.ByName(SF_DOC_DATE).AsDate := DocDate;
            Params.ByName(SF_DOC_NUMBER).AsString := DocNumber;
            if NoBox.Checked then
              Params.ByName(SF_INT_NUMBER).AsString := GetNextNumber(NewNumber,udNumberOrder.Position)
            else
              Params.ByName(SF_INT_NUMBER).Value := Unassigned;
            if DateBox.Checked then
              Params.ByName(SF_INT_DATE).AsDate:=SysUtils.Date
            else
              Params.ByName(SF_INT_DATE).Value := Unassigned;
            Params.ByName(SF_DECREE_TYPES_ID).AsInteger:=DecreeTypeId;
            Params.ByName(SF_HEADER).AsString:=GetHeader(Sts);
            Params.ByName(SF_CONTENT).Value:=Sts.Text;
            ExecQuery;
          end;
        end;
        Transaction.CommitRetaining;
				//удаляем исходный файл
        if cbDelete.Checked and (not DeleteFile(SourceFile)) and
          (MessageBox(Self.Handle, PChar(S_CANT_DELETE_FILE + SourceFile),
            PChar(S_WARN), MB_ICONWARNING + MB_OKCANCEL) = ID_CANCEL)
        then Break;
        Application.ProcessMessages;
    end;
  finally
    Transaction.CommitRetaining;
    DeleteFile(TempFile);
    FileBox.Update;
    Sts.Free;
    StsOld.Free;
    ActiveControl:=FileBox;
    SetNormCursor;
  end;
  CurDataSet.AdvReopen();
end;

procedure TDecreeImportForm.DelBtnClick(Sender: TObject);
var
	I: Integer;
  DeletedFile: string;
begin
  if MessageBox(Self.Handle, PChar(S_CONFIRM_DELETE_SELECTED_FILES), PChar(S_CONFIRM),
       MB_ICONQUESTION + MB_OKCANCEL) <> IDOK then Exit;
  with FileBox do
  begin
    for I := N_ZERO to Pred(Items.Count) do
      if Selected[I] then
      begin
        DeletedFile := Directory + '\' + Items.Strings[I];
        if (not DeleteFile(DeletedFile)) and
           (MessageBox(Self.Handle, PChar(S_CANT_DELETE_FILE + DeletedFile),
           PChar(S_WARN), MB_ICONWARNING + MB_OKCANCEL) = IDCANCEL)
        then Break;
      end;
    Update;
  end;
  ActiveControl := FileBox;
end;

function GetNumber(Sts: TStrings): String;
var
	I, J: Integer;
begin
  if Sts.Pos('N', I, J) then
    Result := Trim(Copy(Sts[I], Succ(J), Length(Sts[I])));
  I := Pos(#32, Result);
  if I > N_ZERO then Result := Copy(Result, N_ONE, Pred(I));
end;

function GetDate(Sts: TStrings): TDateTime;
var
	I,J,CurD: Integer;
  Ok: Boolean;
  D: Array [1..3] of String;

  procedure SetNul;
  begin
  	CurD := N_ONE;
    D[N_ONE] := '';
    D[N_TWO] := '';
    D[N_THREE] := '';
  end;

  procedure SetOk;
  begin
		if (CurD = N_THREE) and (Length(D[N_THREE]) in [N_TWO, 4])
     then Ok := True
		else
      SetNul;
  end;

begin
	Ok:=False;
	SetNul;
	with Sts do
  	for I := N_ZERO to Pred(Count) do begin
			for J:= N_ONE to Length(Strings[I]) do begin
      	if Strings[I][J] in NumberChars then
          D[CurD]:=D[CurD]+Strings[I][J]
        else if Strings[I][J] in ['.','/','\'] then
					case CurD of
          	N_ONE: if Length(D[CurD]) in [N_ONE,N_TWO] then CurD:=N_TWO
            	 else SetNul;
          	N_TWO: if Length(D[CurD]) in [N_ONE,N_TWO] then CurD:=N_THREE
            	 else SetNul;
	 	      end
        else
        	SetOk;
        if J=Length(Strings[I]) then SetOk;
        if Ok then break;
      end;
      if Ok then break;
    end;
  if Ok then
		Result:=StrToDate(Trim(D[1])+DateSeparator+Trim(D[2])+DateSeparator+Trim(D[3]))
	else
  	Result:=Date;
end;

function GetHeader(Sts: TStrings): String;
var
	I: Integer;
  Inside: Boolean;
begin
  Inside:=False;
  Result:='';
	with Sts do
  	for I:=N_ZERO to Pred(Count) do begin
    	Strings[I]:=Trim(Strings[I]);
    	if (System.Pos('О ',Strings[I]) = N_ONE) or (System.Pos('Об ',Strings[I])=N_ONE) then
        Inside := True;
      if Inside then
      begin
				if Strings[I]='' then
          break;
      	Result:=Result+Strings[I];
				//обработка переносов
  	    if Result[Length(Result)]='-' then
    	  	System.Delete(Result,Length(Result),1)
      	else
      		Result:=Result+' ';
      end;
    end;
  Result:=Trim(Result);
end;
                      {
procedure TDecreeImportForm.UpdateFileBox;
var
  Index: Integer;
begin
  with FileBox do
  begin
    Update;
{    Index:=ItemIndex;
    Count:=Items.Count;
    Update;
    Index:=Index-(Count-Items.Count)+1;
    if Index<0 then Index:=0;
    if Index>Items.Count-1 then Index:=Items.Count-1;
    Selected[Index]:=True;
    OnClick(FileBox);
  end;
end;                 }

procedure TDecreeImportForm.FormResize(Sender: TObject);
begin
  FileBox.Height:=FilterBox.Top-FileBox.Top-8;
end;

//загружает файл в reText
procedure TDecreeImportForm.LoadFile;
var
  TempFileName: string;
begin
  if FileBox.FileName='' then Exit;
  if cbConvert.Checked then begin
    TempFileName:=GetTempFileName;
    try
      OEMFile(FileBox.FileName,True,TempFileName);
      memText.Lines.LoadFromFile(TempFileName);
    finally
      DeleteFile(TempFileName);
    end;
  end
  else
    memText.Lines.LoadFromFile(FileBox.FileName);
end;

//сохраняет файл
procedure TDecreeImportForm.SaveFile;
begin
  if (FileBox.FileName='')or(not memText.Modified) then Exit;
  memText.Lines.SaveToFile(FileBox.FileName);
  if cbConvert.Checked then OEMFile(FileBox.FileName,False);
end;

procedure TDecreeImportForm.cbConvertClick(Sender: TObject);
begin
  LoadFile;
end;

procedure TDecreeImportForm.FileBoxClick(Sender: TObject);
begin
  LoadFile;
end;

procedure TDecreeImportForm.memTextExit(Sender: TObject);
begin
  SaveFile;
end;

procedure TDecreeImportForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFile;
end;

end.
