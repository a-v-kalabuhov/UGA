unit fEzProviderWizard;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, EzInspect, StdCtrls, Menus, Buttons;

type
  TfrmEzProviderWizard = class(TForm)
    EzInspector: TEzInspector;
    PopupMenu1: TPopupMenu;
    Insert1: TMenuItem;
    Delete1: TMenuItem;
    Append1: TMenuItem;
    N1: TMenuItem;
    DeleteAll1: TMenuItem;
    Button1: TSpeedButton;
    Button2: TSpeedButton;
    btnUp: TSpeedButton;
    btnDown: TSpeedButton;
    btnErase: TSpeedButton;
    btnClear: TSpeedButton;
    btnInsert: TSpeedButton;
    btnEdit: TSpeedButton;
    N2: TMenuItem;
    MoveUp1: TMenuItem;
    MoveDown1: TMenuItem;
    Edit1: TMenuItem;
    BitBtn1: TBitBtn;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Insert1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure DeleteAll1Click(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure EzInspectorClick(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure EzInspectorMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    FPlp : TEzInspectorProvider;
    SelectedRow : Integer;
    Procedure UpdateButtons;
    Procedure EditProperty(Index : Integer);
  public
    { Public declarations }
    Procedure Enter(Plp : TEzInspectorProvider);
  end;

implementation

uses fPropertyWizard;

{$R *.DFM}

procedure TfrmEzProviderWizard.Button1Click(Sender: TObject);
Var
  Bp : TEzBaseProperty;
begin
  With TFrmPropertyWizard.Create(Application) Do
  Try
    Bp := CreateNewProperty;
    If Bp = Nil Then
      ShowMessage('Can''t add the property')
    Else
      Fplp.Add(Bp);
  Finally
   Free;
  End;
  Button2Click(Nil);
end;

procedure TfrmEzProviderWizard.Button2Click(Sender: TObject);
begin
 Fplp.PopulateTo(EzInspector,epaDisplayOnlyThis);
//  epaOverWrite)//
end;

procedure TfrmEzProviderWizard.Insert1Click(Sender: TObject);
Var
  Bp : TEzBaseProperty;
begin
  With TFrmPropertyWizard.Create(Application) Do
  Try
    Bp := CreateNewProperty;
    If Bp = Nil Then
      ShowMessage('Can''t add the property')
    Else
      Fplp.Insert(SelectedRow - 1, Bp);
  Finally
   Free;
  End;
  Button2Click(Nil);
end;

procedure TfrmEzProviderWizard.Delete1Click(Sender: TObject);
begin
  If Application.MessageBox('Are you sure ?','Warning', Mb_YEsNo) = IdNo then Exit;
  EzInspector.DeletePropertyByIndex(SelectedRow - 1);
  Fplp.Delete(SelectedRow - 1);
  EzInspector.Invalidate;
//  Button2Click(Nil);
end;

procedure TfrmEzProviderWizard.DeleteAll1Click(Sender: TObject);
begin
  If Application.MessageBox('This option clear all properties of list'+#13+
                            'Do you want to clear the list ?', 'Message', Mb_YesNo) = IdYes Then Begin
    EzInspector.ClearPropertyList;
    EzInspector.Invalidate;
    Fplp.Clear;
  End;
end;

procedure TfrmEzProviderWizard.Enter(Plp: TEzInspectorProvider);
begin
  FPlp := Plp;
  If FPlp = Nil Then
    ShowMessage('Inspector provider is nil')
  Else
    ShowModal;
end;

procedure TfrmEzProviderWizard.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmEzProviderWizard.FormShow(Sender: TObject);
begin
  EzInspector.DefaultColWidth := EzInspector.Width Div 2;
  If Fplp <> Nil Then
    Button2Click(Button2);    
end;

procedure TfrmEzProviderWizard.FormCreate(Sender: TObject);
begin
  FPlp := Nil;
end;

procedure TfrmEzProviderWizard.FormDestroy(Sender: TObject);
begin
  FPlp := Nil;
end;

procedure TfrmEzProviderWizard.BitBtn1Click(Sender: TObject);
begin
  ModalResult := mrOk;
  Close;
end;

procedure TfrmEzProviderWizard.UpdateButtons;
begin
  Insert1.Enabled := SelectedRow > 0;
  If (SelectedRow = 1) And (Fplp.ItemsCount = 0) Then
    Insert1.Enabled := False;
  Delete1.Enabled := Insert1.Enabled;
  btnErase.Enabled := Delete1.Enabled;
  Edit1.Enabled := Delete1.Enabled;
  btnEdit.Enabled := Edit1.Enabled;
  DeleteAll1.Enabled := FPlp.ItemsCount > 0;
  btnUp.Enabled := (SelectedRow > 1) And (Fplp.ItemsCount > 0);
  btnDown.Enabled := (SelectedRow < FPlp.ItemsCount) And (Fplp.ItemsCount > 0) And (SelectedRow >= 0);
  MoveUp1.Enabled := btnUp.Enabled;
  MoveDown1.Enabled := btnDown.Enabled;
end;

procedure TfrmEzProviderWizard.EzInspectorClick(Sender: TObject);
begin
  UpdateButtons;
end;

procedure TfrmEzProviderWizard.EditProperty(Index: Integer);
Var
  Tmpbp : TEzBaseProperty;
begin
  //EzInspector.DeletePropertyByIndex(Index);
  With TFrmPropertyWizard.Create( Nil ) Do
  Try
    TmpBp := FPlp.Items[Index];
    If ModifyProperty(TmpBp) Then Begin
      EzInspector.ClearPropertyList;
      Fplp.Items[Index] := TmpBp;
      Fplp.PropertyList.Items[Index].UpdateSetEnum;
      Fplp.PopulateTo(EzInspector, epaDisplayOnlyThis);
    End;
  Finally
    Free;
  End;
end;

procedure TfrmEzProviderWizard.Edit1Click(Sender: TObject);
begin
  EditProperty(SelectedRow - 1);
end;

procedure TfrmEzProviderWizard.btnUpClick(Sender: TObject);
begin
  if Not btnUp.Enabled Then Exit;
  EzInspector.TurnOffEditor;
  FPlp.ExChange(SelectedRow - 1, SelectedRow - 2);
  Fplp.PopulateTo(EzInspector,epaDisplayOnlyThis);
  Dec(SelectedRow);
  UpdateButtons;
  EzInspector.Row := SelectedRow;
  EzInspector.Invalidate;
end;

procedure TfrmEzProviderWizard.btnDownClick(Sender: TObject);
begin
  if Not btnDown.Enabled Then Exit;
  EzInspector.TurnOffEditor;
  FPlp.ExChange(SelectedRow - 1, SelectedRow);
  Fplp.PopulateTo(EzInspector,epaDisplayOnlyThis);
  Inc(SelectedRow);
  UpdateButtons;
  EzInspector.Row := SelectedRow;
  EzInspector.Invalidate;
end;

procedure TfrmEzProviderWizard.EzInspectorMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Coord: TGridCoord;
  p : TPoint;
begin
  Coord := (Sender As TCustomGrid).MouseCoord(X, Y);
  SelectedRow := Coord.Y;
  UpdateButtons;
  p.x := X;
  p.y := Y;
  p := ClientToScreen(p);
  If Button = mbRight Then PopupMenu1.Popup(p.X, p.Y);
end;

end.

