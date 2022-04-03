unit uMStFormKiosk;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  uMStKernelClasses, ComCtrls, StdCtrls, Buttons, Mask, JvExMask, JvToolEdit,
  JvMaskEdit, JvCheckedMaskEdit, JvDatePickerEdit, ExtCtrls, ExtDlgs, ImgList,
  DB, DBCtrls;

type
  TKioskStatus = (ksNone, ksNew, ksActual, ksAnnuled);

  TmstKioskForm = class(TForm)
    PageControl1: TPageControl;
    tsData: TTabSheet;
    TabSheet2: TTabSheet;
    btnOK: TButton;
    btnCancel: TButton;
    edAddress: TDBEdit;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    Label8: TLabel;
    edOrderNum: TDBEdit;
    Label9: TLabel;
    edOrderDate: TDBEdit;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    edLetterNum: TDBEdit;
    edLetterDate: TDBEdit;
    GroupBox3: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    edActNum: TDBEdit;
    edActDate: TDBEdit;
    cbKind: TComboBox;
    Label6: TLabel;
    TabSheet3: TTabSheet;
    Button1: TButton;
    Button2: TButton;
    edArea: TDBEdit;
    Label7: TLabel;
    Label10: TLabel;
    edPeriod: TDBEdit;
    Label11: TLabel;
    cbRegion: TComboBox;
    edExecutor: TDBEdit;
    Label12: TLabel;
    Label13: TLabel;
    mInfo: TDBMemo;
    Label14: TLabel;
    mLimit: TDBMemo;
    Label15: TLabel;
    mAnnulSource: TDBMemo;
    Label16: TLabel;
    lStatus: TLabel;
    tsCustomer: TTabSheet;
    gbCommon: TGroupBox;
    lName: TLabel;
    lAddress1: TLabel;
    lAddress2: TLabel;
    lINN: TLabel;
    lPhones: TLabel;
    edCustName: TDBEdit;
    edCustAddr1: TDBEdit;
    edCustAddr2: TDBEdit;
    edCustINN: TDBEdit;
    edCustPhone: TDBEdit;
    gbPersonDoc: TGroupBox;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    cbCustDocType: TComboBox;
    edCustDocNumber: TDBEdit;
    edCustDocSerie: TDBEdit;
    edCustDocOwner: TDBEdit;
    Label22: TLabel;
    cbCustomerKind: TComboBox;
    edCustDocDate: TDBEdit;
    btnAnnul: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    lvPoints: TListView;
    ImageList1: TImageList;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Label23: TLabel;
    edAnnulDate: TDBEdit;
    Panel1: TPanel;
    Image1: TImage;
    Button6: TButton;
    DataSource1: TDataSource;
    procedure btnAnnulClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FKiosk: TmstKiosk;
    FStatus: TKioskStatus;
    procedure SetKiosk(const Value: TmstKiosk);
    procedure SetStatus(const Value: TKioskStatus);
    procedure GetData(Kiosk: TmstKiosk);
    procedure SetData(Kiosk: TmstKiosk);
    procedure LoadPoints(Points: TmstLotPoints);
    procedure WritePoints(Points: TmstLotPoints);
  public
    property Kiosk: TmstKiosk read FKiosk write SetKiosk;
    property KioskStatus: TKioskStatus read FStatus write SetStatus;
  end;

implementation

{$R *.dfm}

uses
  uMStFormKioskList, uKisConsts, uMStKernelConsts;

{ TmstKioskForm }

procedure TmstKioskForm.btnAnnulClick(Sender: TObject);
begin
  if Trim(mAnnulSource.Lines.Text) = '' then
  begin
    PageControl1.ActivePage := tsData;
    mAnnulSource.SetFocus;
    MessageBox(Handle,
      'Обязательно заполните поле "Причина аннулирования"!',
      'Внимание',
      MB_OK + MB_ICONWARNING
      );
  end;
  KioskStatus := ksAnnuled;
  edAnnulDate.Field.AsDateTime := Date;
end;

procedure TmstKioskForm.btnOKClick(Sender: TObject);
var
  F: Double;
  Str: TStream;
