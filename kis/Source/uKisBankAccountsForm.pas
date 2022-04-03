unit uKisBankAccountsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, Grids, DBGrids, uDBGrid, DB, ActnList;

type
  TKisBankAccountsForm = class(TForm)
    Grid: TkaDBGrid;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDel: TButton;
    btnOK: TBitBtn;
    btnClose: TBitBtn;
    DataSource: TDataSource;
    ActionList: TActionList;
    acClose: TAction;
    procedure acCloseUpdate(Sender: TObject);
    procedure GridExit(Sender: TObject);
    procedure acCloseExecute(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure GridColEnter(Sender: TObject);
    procedure GridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure GridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GridCellClick(Column: TColumn);
    procedure GridKeyPress(Sender: TObject; var Key: Char);
  private
    procedure DrawCheckBox(Canvas: TCanvas; const theValue: Boolean;
      const Rect: TRect; const State: TGridDrawState);
    procedure InvertBooleanField(theField: TField);
  protected
    function DataSet: TDataSet;
  end;

implementation

{$R *.dfm}

uses
  uKisConsts, uKisOrders, uKisAppModule, uKisClasses;

procedure TKisBankAccountsForm.acCloseUpdate(Sender: TObject);
begin
  btnDel.Enabled := Assigned(DataSource.DataSet) and not DataSource.DataSet.IsEmpty;
  btnEdit.Enabled := Assigned(DataSource.DataSet) and not DataSource.DataSet.IsEmpty;
end;

procedure TKisBankAccountsForm.GridExit(Sender: TObject);
begin
  if Assigned(DataSource.DataSet) and (DataSource.DataSet.State in [dsInsert, dsEdit]) then
    DataSource.DataSet.Post;
end;

procedure TKisBankAccountsForm.acCloseExecute(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

function TKisBankAccountsForm.DataSet: TDataSet;
begin
  Result := Grid.DataSource.DataSet;
end;

procedure TKisBankAccountsForm.btnAddClick(Sender: TObject);
begin
  DataSet.Append;
end;

procedure TKisBankAccountsForm.btnEditClick(Sender: TObject);
begin
  DataSet.Edit; 
end;

procedure TKisBankAccountsForm.btnDelClick(Sender: TObject);
begin
  if MessageBox(Handle,
                PChar(S_CONFIRM_DELETE_ACCOUNT),
                PChar(S_CONFIRM),
                MB_YESNO + MB_ICONQUESTION) = ID_YES
  then
    DataSet.Delete;
end;

procedure TKisBankAccountsForm.GridColEnter(Sender: TObject);
begin
  if Grid.SelectedField.DataType = ftBoolean then
    Grid.Options := Grid.Options - [dgEditing]
  else
    Grid.Options := Grid.Options + [dgEditing]
end;

procedure TKisBankAccountsForm.GridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  Grid: TDbGrid;
begin
  if Sender is TDBGrid then
    if Column.Field.DataType = ftBoolean then
    begin
      Grid := TDBGrid(Sender);
      if Column.ReadOnly then
        Grid.Canvas.Brush.Color := clBtnFace
      else
        Grid.Canvas.Brush.Color := clWindow;
      Grid.Canvas.FillRect(Rect);
      DrawCheckBox(Grid.Canvas, Column.Field.AsBoolean, Rect, State);
    end;
end;

procedure TKisBankAccountsForm.DrawCheckBox(Canvas: TCanvas; const theValue: Boolean; const Rect: TRect; const State: TGridDrawState);
var
  TmpBitmap: TBitmap;
  ImageInd: Integer;
  X, Y: Integer;
  OrderMngr: TKisOrderMngr;
begin
  TmpBitmap := TBitmap.Create;
  try
    OrderMngr := TKisOrderMngr(AppModule[kmOrders]);
    ImageInd := OrderMngr.GetCheckBoxImageIndex(theValue);
    OrderMngr.ImageList.GetBitmap(ImageInd, TmpBitmap);
    TmpBitmap.TransparentColor := TmpBitmap.Canvas.Pixels[0, 0];
    TmpBitmap.Transparent := True;
    X := Rect.Left + (Rect.Right - Rect.Left - TmpBitmap.Width) div 2;
    Y := Rect.Top + (Rect.Bottom - Rect.Top - TmpBitmap.Height) div 2; 
    Canvas.Draw(X, Y, TmpBitmap);
  finally
    TmpBitmap.Free; 
  end; 
end;

procedure TKisBankAccountsForm.GridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  DataSet: TDataSet;
  Grid: TDBGrid;
begin
  if Assigned(Sender) and (Sender is TDBGrid) then
    Grid := TDBGrid(Sender)
  else
    Exit; 
  DataSet := Grid.DataSource.DataSet;
  if not Assigned(DataSet) then
    Exit; 
  if Key = 32 then // Пробел
    if Grid.SelectedField.DataType = ftBoolean then
      InvertBooleanField(Grid.SelectedField);
end;

procedure TKisBankAccountsForm.GridCellClick(Column: TColumn);
begin
 if not Column.ReadOnly and (Column.Field.DataType = ftBoolean) then
    InvertBooleanField(Column.Field);
end;

procedure TKisBankAccountsForm.InvertBooleanField(theField: TField);
var
  NeedPost: Boolean;
begin
  if Assigned(theField) and not theField.ReadOnly then
  begin 
    NeedPost := not (theField.DataSet.State in [dsInsert, dsEdit]);
    if NeedPost then
      theField.DataSet.Edit;
    theField.AsBoolean := not theField.AsBoolean;
    if NeedPost then
      theField.DataSet.Post;
  end;
end;

procedure TKisBankAccountsForm.GridKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Grid.SelectedField.FieldName = SF_NUMBER then
  begin
    if not (Key in [#8, #13, '0'..'9']) then
    begin
      Key := #0;
      Beep;
    end;
  end;
end;

end.
