unit DataSetEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, DB, Grids, DBGrids, DBActns, ActnList;

type
  TfrmDataSetEditor = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    DataSource: TDataSource;
    ActionList: TActionList;
    acInsert: TDataSetInsert;
    acDelete: TDataSetDelete;
    acEdit: TDataSetEdit;
    acClose: TAction;
    Panel2: TPanel;
    Panel3: TPanel;
    DBGrid: TDBGrid;
    Edit1: TEdit;
    Button6: TButton;
    procedure FormResize(Sender: TObject);
    procedure acCloseExecute(Sender: TObject);
    procedure acCloseUpdate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function ShowDataSetEditor(Title: String;
                             DataSet: TDataSet;
                             VisibleFields: array of String;
                             FieldCaptions: array of String;
                             ResultFields: array of String;
                             var Results: Variant;
                             CanNew: Boolean = False;
                             CanEdit: Boolean = False;
                             CanDelete: Boolean = False): Boolean;

implementation

{$R *.dfm}

function ShowDataSetEditor(Title: String;
                           DataSet: TDataSet;
                           VisibleFields: array of String;
                           FieldCaptions: array of String;
                           ResultFields: array of String;
                           var Results: Variant;
                           CanNew: Boolean = False;
                           CanEdit: Boolean = False;
                           CanDelete: Boolean = False): Boolean;
var
  i: Integer;
begin
  with TfrmDataSetEditor.Create(nil) do
  begin
    Button3.Enabled := CanNew;
    Button4.Enabled := CanDelete;
    Button5.Enabled := CanEdit;
    DataSource.DataSet := DataSet;
    Caption := Title;
    for i := 0 to Length(VisibleFields) - 1 do
    with DBGrid.Columns.Add do
    begin
      FieldName := VisibleFields[i];
      Title.Caption := FieldCaptions[i];
    end;
    result := ShowModal = mrOK;
    if result then
    begin
//      Results := VarArrayCreate([Length(ResultFields)], varString);
      for i := 0 to Length(ResultFields) - 1 do
        Results[i] := DataSet.FieldValues[ResultFields[i]];
    end;
    Release;
  end;
end;

procedure TfrmDataSetEditor.FormResize(Sender: TObject);
begin
  Button2.Top := Panel1.Height - 20 - Button2.Height;
end;

procedure TfrmDataSetEditor.acCloseExecute(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TfrmDataSetEditor.acCloseUpdate(Sender: TObject);
begin
  acClose.Enabled := not DataSource.DataSet.IsEmpty;
end;

procedure TfrmDataSetEditor.Edit1Change(Sender: TObject);
var
  bkm: TBookmark;
begin
  if Length(Edit1.Text) > 0 then
  with DataSource.DataSet do
  begin
    bkm := GetBookmark;
    DisableControls;
    try
      First;
      while not Eof do
        if Pos(AnsiUpperCase(Edit1.Text), AnsiUpperCase(DBGrid.SelectedField.AsString)) > 0 then
          BREAK
        else
          GotoBookmark(bkm);
    finally
      EnableControls;
      FreeBookmark(bkm);
    end;
  end;
end;

procedure TfrmDataSetEditor.Button3Click(Sender: TObject);
begin
  DataSource.DataSet.Append;
end;

procedure TfrmDataSetEditor.Button4Click(Sender: TObject);
begin
  if MessageDlg('Удалить запись?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    DataSource.DataSet.Delete;  
end;

procedure TfrmDataSetEditor.Button5Click(Sender: TObject);
begin
  DataSource.DataSet.Edit;
end;

end.