begin
  if not TryStrToFloat(edArea.Text, F) then
  begin
    ShowMessage('Проверьте площадь!');
    PageControl1.ActivePage := tsData;
    edArea.SetFocus;
    Exit;
  end;
  //
  if Trim(edAddress.Text) = '' then
  begin
    ShowMessage('Введите адрес!');
    PageControl1.ActivePage := tsData;
    edAddress.SetFocus;
    Exit;
  end;
  //
  if cbRegion.ItemIndex < 0 then
  begin
    ShowMessage('Укажите район!');
    PageControl1.ActivePage := tsData;
    cbRegion.SetFocus;
    Exit;
  end;
  //
  if Trim(edCustName.Text) = '' then
  begin
    ShowMessage('Введите информацию о заказчике!');
    PageControl1.ActivePage := tsCustomer;
    edCustName.SetFocus;
    Exit;
  end;
  //
  DataSource1.DataSet.FieldByName(SF_REGION).AsString := cbRegion.Text;
  DataSource1.DataSet.FieldByName(SF_KIND).AsInteger := cbKind.ItemIndex;
  DataSource1.DataSet.FieldByName(SF_CUSTOMER_KIND).AsInteger := cbCustomerKind.ItemIndex;
  DataSource1.DataSet.FieldByName(SF_CUSTOMER_DOC_TYPE).AsString := cbCustDocType.Text;
  if KioskStatus = ksAnnuled then
    DataSource1.DataSet.FieldByName(SF_ACTUAL).AsInteger := 0
  else
    DataSource1.DataSet.FieldByName(SF_ACTUAL).AsInteger := 1;
  //
  Str := DataSource1.DataSet.CreateBlobStream(DataSource1.DataSet.FieldByName(SF_PHOTO), bmReadWrite);
  try
    if Assigned(Image1.Picture)
       and
       Assigned(Image1.Picture.Graphic)
       and
       (not Image1.Picture.Graphic.Empty)
    then
      Image1.Picture.Graphic.SaveToStream(Str)
    else
      DataSource1.DataSet.FieldByName(SF_PHOTO).Value := Null;
  finally
    Str.Free;
  end;
  //
  SetData(FKiosk);
  ModalResult := mrOK;
end;

procedure TmstKioskForm.Button1Click(Sender: TObject);
begin
  if OpenPictureDialog1.Execute() then
  begin
    Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
  end;
end;

procedure TmstKioskForm.Button2Click(Sender: TObject);
begin
  Image1.Picture.Assign(nil);
end;

procedure TmstKioskForm.Button3Click(Sender: TObject);
begin
  if MessageBox(Handle,
    'Удалить все точки?',
    'Внимание!',
    MB_YESNO + MB_ICONQUESTION) = ID_YES
  then
    lvPoints.Items.Clear;
end;

procedure TmstKioskForm.Button4Click(Sender: TObject);
var
  Tmp: TmstLotPoints;
begin
  Tmp := TmstLotPoints.Create;
  try
    if Tmp.LoadFromClipBoard then
      LoadPoints(Tmp)
    else
      ShowMessage('Не удалось обработать данные в буфере обмена!');
  finally
    Tmp.Free;
  end;
end;

procedure TmstKioskForm.Button6Click(Sender: TObject);
var
  StartDate, EndDate: TDateTime;
  Period: Integer;
begin
  if edOrderDate.Field.IsNull then
  begin
    MessageBox(
      Handle,
      'Внимание!',
      'Не указана дата ордера!',
      MB_OK + MB_ICONWARNING
    );
    Exit;
  end;
  if not TryStrToInt(Trim(edPeriod.Text), Period) then
  begin
    MessageBox(
      Handle,
      'Внимание!',
      'Не указан срок действаия!',
      MB_OK + MB_ICONWARNING
    );
    Exit;
  end;
  //
  StartDate := edOrderDate.Field.AsDateTime;
  EndDate := IncMonth(StartDate, Period);
  //
  edAnnulDate.Field.AsDateTime := EndDate;
end;

procedure TmstKioskForm.FormShow(Sender: TObject);
begin
  PageControl1.ActivePage := tsData;
end;

procedure TmstKioskForm.GetData(Kiosk: TmstKiosk);
begin
  cbRegion.ItemIndex := cbRegion.Items.IndexOf(Kiosk.Region);
  cbKind.ItemIndex := Integer(Kiosk.Kind);
  edExecutor.Text := Kiosk.Executor;
  edAddress.Text := Kiosk.Address;
  edArea.Text := Format('%.2f', [Kiosk.Area]);
  if Kiosk.Period > 0 then
    edPeriod.Text := IntToStr(Kiosk.Period)
  else
    edPeriod.Text := '';
  edOrderNum.Text := Kiosk.OrderNumber;
  if Kiosk.OrderDate = '' then
    edOrderDate.Clear
  else
    edOrderDate.Text := Kiosk.OrderDate;
  edLetterNum.Text := Kiosk.LetterNumber;
  if Kiosk.LetterDate = '' then
    edLetterDate.Clear
  else
    edLetterDate.Text := Kiosk.LetterDate;
  edActNum.Text := Kiosk.ActNumber;
  if Kiosk.ActDate = '' then
    edActDate.Clear
  else
    edActDate.Text := Kiosk.ActDate;
  mInfo.Text := Kiosk.Info;
  mLimit.Text := Kiosk.Limitations;
  mAnnulSource.Text := Kiosk.AnnulSource;
  if Kiosk.AnnulDate = '' then
    edAnnulDate.Clear
  else
    edAnnulDate.Text := Kiosk.AnnulDate;
  //
  cbCustomerKind.ItemIndex := Integer(Kiosk.CustomerKind);
  edCustName.Text := Kiosk.CustomerName;
  edCustAddr1.Text := Kiosk.CustomerAddress1;
  edCustAddr2.Text := Kiosk.CustomerAddress2;
  edCustINN.Text := Kiosk.CustomerINN;
  edCustPhone.Text := Kiosk.CustomerPhone;
  cbCustDocType.Text := Kiosk.CustomerDocType;
  edCustDocSerie.Text := Kiosk.CustomerDocSerie;
  edCustDocNumber.Text := Kiosk.CustomerDocNumber;
  edCustDocDate.Text := Kiosk.CustDocDate;
  edCustDocOwner.Text := Kiosk.CustDocOwner;
  //
  LoadPoints(Kiosk.Points);
  //
  Image1.Picture.Assign(Kiosk.Photo);
