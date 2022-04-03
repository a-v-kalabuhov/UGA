unit fNewLayer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, Grids, DBGrids, ExtCtrls, DBCtrls, Buttons,
  DB, ezbasegis;

type
  TfrmNewLayer = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    chkAnimated: TCheckBox;
    chkCosmethic: TCheckBox;
    BtnAddFlds: TSpeedButton;
    GroupBox1: TGroupBox;
    DBNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    Button1: TButton;
    Button2: TButton;
    DataSource1: TDataSource;
    RadioGroup1: TRadioGroup;
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BtnAddFldsClick(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
  private
    { Private declarations }
    FDesignTable: TDataset;
    FFieldList: TStrings;
    FGis: TEzBaseGis;
    procedure dsDesignBeforePost(DataSet: TDataSet);
    procedure dsDesignBeforeEdit(DataSet: TDataSet);
    procedure dsDesignBeforeDelete(DataSet: TDataSet);
  public
    { Public declarations }
    function Enter( Gis: TEzBaseGis ): Word;
    property FieldList: TStrings read FFieldList;
  end;

implementation

{$R *.dfm}

uses
  ezimpl, ezbase, eztable, ezconsts;

resourcestring
  SUnspecifiedFieldType= 'Field type is wrong !';
  SEmptyLayername= 'Layer name cannot be empty !';
  SCopyFromTitle= 'Copy structure from';
  SIncorrectFieldName= 'Field name wrong !';
  SIncorrectFieldType= 'Field type is wrong !' + CrLf +
                       'Must be: C=CHAR,L=LOGIC,D=DATE,N=NUMERIC,M=MEMO,B=BINARY,G=GRAPHIC';
  SIncorrectFieldSize= 'Field size is wrong !' + CrLf + 'Must be between 1-254';
  SIncorrectDecimals= 'Number of decimals for field is wrong !' + CrLf +
                      'Must be 0-10';

{ TfrmNewLayer }

procedure TfrmNewLayer.dsDesignBeforeDelete(DataSet: TDataSet);
begin
  // dummy
end;

procedure TfrmNewLayer.dsDesignBeforeEdit(DataSet: TDataSet);
begin
  // dummy
end;

const
  Digits = ['0'..'9'];
  PrimaryIdentChars = ['A'..'Z', '_', #127..#255];
  IdentChars = PrimaryIdentChars + Digits;

procedure TfrmNewLayer.dsDesignBeforePost(DataSet: TDataSet);
var
  s: ShortString;
  i,cnt,maxstrsize: integer;
  found,Pass: Boolean;

begin
  s:= AnsiUpperCase(FDesignTable.FieldByName('FIELDNAME').AsString);
  if RadioGroup1.ItemIndex=0 then
    maxstrsize:= 100
  else
    maxstrsize:= 10;
  if (Length(s)<1) or (Length(s)>maxstrsize) or
     not(s[1] in PrimaryIdentChars) or (AnsiPos(' ', s) > 0) then
  begin
     ShowMessage('Incorrect field name');
     SysUtils.Abort;
  end;
  for cnt:=1 to Length(s) do
  begin
     if not (s[cnt] in IdentChars) then
     begin
       ShowMessage('Incorrect field name');
       SysUtils.Abort;
     end;
  end;
  s:= FDesignTable.FieldByName('TYPE').AsString;
  if Length(s)=0 then
  begin
     ShowMessage('Field type is not yet defined');
     SysUtils.Abort;
  end;
  if RadioGroup1.ItemIndex=0 then
  begin
    With DBGrid1.Columns[1] Do
    Begin
      found := false;
      For i := 0 To PickList.Count - 1 Do
        If AnsiCompareText( s, PickList[I] ) = 0 Then
        Begin
          found := true;
          break;
        End;
    End;
    Pass := Found;
  end else
    Pass:= (s[1] in ['C','L','D','N','M','B','G']);
  if not Pass then
  begin
     ShowMessage('Incorrect field type');
     SysUtils.Abort;
  end;
  if RadioGroup1.ItemIndex=1 then
  begin
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
          ShowMessage('Incorrect field size');
          SysUtils.Abort;
       end;
       if (s[1] = 'N')
          and not (FDesignTable.FieldByName('DEC').AsInteger in [0..10]) then
          begin
          ShowMessage('Incorrect number of decimals');
          SysUtils.Abort;
       end;
       if ( s[1] = 'N') and (FDesignTable.FieldByName('DEC').AsInteger>0)
          and (FDesignTable.FieldByName('DEC').AsInteger >
          FDesignTable.FieldByName('SIZE').AsInteger-2) then
       begin
          ShowMessage('Incorrect number of decimals');
          SysUtils.Abort;
       end;
    end else
       FDesignTable.FieldByName('SIZE').AsString:='';
  end;
end;

function TfrmNewLayer.Enter( Gis: TEzBaseGis ): Word;
begin
  FGis:= Gis;

  FFieldList:= TStringList.Create;

  FDesignTable:= TEzDesignTable.Create(Self);
  FDesignTable.BeforePost:= dsDesignBeforePost;
  FDesignTable.BeforeEdit:= dsDesignBeforeEdit;
  FDesignTable.BeforeDelete:= dsDesignBeforeDelete;
  DataSource1.DataSet:= FDesignTable;

  RadioGroup1.OnClick(nil);

  FDesignTable.Open;
  with FDesignTable do
  begin
    Insert;
    FieldByName('FIELDNAME').AsString := 'UID';
    FieldByName('TYPE').AsString      := 'Int';
    FieldByName('SIZE').AsInteger     := 11;
    FieldByName('DEC').AsInteger      := 0;
    Post;
  end;
  FDesignTable.First;

  Result:= showmodal;
end;

procedure TfrmNewLayer.FormDestroy(Sender: TObject);
begin
  FFieldList.free;
end;

procedure TfrmNewLayer.Button1Click(Sender: TObject);
begin
  if Length(Trim(Edit1.Text))=0 then
  begin
     ShowMessage(SEmptyLayername);
     ModalResult:= mrNone;
  end else
  begin
    If FDesignTable.State in [dsEdit,dsInsert] then FDesignTable.Post;
    FFieldList.Clear;
    FDesignTable.First;
    with FDesignTable do
      while not Eof do
      begin
        FFieldList.Add(Format('%s;%s;%d;%d', [FieldByName('FIELDNAME').AsString,
          FieldByName('TYPE').AsString, FieldByName('SIZE').AsInteger,
          FieldByName('DEC').AsInteger]));
        Next;
      end;
  end;
end;

procedure TfrmNewLayer.BtnAddFldsClick(Sender: TObject);
var
  Dbf: TEzBaseTable;
  I: Integer;
begin
  with TOpenDialog.Create(nil) do
  begin
     DefaultEXT:= 'DBF';
     Title:= 'Copy DBF structure from';
     Options:= [ofHideReadOnly,ofPathMustExist,ofFileMustExist];
     Filter:= 'DBase files (*.DBF)|*.DBF';
     try
        if not Execute then Exit;
        Dbf:= EzBasegis.BaseTableClass.Create(FGis, FileName, false, true);
        try
          for i:= 1 to Dbf.FieldCount do
          begin
            FDesignTable.Insert;
            FDesignTable.FieldByName('FIELDNAME').AsString:= Dbf.Field(i);
            FDesignTable.FieldByName('TYPE').AsString:= Dbf.FieldType(i);
            FDesignTable.FieldByName('SIZE').AsInteger:= Dbf.FieldLen(i);
            FDesignTable.FieldByName('DEC').AsInteger:= Dbf.FieldDec(i);
            FDesignTable.Post;
          end;
        finally
          Dbf.Free;
        end;
     finally
        Free;
     end;
  end;
end;

procedure TfrmNewLayer.RadioGroup1Click(Sender: TObject);
begin
  chkAnimated.Enabled:= (RadioGroup1.ItemIndex = 1);
  chkCosmethic.Enabled:=(RadioGroup1.ItemIndex = 1);
  if RadioGroup1.ItemIndex=0 then
  begin
    With DBGrid1.Columns[1].PickList Do
    Begin
      Clear;
      Add( 'char' );
      Add( 'bigint' );
      Add( 'binary' );
      Add( 'bit' );
      Add( 'datetime' );
      Add( 'decimal' );
      Add( 'float' );
      Add( 'image' );
      Add( 'int' );
      Add( 'money' );
      Add( 'nchar' );
      Add( 'ntext' );
      Add( 'numeric' );
      Add( 'nvarchar' );
      Add( 'real' );
      Add( 'smalldatetime' );
      Add( 'smallint' );
      Add( 'smallmoney' );
      Add( 'text' );
      Add( 'timestamp' );
      Add( 'tinyint' );
      Add( 'varbinary' );
      Add( 'varchar' );
    End;
  end else
  begin
    With DBGrid1.Columns[1].PickList Do
    Begin
      Clear;
      Add( 'C - CHARACTER' );
      Add( 'L - LOGICAL' );
      Add( 'D - DATE' );
      Add( 'N - NUMERIC' );
      Add( 'M - MEMO' );
      Add( 'B - BINARY' );
      Add( 'G - GRAPHIC' );
    end;
  end;
end;

end.