end;

procedure TmstKioskForm.LoadPoints(Points: TmstLotPoints);
var
  Pt: TListItem;
  I: Integer;
begin
  //
  lvPoints.Items.Clear;
  for I := 0 to Pred(Points.Count) do
  begin
    Pt := lvPoints.Items.Add;
    Pt.ImageIndex := 0;
    Pt.Caption := IntToStr(I + 1);
    Pt.SubItems.Add('');
    Pt.SubItems.Add('');
    Pt.SubItems[0] := Format('%8.2f', [Points[I].X]);
    Pt.SubItems[1] := Format('%8.2f', [Points[I].Y]);
  end;
end;

procedure TmstKioskForm.SetData(Kiosk: TmstKiosk);
var
  I: Integer;
begin
  Kiosk.Region := cbRegion.Text;
  Kiosk.Kind := TKioskKind(cbKind.ItemIndex);
  Kiosk.Executor := edExecutor.Text;
  Kiosk.Address := edAddress.Text;
  Kiosk.Area := StrToFloat(edArea.Text);
  if TryStrToInt(edPeriod.Text, I) then
    Kiosk.Period := I
  else
    Kiosk.Period := -1;
  Kiosk.OrderNumber := edOrderNum.Text;
  Kiosk.OrderDate := edOrderDate.Text;
  Kiosk.LetterNumber := edLetterNum.Text;
  Kiosk.LetterDate := edLetterDate.Text;
  Kiosk.ActNumber := edActNum.Text;
  Kiosk.ActDate := edActDate.Text;
  Kiosk.Info := mInfo.Text;
  Kiosk.Limitations := mLimit.Text;
  Kiosk.AnnulSource := mAnnulSource.Text;
  //
  Kiosk.CustomerKind := TCustomerKind(cbCustomerKind.ItemIndex);
  Kiosk.CustomerName := edCustName.Text;
  Kiosk.CustomerAddress1 := edCustAddr1.Text;
  Kiosk.CustomerAddress2 := edCustAddr2.Text;
  Kiosk.CustomerINN := edCustINN.Text;
  Kiosk.CustomerPhone := edCustPhone.Text;
  Kiosk.CustomerDocType := cbCustDocType.Text;
  Kiosk.CustomerDocSerie := edCustDocSerie.Text;
  Kiosk.CustomerDocNumber := edCustDocNumber.Text;
  Kiosk.CustDocDate := edCustDocDate.Text;
  Kiosk.CustDocOwner := edCustDocOwner.Text;
  //
  WritePoints(Kiosk.Points);
  //
  Kiosk.Photo := Image1.Picture;
end;

procedure TmstKioskForm.SetKiosk(const Value: TmstKiosk);
begin
  FKiosk := Value;
  if Assigned(FKiosk) then
    GetData(FKiosk);
end;

procedure TmstKioskForm.SetStatus(const Value: TKioskStatus);
begin
  FStatus := Value;
  case FStatus of
  ksNone :    lStatus.Caption := '';
  ksNew  :
              begin
                lStatus.Caption := 'несохранён';
                lStatus.Font.Color := clBlue;
              end;
  ksActual :
              begin
                lStatus.Caption := 'действующий';
                lStatus.Font.Color := clGreen;
              end;
  ksAnnuled :
              begin
                lStatus.Caption := 'анулирован';
                lStatus.Font.Color := clRed;
              end;
  end;
  btnAnnul.Enabled := FStatus = ksActual;
end;

procedure TmstKioskForm.WritePoints(Points: TmstLotPoints);
var
  Pt: TmstLotPoint;
  I: Integer;
  X, Y: Double;
begin
  Points.Clear;
  for I := 0 to Pred(lvPoints.Items.Count) do
  begin
    Pt := Points.AddPoint;
    Pt.Name := lvPoints.Items[I].Caption;
    if not TryStrToFloat(lvPoints.Items[I].SubItems[0], X) then
      X := 0;
    if not TryStrToFloat(lvPoints.Items[I].SubItems[1], Y) then
      Y := 0;
    Pt.X := X;
    Pt.Y := Y;
  end;
end;

end.
